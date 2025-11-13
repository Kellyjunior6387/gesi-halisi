# Gesi Halisi - Blockchain-Integrated Cylinder Management System

A comprehensive gas cylinder tracking and authentication system that combines Flutter mobile app, Firebase backend, and blockchain (NFT) technology to ensure cylinder authenticity and traceability.

## 🌟 Features

### For Manufacturers
- **Digital Cylinder Registration**: Register gas cylinders with detailed metadata
- **Automated NFT Minting**: Each cylinder is automatically minted as a blockchain NFT
- **Real-time Tracking**: Monitor cylinder status (pending, minted, error)
- **Blockchain Verification**: Each cylinder has an immutable record on the blockchain
- **Dashboard Analytics**: View statistics and manage inventory

### Technical Features
- **ERC721 NFT Standard**: Industry-standard NFT implementation
- **On-chain Metadata**: Cylinder details stored directly on blockchain
- **Firebase Integration**: Real-time database with Cloud Functions
- **Secure Transactions**: Automated blockchain transactions via Cloud Functions
- **Multi-network Support**: Works on Polygon (low gas fees)
- **QR Code Ready**: Token IDs ready for QR code generation

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter Mobile App                      │
│  (Manufacturer Dashboard, Cylinder Registration UI)        │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────┐
│                    Firebase Firestore                       │
│         (cylinders collection - status: pending)            │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  ▼ (onCreate Trigger)
┌─────────────────────────────────────────────────────────────┐
│              Firebase Cloud Function                        │
│    - Extract cylinder metadata from Firestore              │
│    - Connect to blockchain via ethers.js                   │
│    - Call mintCylinder() on smart contract                 │
│    - Update Firestore with tokenId & txHash                │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────┐
│           Blockchain (Polygon Network)                      │
│         CylinderNFT Smart Contract (ERC721)                │
│  - Mints unique NFT for each cylinder                      │
│  - Stores metadata on-chain                                │
│  - Returns tokenId and transaction hash                    │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Project Structure

```
gesi-halisi/
├── contracts/                   # Smart contracts
│   ├── CylinderNFT.sol         # Main ERC721 NFT contract
│   └── README.md               # Contract documentation
├── functions/                   # Firebase Cloud Functions
│   ├── src/
│   │   └── index.ts            # Cloud function implementation
│   ├── package.json            # Node.js dependencies
│   ├── tsconfig.json           # TypeScript configuration
│   └── README.md               # Functions documentation
├── frontend/                    # Flutter application
│   ├── lib/
│   │   ├── models/
│   │   │   ├── cylinder_model.dart    # Cylinder data model
│   │   │   └── user_model.dart        # User data model
│   │   ├── services/
│   │   │   ├── firestore_service.dart # Firestore operations
│   │   │   └── auth_service.dart      # Authentication
│   │   ├── screens/
│   │   │   └── dashboard/
│   │   │       ├── cylinders_screen.dart  # Cylinder list view
│   │   │       └── ...
│   │   └── widgets/
│   │       └── dashboard/
│   │           ├── register_cylinder_dialog.dart  # Registration form
│   │           └── ...
│   └── pubspec.yaml            # Flutter dependencies
├── DEPLOYMENT_GUIDE.md         # Step-by-step deployment guide
└── README.md                   # This file
```

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- Flutter SDK 3.0+
- Firebase CLI
- MetaMask wallet
- Remix IDE (for contract deployment)

### 1. Clone Repository

```bash
git clone https://github.com/Kellyjunior6387/gesi-halisi.git
cd gesi-halisi
```

### 2. Deploy Smart Contract

See detailed instructions in [`contracts/README.md`](contracts/README.md)

