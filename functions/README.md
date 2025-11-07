# Firebase Cloud Functions - Gesi Halisi

This directory contains Firebase Cloud Functions that enable blockchain integration for the Gesi Halisi application.

## Overview

The main function `onCylinderCreated` listens to Firestore document creation in the `cylinders` collection and automatically mints the cylinder as an NFT on the blockchain.

## Prerequisites

1. **Node.js**: Version 18 or higher
2. **Firebase CLI**: Install globally
   ```bash
   npm install -g firebase-tools
   ```
3. **Firebase Project**: You must have a Firebase project set up
4. **Blockchain Network**: Access to a blockchain network (e.g., Polygon Mumbai testnet)
5. **Deployed Smart Contract**: CylinderNFT contract must be deployed (see `../contracts/README.md`)

## Installation

1. Navigate to the functions directory:
   ```bash
   cd functions
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

## Configuration

Set up Firebase environment configuration with your blockchain credentials:

```bash
firebase functions:config:set \
  blockchain.rpc_url="https://rpc-mumbai.maticvigil.com/" \
  blockchain.private_key="YOUR_PRIVATE_KEY_HERE" \
  blockchain.contract_address="YOUR_CONTRACT_ADDRESS_HERE"
```

### Getting Configuration Values

1. **RPC URL**: 
   - Polygon Mumbai (testnet): `https://rpc-mumbai.maticvigil.com/`
   - Polygon Mainnet: `https://polygon-rpc.com/`
   - Or use services like Infura or Alchemy

2. **Private Key**: 
   - Export from MetaMask or your wallet
   - ⚠️ **NEVER** commit this to Git
   - Use a dedicated wallet for the application
   - Ensure the wallet has enough gas tokens

3. **Contract Address**: 
   - Deploy the CylinderNFT contract (see `../contracts/README.md`)
   - Copy the deployed contract address

### View Current Configuration

```bash
firebase functions:config:get
```

## Development

### Build TypeScript

```bash
npm run build
```

### Test Locally

Use Firebase Emulators to test functions locally:

```bash
npm run serve
```

This starts the Firebase emulators for Functions and Firestore.

### Deploy to Firebase

```bash
npm run deploy
```

Or deploy only specific functions:

```bash
firebase deploy --only functions:onCylinderCreated
```

## Functions

### onCylinderCreated

**Trigger**: Firestore `onCreate` event in `cylinders/{cylinderId}` collection

**What it does**:
1. Listens for new cylinder documents in Firestore
2. Extracts cylinder metadata (serialNumber, manufacturer, type, weight, capacity, batch)
3. Connects to blockchain using configured RPC URL and private key
4. Calls `mintCylinder` function on the CylinderNFT smart contract
5. Waits for transaction confirmation
6. Updates Firestore document with:
   - `status: "minted"` (on success) or `"error"` (on failure)
   - `tokenId`: NFT token ID
   - `transactionHash`: Blockchain transaction hash
   - `blockNumber`: Block number of the transaction
   - `gasUsed`: Gas consumed by the transaction
   - `blockchainNetwork`: Network identifier
   - `errorMessage`: Error details (if failed)

**Example Firestore Document Before**:
```json
{
  "serialNumber": "CYL-2024-001",
  "manufacturer": "Acme Gas Co",
  "manufacturerId": "user123",
  "cylinderType": "LPG",
  "weight": 14.2,
  "capacity": 14.2,
  "batchNumber": "BATCH-2024-01",
  "status": "pending",
  "createdAt": "2024-01-15T10:00:00Z"
}
```

**Example Firestore Document After (Success)**:
```json
{
  "serialNumber": "CYL-2024-001",
  "manufacturer": "Acme Gas Co",
  "manufacturerId": "user123",
  "cylinderType": "LPG",
  "weight": 14.2,
  "capacity": 14.2,
  "batchNumber": "BATCH-2024-01",
  "status": "minted",
  "tokenId": "1",
  "transactionHash": "0x1234567890abcdef...",
  "blockNumber": 12345678,
  "gasUsed": "185432",
  "blockchainNetwork": "polygon-mumbai",
  "createdAt": "2024-01-15T10:00:00Z",
  "mintedAt": "2024-01-15T10:00:15Z",
  "updatedAt": "2024-01-15T10:00:15Z"
}
```

