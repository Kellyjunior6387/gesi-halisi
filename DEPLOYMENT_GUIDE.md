# Gesi Halisi - Cylinder Registration & NFT Minting Deployment Guide

This guide walks you through deploying the complete cylinder registration system with blockchain NFT minting.

## System Overview

The system consists of three main components:

1. **Flutter Mobile App**: Manufacturer dashboard for registering cylinders
2. **Firebase Cloud Functions**: Middleware that listens to Firestore and triggers blockchain transactions
3. **Smart Contract**: ERC721 NFT contract on blockchain (Polygon) that mints cylinder NFTs

### Architecture Flow

```
Manufacturer (Flutter App)
    │
    └─► Register Cylinder
         │
         ├─► Write to Firestore (cylinders collection)
         │    - status: "pending"
         │    - serialNumber, type, weight, capacity, batch
         │
         └─► Cloud Function Triggered (onCylinderCreated)
              │
              ├─► Connect to Blockchain via ethers.js
              │
              ├─► Call mintCylinder() on Smart Contract
              │
              └─► Update Firestore Document
                   - status: "minted" or "error"
                   - tokenId, transactionHash, blockNumber
```

## Prerequisites

- Node.js 18+
- Firebase CLI (`npm install -g firebase-tools`)
- Flutter SDK 3.0+
- MetaMask wallet or similar
- Access to a blockchain network (Polygon Mumbai testnet recommended)
- Remix IDE (for contract deployment)

## Step 1: Deploy Smart Contract

### 1.1 Open Remix IDE

