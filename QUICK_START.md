# Cylinder Registration & NFT Minting - Quick Reference

## 📋 Quick Setup Checklist

### Phase 1: Smart Contract Deployment
- [ ] Open Remix IDE (https://remix.ethereum.org)
- [ ] Copy `contracts/CylinderNFT.sol`
- [ ] Compile with Solidity 0.8.20+
- [ ] Connect MetaMask to Polygon Mumbai
- [ ] Get test MATIC from faucet
- [ ] Deploy contract
- [ ] **Save contract address**: `0x...`

### Phase 2: Firebase Functions
- [ ] `cd functions && npm install`
- [ ] `npm run build`
- [ ] Configure environment:
  ```bash
  firebase functions:config:set \
    blockchain.rpc_url="https://rpc-mumbai.maticvigil.com/" \
    blockchain.private_key="0x..." \
    blockchain.contract_address="0x..."
  ```
- [ ] `firebase deploy --only functions`
- [ ] Test: `curl https://...cloudfunctions.net/checkBlockchainConnection`

### Phase 3: Flutter App
- [ ] `cd frontend && flutter pub get`
- [ ] `flutter run`
- [ ] Login as manufacturer
- [ ] Register test cylinder
- [ ] Verify NFT minted

## 🔑 Key Commands

### Smart Contract (Remix)
```solidity
// After deployment, test these functions:
totalCylinders()                              // Returns: total NFTs minted
getCylinderMetadata(1)                        // Returns: cylinder data for token #1
getTokenIdByCylinderId("CYL-2024-001")       // Returns: token ID for serial number
getCylindersByManufacturer("0x...")          // Returns: array of token IDs
isCylinderActive(1)                          // Returns: true/false
```

### Firebase Functions
```bash
# Deploy
cd functions
npm run deploy

# View logs
firebase functions:log

# View specific function logs
firebase functions:log --only onCylinderCreated

# Get config
firebase functions:config:get

# Set config
firebase functions:config:set key.subkey="value"

# Test locally
npm run serve
```

### Flutter App
```bash
# Get dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Run on Android
flutter run

# Build release APK
flutter build apk --release

# Analyze code
flutter analyze
```

## 📝 Data Models

### Firestore Cylinder Document (Before Minting)
```json
{
  "serialNumber": "CYL-2024-001",
  "manufacturer": "Acme Gas Co",
  "manufacturerId": "user_abc123",
  "cylinderType": "LPG",
  "weight": 14.2,
  "capacity": 14.2,
  "batchNumber": "BATCH-2024-01",
  "status": "pending",
  "createdAt": "2024-01-15T10:00:00Z"
}
```

### Firestore Cylinder Document (After Minting)
```json
{
  "serialNumber": "CYL-2024-001",
  "manufacturer": "Acme Gas Co",
  "manufacturerId": "user_abc123",
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
  "mintedAt": "2024-01-15T10:00:15Z",
  "createdAt": "2024-01-15T10:00:00Z",
  "updatedAt": "2024-01-15T10:00:15Z"
}
```

## 🔍 Debugging

### Check if Cloud Function is Triggering
```bash
# View real-time logs
firebase functions:log --follow

# Should see:
# "Processing cylinder registration: CYL-XXX"
# "Connecting to blockchain..."
# "Transaction sent: 0x..."
# "✅ Successfully minted cylinder..."
```

### Check Transaction on Blockchain
1. Copy `transactionHash` from Firestore
2. Go to https://mumbai.polygonscan.com/
3. Paste hash in search
4. Verify transaction status: ✅ Success

### Common Error Messages

| Error | Cause | Solution |
|-------|-------|----------|
| "Blockchain configuration missing" | Environment config not set | Run `firebase functions:config:set` |
| "insufficient funds for gas" | Wallet has no MATIC | Get test MATIC from faucet |
| "execution reverted" | Duplicate cylinder ID or invalid params | Use unique serial numbers |
| "contract not found" | Wrong contract address | Verify contract address |
| "Function not triggering" | Firestore trigger not working | Check Firestore rules, redeploy functions |

## 🌐 Important URLs

### Development (Testnet)
- **RPC URL**: `https://rpc-mumbai.maticvigil.com/`
- **Chain ID**: `80001`
- **Explorer**: https://mumbai.polygonscan.com/
- **Faucet**: https://faucet.polygon.technology/
- **Remix IDE**: https://remix.ethereum.org

### Production (Mainnet)
- **RPC URL**: `https://polygon-rpc.com/`
- **Chain ID**: `137`
- **Explorer**: https://polygonscan.com/

## 💡 Tips & Best Practices

### Security
- ✅ Never commit private keys
- ✅ Use dedicated wallet for application
- ✅ Keep wallet funded but not excessively
- ✅ Test on testnet first
- ✅ Verify contracts on explorer

### Development
- ✅ Use descriptive serial numbers (e.g., `CYL-2024-001`)
- ✅ Monitor Firebase logs during development
- ✅ Check blockchain explorer for all transactions
- ✅ Keep notes of deployed contract addresses

### Production
- ✅ Set up wallet balance alerts
- ✅ Monitor Cloud Function error rates
- ✅ Regular backups of Firestore
- ✅ Document all contract addresses
- ✅ Plan for key rotation

## 📊 Gas Costs (Approximate)

| Operation | Mumbai (Testnet) | Polygon Mainnet |
|-----------|------------------|-----------------|
| Contract Deploy | Free | $2-5 |
| Mint Cylinder | Free | $0.01-0.05 |
| Query (view) | Free | Free |

## 🎯 Testing Workflow

1. **Deploy contract** → Get contract address
2. **Configure Firebase** → Set environment variables
3. **Deploy functions** → Verify deployment
4. **Test connection** → Call health check endpoint
5. **Register cylinder** → Via Flutter app
6. **Monitor logs** → Firebase Functions logs
7. **Check Firestore** → Verify status update
8. **Verify on-chain** → PolygonScan transaction
9. **Test queries** → Call contract view functions

## 🔄 Status Flow

```
User Registers Cylinder
         ↓
    [status: pending]
         ↓
Cloud Function Triggered
         ↓
  Blockchain Transaction
         ↓
    ┌─────────┴─────────┐
    ↓                   ↓
[status: minted]    [status: error]
 + tokenId           + errorMessage
 + txHash
```

## 📞 Support Checklist

If something goes wrong:

1. **Check Firebase Logs**
   ```bash
   firebase functions:log
   ```

2. **Verify Configuration**
   ```bash
   firebase functions:config:get
   ```

3. **Test Blockchain Connection**
   ```bash
   curl https://...cloudfunctions.net/checkBlockchainConnection
   ```

4. **Check Wallet Balance**
   - Open MetaMask
   - Verify MATIC balance > 0.5

5. **Verify Contract**
   - Check contract address is correct
   - Test contract in Remix

6. **Review Firestore Data**
   - Check document exists
   - Verify field names match code
   - Look for error messages

## 🎓 Learning Resources

- **Solidity**: https://docs.soliditylang.org/
- **ethers.js**: https://docs.ethers.org/
- **Polygon**: https://docs.polygon.technology/
- **Firebase Functions**: https://firebase.google.com/docs/functions
- **Flutter Firebase**: https://firebase.flutter.dev/

## 📈 Next Steps After Setup

- [ ] Implement QR code generation from tokenId
- [ ] Add QR scanner for cylinder verification
- [ ] Create customer-facing verification app
- [ ] Add batch cylinder registration
- [ ] Implement transfer functionality
- [ ] Add analytics dashboard
- [ ] Set up production monitoring
- [ ] Deploy to mainnet

---

**Quick tip**: Bookmark this page and the deployment guide for easy reference during setup!
