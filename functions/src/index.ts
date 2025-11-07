/**
 * Firebase Cloud Functions for Gesi Halisi
 * 
 * This module contains cloud functions that integrate the Flutter app
 * with blockchain technology for cylinder NFT minting.
 */

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {ethers} from "ethers";

// Initialize Firebase Admin SDK
admin.initializeApp();

// Firestore reference
const db = admin.firestore();

// ABI for the CylinderNFT contract - only the functions we need
const CYLINDER_NFT_ABI = [
  "function mintCylinder(address to, string memory cylinderId, string memory manufacturer, string memory cylinderType, uint256 weight, uint256 capacity, string memory batchNumber, string memory uri) public returns (uint256)",
  "function getCylinderMetadata(uint256 tokenId) public view returns (tuple(string cylinderId, string manufacturer, string cylinderType, uint256 weight, uint256 capacity, string batchNumber, uint256 mintedAt, bool isActive))",
  "function totalCylinders() public view returns (uint256)",
];

/**
 * Cloud Function: onCylinderCreated
 * 
 * Triggered when a new cylinder document is created in Firestore.
 * Mints the cylinder as an NFT on the blockchain and updates the document.
 * 
 * Environment variables required:
 * - blockchain.rpc_url: The blockchain RPC endpoint
 * - blockchain.private_key: Private key for signing transactions
 * - blockchain.contract_address: Deployed CylinderNFT contract address
 */
export const onCylinderCreated = functions.firestore
  .document("cylinders/{cylinderId}")
  .onCreate(async (snapshot, context) => {
    const cylinderId = context.params.cylinderId;
    const cylinderData = snapshot.data();

    try {
      console.log(`Processing cylinder registration: ${cylinderId}`);
      console.log("Cylinder data:", cylinderData);

      // Extract metadata from the Firestore document
      const {
        serialNumber,
        manufacturer,
        manufacturerId,
        cylinderType,
        weight,
        capacity,
        batchNumber,
      } = cylinderData;

      // Validate required fields
      if (!serialNumber || !manufacturer || !cylinderType) {
        throw new Error("Missing required cylinder metadata");
      }

      // Get blockchain configuration from Firebase environment config
      const config = functions.config();
      const rpcUrl = config.blockchain?.rpc_url;
      const privateKey = config.blockchain?.private_key;
      const contractAddress = config.blockchain?.contract_address;

      if (!rpcUrl || !privateKey || !contractAddress) {
        throw new Error(
          "Blockchain configuration missing. Please set Firebase environment config."
        );
      }

      console.log("Connecting to blockchain...");
      console.log("RPC URL:", rpcUrl);
      console.log("Contract Address:", contractAddress);

      // Connect to blockchain
      const provider = new ethers.JsonRpcProvider(rpcUrl);
      const wallet = new ethers.Wallet(privateKey, provider);

      // Connect to the CylinderNFT contract
      const contract = new ethers.Contract(
        contractAddress,
        CYLINDER_NFT_ABI,
        wallet
      );

      // Prepare minting parameters
      // Convert weight and capacity to grams (if they're in kg, multiply by 1000)
      const weightInGrams = Math.round(parseFloat(weight) * 1000);
      const capacityInGrams = Math.round(parseFloat(capacity) * 1000);

      console.log("Minting cylinder NFT...");
      console.log("Parameters:", {
        to: wallet.address,
        cylinderId: serialNumber,
        manufacturer: manufacturerId || manufacturer,
        cylinderType,
        weight: weightInGrams,
        capacity: capacityInGrams,
        batchNumber: batchNumber || "N/A",
      });

      // Call mintCylinder function on the contract
      const tx = await contract.mintCylinder(
        wallet.address, // Mint to the admin wallet initially
        serialNumber,
        manufacturerId || manufacturer,
        cylinderType,
        weightInGrams,
        capacityInGrams,
        batchNumber || "N/A",
        "" // URI - can be added later if needed
      );

      console.log("Transaction sent:", tx.hash);
      console.log("Waiting for confirmation...");

      // Wait for transaction to be mined
      const receipt = await tx.wait();

      console.log("Transaction confirmed!");
      console.log("Block number:", receipt.blockNumber);
      console.log("Gas used:", receipt.gasUsed.toString());

      // Extract tokenId from transaction logs
      // The mintCylinder function returns the tokenId
      let tokenId: string | null = null;

      // Parse logs to find CylinderMinted event
      for (const log of receipt.logs) {
        try {
          const parsedLog = contract.interface.parseLog({
            topics: [...log.topics],
            data: log.data,
          });
          if (parsedLog && parsedLog.name === "CylinderMinted") {
            tokenId = parsedLog.args.tokenId.toString();
            console.log("Token ID from event:", tokenId);
            break;
          }
        } catch (e) {
          // Skip logs that can't be parsed
          continue;
        }
      }

      // If we couldn't get tokenId from events, try getting total cylinders
      if (!tokenId) {
        console.log("Could not extract tokenId from events, getting from contract...");
        const totalCylinders = await contract.totalCylinders();
        tokenId = totalCylinders.toString();
        console.log("Token ID from total cylinders:", tokenId);
      }

      // Update the Firestore document with blockchain data
      await snapshot.ref.update({
        status: "minted",
        tokenId: tokenId,
        transactionHash: receipt.hash,
        blockNumber: receipt.blockNumber,
        gasUsed: receipt.gasUsed.toString(),
        mintedAt: admin.firestore.FieldValue.serverTimestamp(),
        blockchainNetwork: rpcUrl.includes("mumbai") ? "polygon-mumbai" : 
                          rpcUrl.includes("polygon") ? "polygon" : "unknown",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.log(`✅ Successfully minted cylinder ${serialNumber} as NFT #${tokenId}`);
      console.log(`Transaction hash: ${receipt.hash}`);

      return {
        success: true,
        tokenId,
        transactionHash: receipt.hash,
      };
    } catch (error) {
      console.error("❌ Error minting cylinder NFT:", error);

      // Update document with error status
      try {
        await snapshot.ref.update({
          status: "error",
          errorMessage: error instanceof Error ? error.message : String(error),
          errorTimestamp: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      } catch (updateError) {
        console.error("Failed to update error status:", updateError);
      }

      // Re-throw the error for Cloud Functions logging
      throw error;
    }
  });

/**
 * Optional: Health check function to verify blockchain connectivity
 * Can be called via HTTP to test the setup
 */
export const checkBlockchainConnection = functions.https.onRequest(
  async (req, res) => {
    try {
      const config = functions.config();
      const rpcUrl = config.blockchain?.rpc_url;
      const contractAddress = config.blockchain?.contract_address;

      if (!rpcUrl || !contractAddress) {
        res.status(500).json({
          error: "Blockchain configuration missing",
        });
        return;
      }

      const provider = new ethers.JsonRpcProvider(rpcUrl);
      const network = await provider.getNetwork();
      const blockNumber = await provider.getBlockNumber();

      res.json({
        status: "connected",
        network: {
          name: network.name,
          chainId: network.chainId.toString(),
        },
        currentBlock: blockNumber,
        contractAddress,
      });
    } catch (error) {
      res.status(500).json({
        error: error instanceof Error ? error.message : String(error),
      });
    }
  }
);
