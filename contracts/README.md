# Gesi Halisi - Cylinder NFT Smart Contract

## Overview
This smart contract implements an ERC721 NFT for tracking gas cylinders on the blockchain. Each cylinder is minted as a unique NFT with comprehensive metadata stored on-chain.

## Contract: CylinderNFT

### Features
- **ERC721 Compliant**: Standard NFT implementation with URI storage
- **On-chain Metadata**: Stores cylinder details directly on the blockchain
- **Manufacturer Tracking**: Track all cylinders by manufacturer
- **Cylinder Lifecycle**: Activate/deactivate cylinders
- **Unique Identifiers**: Prevent duplicate cylinder IDs

### Data Structure
Each cylinder NFT includes:
- `cylinderId`: Unique identifier (e.g., "CYL-2024-001")
- `manufacturer`: Manufacturer name or wallet address
- `cylinderType`: Type of gas (LPG, Oxygen, CO2, Nitrogen)
- `weight`: Empty weight in grams
- `capacity`: Capacity in grams
- `batchNumber`: Manufacturing batch
- `mintedAt`: Timestamp of minting
- `isActive`: Status flag

### Key Functions

#### `mintCylinder`
```solidity
function mintCylinder(
    address to,
    string memory cylinderId,
    string memory manufacturer,
    string memory cylinderType,
    uint256 weight,
    uint256 capacity,
    string memory batchNumber,
    string memory uri
) public onlyOwner returns (uint256)
```
Mints a new cylinder NFT. Only callable by contract owner.

**Returns**: Token ID of the newly minted NFT

#### `getCylinderMetadata`
```solidity
function getCylinderMetadata(uint256 tokenId) public view returns (CylinderMetadata memory)
```
Retrieves full metadata for a cylinder by token ID.

#### `getTokenIdByCylinderId`
```solidity
function getTokenIdByCylinderId(string memory cylinderId) public view returns (uint256)
```
Looks up token ID using the cylinder ID string.

#### `getCylindersByManufacturer`
```solidity
function getCylindersByManufacturer(string memory manufacturer) public view returns (uint256[] memory)
```
Gets all token IDs for a specific manufacturer.

#### `deactivateCylinder` / `reactivateCylinder`
```solidity
function deactivateCylinder(uint256 tokenId) public onlyOwner
function reactivateCylinder(uint256 tokenId) public onlyOwner
```
Mark cylinders as inactive (retired/destroyed) or reactivate them.

### Events
- `CylinderMinted`: Emitted when a new cylinder is minted
- `CylinderDeactivated`: Emitted when a cylinder is deactivated
- `CylinderReactivated`: Emitted when a cylinder is reactivated

## Deployment Instructions

### Using Remix IDE

1. **Open Remix IDE**: Go to [remix.ethereum.org](https://remix.ethereum.org)

2. **Create New File**: Create a new file named `CylinderNFT.sol`

3. **Copy Contract**: Paste the contract code from `CylinderNFT.sol`

4. **Install OpenZeppelin**: 
   - In Remix, go to the "File Explorer" tab
   - The contract imports will be auto-resolved from GitHub
   - Or manually add OpenZeppelin contracts via the Plugin Manager

5. **Compile**:
   - Select compiler version `0.8.20` or higher
   - Click "Compile CylinderNFT.sol"

6. **Deploy**:
   - Go to "Deploy & Run Transactions" tab
   - Select your environment:
     - **JavaScript VM**: For testing (local blockchain)
     - **Injected Provider - MetaMask**: For testnets or mainnet
     - **Polygon Mumbai**: Recommended testnet for low fees
   - Click "Deploy"
   - Confirm the transaction in MetaMask

7. **Copy Contract Address**: After deployment, copy the contract address

8. **Configure Firebase**:
   ```bash
   firebase functions:config:set \
     blockchain.rpc_url="YOUR_RPC_URL" \
     blockchain.private_key="YOUR_PRIVATE_KEY" \
     blockchain.contract_address="YOUR_CONTRACT_ADDRESS"
   ```

### Recommended Networks

#### Testnet (Recommended for Development)
- **Polygon Mumbai**: Low gas fees, fast confirmations
  - RPC: `https://rpc-mumbai.maticvigil.com/`
  - Faucet: [Mumbai Faucet](https://faucet.polygon.technology/)

#### Mainnet (Production)
- **Polygon**: Low gas fees on mainnet
  - RPC: `https://polygon-rpc.com/`

### Getting Test Tokens
1. Get Mumbai MATIC from [Polygon Faucet](https://faucet.polygon.technology/)
2. Use the tokens to deploy and interact with the contract

## Integration with Firebase Cloud Functions

The contract is designed to work with Firebase Cloud Functions:

1. Cloud Function listens to Firestore `cylinders` collection
2. When a new cylinder is added, function calls `mintCylinder`
3. Transaction hash and token ID are stored back in Firestore
4. Status is updated to "minted" or "error"

## QR Code Generation

The token ID and transaction hash can be used to generate QR codes:
- Encode: `{tokenId: 123, txHash: "0x...", cylinderId: "CYL-2024-001"}`
- QR codes can be scanned to verify cylinder authenticity
- Link to blockchain explorer for verification

## Security Considerations

1. **Owner Only Minting**: Only contract owner can mint cylinders
2. **Unique Cylinder IDs**: Prevents duplicate cylinders
3. **Non-transferable (Optional)**: Consider overriding transfer functions if cylinders shouldn't be traded
4. **Access Control**: Use the Ownable pattern for administrative functions

## Testing

### Test Cases
1. Mint a cylinder with valid data
2. Try to mint duplicate cylinder ID (should fail)
3. Get cylinder metadata by token ID
4. Look up token ID by cylinder ID
5. Get all cylinders for a manufacturer
6. Deactivate and reactivate cylinders
7. Check total cylinders count

### Example Minting Call
```javascript
// Using ethers.js
const tx = await contract.mintCylinder(
  "0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb",  // to address
  "CYL-2024-001",                                  // cylinderId
  "0x1234...5678",                                 // manufacturer address
  "LPG",                                           // cylinderType
  14200,                                           // weight (grams)
  14200,                                           // capacity (grams)
  "BATCH-2024-01",                                 // batchNumber
  ""                                               // uri (optional)
);
await tx.wait();
```

## Gas Estimates
- Deployment: ~2,500,000 gas
- Minting: ~150,000-200,000 gas per cylinder
- Query functions: Free (view functions)

## License
MIT License - See contract header for details