**Quick steps:**
1. Open [Remix IDE](https://remix.ethereum.org)
2. Create and compile `CylinderNFT.sol`
3. Connect MetaMask to Polygon Mumbai testnet
4. Deploy contract
5. Copy contract address

### 3. Set Up Firebase Functions

See detailed instructions in [`functions/README.md`](functions/README.md)

```bash
cd functions
npm install
npm run build

# Configure blockchain credentials
firebase functions:config:set \
  blockchain.rpc_url="https://rpc-mumbai.maticvigil.com/" \
  blockchain.private_key="YOUR_PRIVATE_KEY" \
  blockchain.contract_address="YOUR_CONTRACT_ADDRESS"

# Deploy
npm run deploy
```

### 4. Run Flutter App

```bash
cd frontend
flutter pub get
flutter run
```

### 5. Test Registration

1. Log in as a manufacturer
2. Navigate to "Cylinders" screen
3. Click "Register Cylinder"
4. Fill in cylinder details
5. Submit and watch the NFT minting happen automatically!

## 📖 Documentation

- **[Deployment Guide](DEPLOYMENT_GUIDE.md)**: Complete step-by-step deployment instructions
- **[Smart Contract Documentation](contracts/README.md)**: Contract functions, deployment, and testing
- **[Cloud Functions Documentation](functions/README.md)**: Function configuration, monitoring, and troubleshooting

## 🔧 Technology Stack

### Frontend
- **Flutter**: Cross-platform mobile framework
- **Firebase Auth**: User authentication
- **Cloud Firestore**: Real-time database
- **Provider**: State management

### Backend
- **Firebase Cloud Functions**: Serverless backend
- **TypeScript**: Type-safe server code
- **ethers.js**: Ethereum/Polygon blockchain interaction
- **Firebase Admin SDK**: Server-side Firebase access

### Blockchain
- **Solidity**: Smart contract language
- **OpenZeppelin**: Secure contract libraries
- **Polygon**: Low-cost Ethereum-compatible blockchain
- **ERC721**: NFT standard

## 💰 Cost Estimates

### Development (Testnet)
- **Deployment**: Free (test tokens)
- **Minting**: Free (test tokens)
- **Firebase**: Free tier

### Production (Polygon Mainnet)
- **Contract Deployment**: ~$2-5 (one-time)
- **Per Cylinder Minting**: ~$0.01-0.05
- **Firebase Functions**: $0.40 per million invocations
- **Monthly (1000 cylinders)**: ~$15-60

## 🔐 Security Features

- ✅ Private keys stored in Firebase environment config (never in code)
- ✅ Firestore security rules
- ✅ ERC721 standard compliance
- ✅ Ownable contract pattern
- ✅ Unique cylinder ID validation
- ✅ Error handling and transaction verification
- ✅ Immutable blockchain records

## 🎯 Use Cases

1. **Cylinder Authentication**: Verify genuine cylinders via blockchain
2. **Supply Chain Tracking**: Track cylinder lifecycle from manufacturing
3. **QR Code Verification**: Generate QR codes from tokenIds for scanning
4. **Anti-counterfeiting**: Immutable proof of authenticity
5. **Regulatory Compliance**: Transparent record-keeping
6. **Customer Trust**: Customers can verify cylinder authenticity

## 🔄 Workflow

1. **Manufacturer registers cylinder** in Flutter app
2. **Data written to Firestore** with status "pending"
3. **Cloud Function triggered** automatically
4. **Function mints NFT** on blockchain
5. **Firestore updated** with tokenId, txHash, status "minted"
6. **Real-time UI update** shows minted status
7. **QR code can be generated** from tokenId for physical cylinder

## 🧪 Testing

### Test on Mumbai Testnet

1. Get test MATIC from [Polygon Faucet](https://faucet.polygon.technology/)
2. Deploy contract to Mumbai
3. Configure Cloud Functions with Mumbai RPC
4. Register test cylinders
5. Verify on [Mumbai PolygonScan](https://mumbai.polygonscan.com/)

### Verify Smart Contract

```solidity
// In Remix, call these functions:
totalCylinders()  // Get total count
getCylinderMetadata(tokenId)  // Get cylinder data
getTokenIdByCylinderId("CYL-001")  // Lookup by serial
```

## 📊 Monitoring

### Firebase Console
- Cloud Functions logs
- Firestore data
- Authentication users

### Blockchain Explorer
- Transaction history
- Contract interactions
- Gas usage

### Application Metrics
- Registration success rate
- Minting failures
- Average mint time

## 🚦 Roadmap

- [x] Basic cylinder registration
- [x] NFT minting integration
- [x] Real-time status updates
- [ ] QR code generation
- [ ] QR code scanning
- [ ] Customer verification app
- [ ] Batch operations
- [ ] Analytics dashboard
- [ ] Multi-language support
- [ ] Production deployment

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

MIT License - See LICENSE file for details

## 👥 Team

Built by the Gesi Halisi team to revolutionize gas cylinder tracking and authentication using blockchain technology.

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/Kellyjunior6387/gesi-halisi/issues)
- **Documentation**: See `/docs` folder
- **Smart Contract**: See `contracts/README.md`
- **Cloud Functions**: See `functions/README.md`

## 🌐 Resources

- [Polygon Documentation](https://docs.polygon.technology/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Documentation](https://flutter.dev/docs)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [ethers.js Documentation](https://docs.ethers.org/)

## ⚠️ Important Notes

1. **Security**: Never commit private keys or secrets to Git
2. **Testing**: Always test on testnet before mainnet deployment
3. **Gas Fees**: Keep wallet funded for continuous operation
4. **Monitoring**: Set up alerts for errors and low balance
5. **Backup**: Regular backups of Firestore data

---

**Built with ❤️ using Flutter, Firebase, and Blockchain Technology**