Go to [https://remix.ethereum.org](https://remix.ethereum.org)

### 1.2 Create Contract File

1. Create a new file: `contracts/CylinderNFT.sol`
2. Copy the contract code from `contracts/CylinderNFT.sol` in this repository

### 1.3 Install OpenZeppelin Dependencies

The contract uses OpenZeppelin libraries. Remix will automatically resolve these imports from GitHub.

### 1.4 Compile Contract

1. Go to "Solidity Compiler" tab
2. Select compiler version `0.8.20` or higher
3. Click "Compile CylinderNFT.sol"
4. Ensure compilation succeeds with no errors

### 1.5 Connect to Network

1. Install MetaMask browser extension if you haven't
2. In MetaMask:
   - Add Polygon Mumbai testnet network:
     - Network Name: `Mumbai Testnet`
     - RPC URL: `https://rpc-mumbai.maticvigil.com/`
     - Chain ID: `80001`
     - Currency Symbol: `MATIC`
     - Block Explorer: `https://mumbai.polygonscan.com/`
   - Get test MATIC from [Polygon Faucet](https://faucet.polygon.technology/)

### 1.6 Deploy Contract

1. Go to "Deploy & Run Transactions" tab in Remix
2. Select environment: "Injected Provider - MetaMask"
3. Ensure you're connected to Mumbai testnet
4. Select contract: `CylinderNFT`
5. Click "Deploy"
6. Confirm transaction in MetaMask
7. **IMPORTANT**: Copy the deployed contract address (you'll need this later)

Example deployed address: `0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb`

### 1.7 Verify Contract (Optional but Recommended)

1. Go to [Mumbai PolygonScan](https://mumbai.polygonscan.com/)
2. Search for your contract address
3. Click "Verify and Publish"
4. Follow the wizard to verify your contract source code

## Step 2: Set Up Firebase Functions

### 2.1 Install Dependencies

```bash
cd functions
npm install
```

### 2.2 Build TypeScript

```bash
npm run build
```

Verify that the `lib` directory is created with compiled JavaScript.

### 2.3 Configure Firebase Environment

Set up environment variables with your blockchain credentials:

```bash
firebase functions:config:set \
  blockchain.rpc_url="https://rpc-mumbai.maticvigil.com/" \
  blockchain.private_key="YOUR_PRIVATE_KEY_HERE" \
  blockchain.contract_address="YOUR_DEPLOYED_CONTRACT_ADDRESS"
```

**⚠️ IMPORTANT SECURITY NOTES:**

- **Private Key**: Export from MetaMask (Account Details → Export Private Key)
- Use a **dedicated wallet** for the application (not your personal wallet)
- Ensure this wallet has sufficient MATIC for gas fees
- **NEVER** commit private keys to Git
- Keep at least 1-2 MATIC in the wallet for gas fees

**Getting Your Private Key from MetaMask:**
1. Open MetaMask
2. Click the three dots menu
3. Account Details
4. Export Private Key
5. Enter your password
6. Copy the private key (starts with `0x`)

### 2.4 Verify Configuration

```bash
firebase functions:config:get
```

Should output:
```json
{
  "blockchain": {
    "rpc_url": "https://rpc-mumbai.maticvigil.com/",
    "private_key": "0x...",
    "contract_address": "0x..."
  }
}
```

### 2.5 Deploy Functions

```bash
# Make sure you're logged into Firebase
firebase login

# Deploy functions
cd functions
npm run deploy
```

Or deploy all Firebase resources:
```bash
firebase deploy
```

### 2.6 Test Functions

Test the blockchain connection health check:

```bash
curl https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net/checkBlockchainConnection
```

Should return:
```json
{
  "status": "connected",
  "network": {
    "name": "matic-mumbai",
    "chainId": "80001"
  },
  "currentBlock": 12345678,
  "contractAddress": "0x..."
}
```

## Step 3: Configure Flutter App

### 3.1 Update Firebase Configuration

The Flutter app should already be configured with Firebase. Verify:

```bash
cd frontend
cat lib/firebase_options.dart
```

### 3.2 Install Dependencies

```bash
cd frontend
flutter pub get
```

### 3.3 Run the App

```bash
# For web
flutter run -d chrome

# For Android emulator
flutter run

# For iOS simulator
flutter run -d ios
```

## Step 4: Test the Complete Flow

### 4.1 Register a Cylinder

1. Open the Flutter app
2. Log in as a manufacturer
3. Go to "Cylinders" screen
4. Click "Register Cylinder" button
5. Fill in the form:
   - Serial Number: `CYL-TEST-001`
   - Type: `LPG`
   - Capacity: `14.2`
   - Batch Number: `BATCH-2024-01`
6. Click "Register"

### 4.2 Monitor the Process

**In the Flutter app:**
- You should see a success message: "Cylinder registered successfully! NFT minting in progress..."
- The cylinder should appear in the list with status "Pending"

**In Firebase Console:**
1. Go to Firestore
2. Open `cylinders` collection
3. Find your cylinder document
4. Initially: `status: "pending"`
5. After ~10-30 seconds: `status: "minted"` with `tokenId`, `transactionHash`, etc.

**In Firebase Functions Logs:**
```bash
firebase functions:log --only onCylinderCreated
```

Look for:
```
Processing cylinder registration: CYL-TEST-001
Connecting to blockchain...
Minting cylinder NFT...
Transaction sent: 0x...
✅ Successfully minted cylinder CYL-TEST-001 as NFT #1
```

**On Blockchain Explorer:**
1. Copy the `transactionHash` from Firestore
2. Go to [Mumbai PolygonScan](https://mumbai.polygonscan.com/)
3. Paste transaction hash in search
4. Verify the transaction succeeded

### 4.3 Verify NFT Minting

In Remix IDE:
1. Load your deployed contract
2. Call `totalCylinders()` - should return `1`
3. Call `getCylinderMetadata(1)` - should return your cylinder's metadata
4. Call `getTokenIdByCylinderId("CYL-TEST-001")` - should return `1`

## Troubleshooting

### Issue: "Blockchain configuration missing"

**Solution:**
```bash
firebase functions:config:set \
  blockchain.rpc_url="..." \
  blockchain.private_key="..." \
  blockchain.contract_address="..."
firebase deploy --only functions
```

### Issue: "insufficient funds for gas"

**Solution:**
- Get test MATIC from [Polygon Faucet](https://faucet.polygon.technology/)
- Ensure wallet has at least 1-2 MATIC

### Issue: Function not triggering

**Check:**
1. Firestore security rules allow function access
2. Function is deployed: `firebase deploy --only functions`
3. Function logs: `firebase functions:log`

### Issue: Transaction failing

**Check:**
1. Contract address is correct
2. RPC URL is accessible
3. Private key is valid
4. Wallet has enough gas
5. Contract is deployed on the correct network

### Issue: "execution reverted"

**Possible causes:**
- Duplicate cylinder ID (already minted)
- Invalid parameters
- Contract not properly deployed

**Solution:**
- Use unique serial numbers
- Verify contract deployment
- Check function logs for details

## Production Deployment

### For Production (Polygon Mainnet):

1. **Deploy contract to Polygon mainnet:**
   - RPC URL: `https://polygon-rpc.com/`
   - Get real MATIC from exchanges

2. **Update Firebase config:**
   ```bash
   firebase functions:config:set \
     blockchain.rpc_url="https://polygon-rpc.com/" \
     blockchain.private_key="..." \
     blockchain.contract_address="..."
   ```

3. **Security checklist:**
   - [ ] Use dedicated wallet for application
   - [ ] Private key stored only in Firebase environment config
   - [ ] Contract verified on PolygonScan
   - [ ] Firestore security rules properly configured
   - [ ] Monitor wallet balance alerts
   - [ ] Set up transaction monitoring

## Cost Estimates

### Development (Mumbai Testnet)
- **Smart Contract Deployment**: Free (test MATIC)
- **NFT Minting**: Free (test MATIC)
- **Firebase Functions**: Free tier (2M invocations/month)

### Production (Polygon Mainnet)
- **Smart Contract Deployment**: ~$2-5 (one-time)
- **NFT Minting per cylinder**: ~$0.01-0.05 MATIC (~$0.01-0.05 USD)
- **Firebase Functions**: $0.40 per million invocations
- **Firestore**: Pay as you go (very cheap for typical usage)

**Monthly cost for 1000 cylinders:**
- Blockchain: ~$10-50
- Firebase: ~$5-10
- **Total: ~$15-60/month**

## Monitoring & Maintenance

### Set Up Alerts

1. **Firebase Cloud Functions:**
   - Monitor error rates
   - Set up Stackdriver alerts

2. **Wallet Balance:**
   - Set up alerts when MATIC balance is low
   - Auto-refill or manual monitoring

3. **Firestore:**
   - Monitor document counts
   - Check for errors in status field

### Regular Tasks

- **Weekly**: Check wallet balance
- **Monthly**: Review transaction costs
- **Quarterly**: Update dependencies
- **As needed**: Rotate private keys

## Next Steps

1. ✅ Deploy smart contract to Mumbai testnet
2. ✅ Configure Firebase Functions
3. ✅ Test complete flow end-to-end
4. 📱 Implement QR code generation using tokenId
5. 📱 Add QR code scanning for verification
6. 🔐 Implement access control for contract owner
7. 🚀 Deploy to production (Polygon mainnet)
8. 📊 Set up monitoring and analytics

## Support Resources

- **Smart Contract**: See `contracts/README.md`
- **Firebase Functions**: See `functions/README.md`
- **Polygon Documentation**: https://docs.polygon.technology/
- **Firebase Documentation**: https://firebase.google.com/docs
- **Remix IDE**: https://remix.ethereum.org/
- **Mumbai Faucet**: https://faucet.polygon.technology/
- **Mumbai Explorer**: https://mumbai.polygonscan.com/

## Security Best Practices

1. **Never commit secrets** (private keys, API keys) to Git
2. **Use environment variables** for all sensitive data
3. **Rotate keys periodically** (quarterly recommended)
4. **Monitor transactions** for suspicious activity
5. **Use a dedicated wallet** for the application
6. **Keep wallet funded** but not excessively
7. **Test on testnet first** before going to mainnet
8. **Verify contracts** on block explorers
9. **Set up proper Firestore rules** to prevent unauthorized access
10. **Enable 2FA** on all accounts (Firebase, GitHub, etc.)

## Conclusion

You now have a complete blockchain-integrated cylinder registration system! Manufacturers can register cylinders through the Flutter app, which automatically mints them as NFTs on the blockchain. Each cylinder has a unique, verifiable, and immutable record on the blockchain that can be used for tracking, authentication, and QR code generation.
