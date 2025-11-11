# Pipedream Webhook Configuration Guide

This guide explains how to set up a Pipedream webhook to handle blockchain NFT minting for gas cylinders.

## Why Pipedream?

Pipedream provides free workflows (100,000 invocations/month on free tier) as an alternative to Firebase Cloud Functions, eliminating cloud function costs while maintaining blockchain integration.

## Setup Steps

### 1. Create Pipedream Account

1. Go to [https://pipedream.com](https://pipedream.com)
2. Sign up for a free account
3. Navigate to "Workflows" in the dashboard

### 2. Create New Workflow

1. Click **"New Workflow"**
2. Choose **"HTTP / Webhook"** as the trigger
3. Select **"New Requests (Payload Only)"**
4. Copy the webhook URL (e.g., `https://xxx.m.pipedream.net`)

### 3. Configure Webhook URL in App

Update the webhook URL in the Flutter app:

**File**: `frontend/lib/services/blockchain_service.dart`

```dart
class BlockchainService {
  // Replace with your actual Pipedream webhook URL
  static const String _webhookUrl = 'https://your-webhook-id.m.pipedream.net';
  // ...
}
```

### 4. Build Pipedream Workflow

The workflow should:
1. Receive cylinder metadata from Flutter app
2. Connect to blockchain (e.g., Polygon)
3. Call smart contract mintCylinder function
4. Return blockchain data (transactionHash, contractAddress, tokenId)

#### Expected Request Format

```json
{
  "serialNumber": "CYL-2024-001",
  "manufacturer": "Acme Gas Co",
  "manufacturerId": "user123",
  "cylinderType": "LPG",
  "weight": 14.2,
  "capacity": 14.2,
  "batchNumber": "BATCH-2024-01",
  "timestamp": "2024-01-15T10:00:00Z"
}
```

#### Expected Response Format

**Success Response** (HTTP 200):
```json
{
  "success": true,
  "transactionHash": "0x1234567890abcdef...",
  "contractAddress": "0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb",
  "tokenId": "1"
}
```

**Error Response** (HTTP 200 with error flag):
```json
{
  "success": false,
  "error": "Error message here",
  "errorMessage": "Detailed error description"
}
```

### 5. Pipedream Workflow Steps

#### Step 1: Trigger (HTTP Request)
- Type: HTTP / Webhook
- Method: POST
- Content-Type: application/json

#### Step 2: Extract Cylinder Data (Node.js Code)
```javascript
export default defineComponent({
  async run({ steps, $ }) {
    const cylinderData = steps.trigger.event.body;
    
    // Validate required fields
    if (!cylinderData.serialNumber || !cylinderData.manufacturer) {
      return {
        success: false,
        error: "Missing required fields"
      };
    }
    
    return cylinderData;
  }
})
```

#### Step 3: Connect to Blockchain (Node.js Code)
```javascript
import { ethers } from 'ethers';

export default defineComponent({
  async run({ steps, $ }) {
    // Blockchain configuration
    const rpcUrl = process.env.BLOCKCHAIN_RPC_URL;
    const privateKey = process.env.BLOCKCHAIN_PRIVATE_KEY;
    const contractAddress = process.env.BLOCKCHAIN_CONTRACT_ADDRESS;
    
    // Smart contract ABI (only mintCylinder function)
    const abi = [
      "function mintCylinder(address to, string memory cylinderId, string memory manufacturer, string memory cylinderType, uint256 weight, uint256 capacity, string memory batchNumber, string memory uri) public returns (uint256)"
    ];
    
    try {
      // Connect to blockchain
      const provider = new ethers.JsonRpcProvider(rpcUrl);
      const wallet = new ethers.Wallet(privateKey, provider);
      const contract = new ethers.Contract(contractAddress, abi, wallet);
      
      // Get cylinder data from previous step
      const cylinder = steps.extract_data.$return_value;
      
      // Convert kg to grams
      const weightInGrams = Math.round(cylinder.weight * 1000);
      const capacityInGrams = Math.round(cylinder.capacity * 1000);
      
      // Call mintCylinder
      const tx = await contract.mintCylinder(
        wallet.address,
        cylinder.serialNumber,
        cylinder.manufacturerId,
        cylinder.cylinderType,
        weightInGrams,
        capacityInGrams,
        cylinder.batchNumber,
        "" // URI (optional)
      );
      
      // Wait for transaction
      const receipt = await tx.wait();
      
      // Extract token ID from transaction logs
      let tokenId = null;
      for (const log of receipt.logs) {
        try {
          const parsedLog = contract.interface.parseLog({
            topics: [...log.topics],
            data: log.data,
          });
          if (parsedLog && parsedLog.name === "CylinderMinted") {
            tokenId = parsedLog.args.tokenId.toString();
            break;
          }
        } catch (e) {
          continue;
        }
      }
      
      // If token ID not found in events, get from total cylinders
      if (!tokenId) {
        const totalCylinders = await contract.totalCylinders();
        tokenId = totalCylinders.toString();
      }
      
      return {
        success: true,
        transactionHash: receipt.hash,
        contractAddress: contractAddress,
        tokenId: tokenId,
        blockNumber: receipt.blockNumber,
        gasUsed: receipt.gasUsed.toString()
      };
      
    } catch (error) {
      console.error("Blockchain error:", error);
      return {
        success: false,
        error: error.message,
        errorMessage: error.toString()
      };
    }
  }
})
```

#### Step 4: Return Response
```javascript
export default defineComponent({
  async run({ steps, $ }) {
    const result = steps.mint_nft.$return_value;
    
    await $.respond({
      status: 200,
      headers: {
        'Content-Type': 'application/json'
      },
      body: result
    });
    
    return result;
  }
})
```

### 6. Environment Variables in Pipedream

Add these secrets in Pipedream workflow settings:

1. **BLOCKCHAIN_RPC_URL**: Your blockchain RPC endpoint
   - Polygon Mumbai: `https://rpc-mumbai.maticvigil.com/`
   - Polygon Mainnet: `https://polygon-rpc.com/`

2. **BLOCKCHAIN_PRIVATE_KEY**: Private key for signing transactions
   - ⚠️ Use a dedicated wallet, not your personal wallet
   - Ensure wallet has sufficient gas tokens

3. **BLOCKCHAIN_CONTRACT_ADDRESS**: Deployed CylinderNFT contract address
   - Get this from Remix IDE after deployment

### 7. Testing the Webhook

Use Postman or curl to test:

```bash
curl -X POST https://your-webhook-id.m.pipedream.net \
  -H "Content-Type: application/json" \
  -d '{
    "serialNumber": "CYL-TEST-001",
    "manufacturer": "Test Manufacturer",
    "manufacturerId": "test123",
    "cylinderType": "LPG",
    "weight": 14.2,
    "capacity": 14.2,
    "batchNumber": "BATCH-TEST-01",
    "timestamp": "2024-01-15T10:00:00Z"
  }'
```

Expected response:
```json
{
  "success": true,
  "transactionHash": "0x...",
  "contractAddress": "0x...",
  "tokenId": "1"
}
```

### 8. Error Handling

The workflow should handle:
- Missing required fields
- Invalid blockchain credentials
- Network timeouts
- Gas estimation failures
- Transaction failures
- Contract execution errors

All errors should return:
```json
{
  "success": false,
  "error": "Brief error message",
  "errorMessage": "Detailed error for debugging"
}
```

## Flutter App Integration

The app automatically:
1. Validates user is a manufacturer
2. Creates cylinder in Firestore (status: "pending")
3. Calls Pipedream webhook with 60-second timeout
4. Retries up to 3 times with exponential backoff
5. Updates Firestore with blockchain data on success
6. Shows success UI with transaction details
7. Sets status to "error" on failure

## Cost Comparison

### Firebase Cloud Functions (Old)
- $0.40 per million invocations
- Plus compute time charges
- **Estimated**: $5-20/month for 1000 cylinders

### Pipedream (New)
- **Free**: 100,000 invocations/month
- No compute charges
- **Estimated**: $0/month for typical usage

## Security Best Practices

1. ✅ Private keys stored in Pipedream environment variables
2. ✅ HTTPS encryption for all webhook requests
3. ✅ Validate all input data before minting
4. ✅ Use dedicated wallet with limited funds
5. ✅ Monitor webhook logs for suspicious activity
6. ✅ Implement rate limiting if needed

## Monitoring

Monitor your workflow in Pipedream dashboard:
- View execution logs
- Track success/failure rates
- Monitor response times
- Check error messages
- Analyze usage stats

## Troubleshooting

### Webhook returns 500 error
- Check Pipedream logs
- Verify environment variables are set
- Ensure blockchain RPC is accessible
- Check wallet has enough gas

### Transaction fails
- Verify contract address is correct
- Check private key has permissions
- Ensure wallet has gas tokens
- Validate contract is deployed

### Timeout errors
- Increase timeout in Flutter app
- Optimize workflow steps
- Check blockchain network status
- Consider using faster RPC endpoint

## Next Steps

1. Create Pipedream workflow
2. Configure environment variables
3. Update webhook URL in Flutter app
4. Test with test cylinders
5. Monitor initial deployments
6. Scale as needed

## Support

- Pipedream Docs: https://pipedream.com/docs
- Community: https://pipedream.com/community
- Smart Contract: See `contracts/README.md`

---

**Cost Savings**: ~$5-20/month by using Pipedream instead of Cloud Functions!