### checkBlockchainConnection (HTTP)

**Trigger**: HTTP GET request

**What it does**:
- Tests blockchain connectivity
- Returns network info and current block number
- Useful for health checks and debugging

**Usage**:
```bash
curl https://YOUR_REGION-YOUR_PROJECT.cloudfunctions.net/checkBlockchainConnection
```

## Monitoring

### View Logs

```bash
npm run logs
```

Or in Firebase Console:
1. Go to Firebase Console
2. Navigate to Functions
3. Click on the function name
4. View logs in the "Logs" tab

### Common Log Messages

- `✅ Successfully minted cylinder...`: Successful minting
- `❌ Error minting cylinder NFT:`: Minting failed
- `⏳ Processing cylinder registration:`: Function triggered
- `📝 Transaction sent:`: Blockchain transaction submitted

## Troubleshooting

### Function Not Triggering

1. Check Firestore rules allow function access
2. Verify function is deployed: `firebase deploy --only functions`
3. Check Firebase Console logs for errors

### Blockchain Connection Errors

1. **"insufficient funds for gas"**: Wallet needs more tokens
   - Get test tokens from [Polygon Faucet](https://faucet.polygon.technology/)
2. **"invalid RPC URL"**: Check the RPC URL is correct
3. **"contract not found"**: Verify contract address is correct
4. **"execution reverted"**: Check smart contract is properly deployed

### Configuration Not Set

If you get "Blockchain configuration missing":
```bash
firebase functions:config:set blockchain.rpc_url="..." blockchain.private_key="..." blockchain.contract_address="..."
firebase deploy --only functions
```

### Testing the Flow

1. Register a cylinder from the Flutter app
2. Check Firebase Console > Firestore > cylinders collection
3. Document should have `status: "pending"` initially
4. After ~10-30 seconds, status should change to `"minted"` or `"error"`
5. Check Functions logs for details

## Security Best Practices

1. **Private Key Security**:
   - Never commit private keys to version control
   - Use Firebase environment config (stored securely)
   - Use a dedicated wallet for the application
   - Rotate keys periodically

2. **Access Control**:
   - Set proper Firestore security rules
   - Only allow authenticated manufacturers to write cylinders
   - Functions automatically have admin access

3. **Rate Limiting**:
   - Consider implementing rate limiting for cylinder registration
   - Monitor for suspicious activity

4. **Gas Management**:
   - Monitor wallet balance
   - Set up alerts for low balance
   - Estimate gas costs: ~$0.01-0.05 per mint on Polygon

## Cost Estimates

### Firebase Functions
- Free tier: 2 million invocations/month
- Paid: $0.40 per million invocations

### Blockchain Gas Fees (Polygon Mumbai - Testnet)
- Free (testnet tokens)

### Blockchain Gas Fees (Polygon Mainnet)
- ~0.01-0.05 MATIC per transaction (~$0.01-0.05 USD)
- Much cheaper than Ethereum mainnet

## Architecture Diagram

```
Flutter App
    │
    ├─> Firestore (cylinders collection)
    │       │
    │       └─> Cloud Function (onCylinderCreated)
    │               │
    │               ├─> ethers.js
    │               │
    │               └─> Blockchain (CylinderNFT contract)
    │                       │
    │                       └─> NFT Minted
    │
    └─> Updates shown in real-time via Firestore streams
```

## Next Steps

1. Deploy the smart contract (see `../contracts/README.md`)
2. Configure Firebase environment variables
3. Deploy the functions: `npm run deploy`
4. Test with the Flutter app
5. Monitor logs and transactions
6. Set up production environment on Polygon mainnet

## Support

For issues or questions:
1. Check Firebase Functions logs
2. Check Firestore data structure
3. Verify smart contract deployment
4. Test with `checkBlockchainConnection` endpoint
5. Review blockchain transaction on explorer (polygonscan.com)
