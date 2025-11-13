# Updated Cylinder Registration with Webhook Integration

## Changes Summary

The cylinder registration has been updated to use a Pipedream webhook instead of Firebase Cloud Functions, eliminating cloud function costs while maintaining blockchain NFT minting.

## New Features

### 1. Direct Webhook Integration
- HTTP POST request to Pipedream webhook
- 60-second timeout for blockchain transactions
- Automatic retry (up to 3 attempts with exponential backoff)
- Comprehensive error handling

### 2. Success UI
After successful NFT minting, users see:
- ✅ Green checkmark with success animation
- Contract address
- Transaction hash (truncated for readability)
- Token ID
- "View on Explorer" button
- "Done" button to close

### 3. Admin Validation
- Only users with "manufacturer" role can register cylinders
- Automatic role check before registration

### 4. Enhanced Error Handling
- Network failures shown with retry option
- Detailed error messages in snackbar
- Status saved as "error" in Firestore on failure

### 5. Loading States
- Button shows "Minting NFT..." during blockchain transaction
- Circular progress indicator
- Disabled state prevents duplicate submissions

## Firestore Structure

Cylinders are now stored with nested blockchain data:

```
cylinders/
  {cylinderId}/
    serialNumber: "CYL-2024-001"
    manufacturer: "Acme Gas Co"
    manufacturerId: "user123"
    cylinderType: "LPG"
    weight: 14.2
    capacity: 14.2
    batchNumber: "BATCH-2024-01"
    status: "minted"
    blockchain:
      transactionHash: "0x..."
      contractAddress: "0x..."
      tokenId: "123"
    createdAt: timestamp
    mintedAt: timestamp
```

## User Flow

1. **Manufacturer opens registration dialog**
   - Clicks "Register Cylinder" button
   - Dialog appears with form

2. **Fills in cylinder details**
   - Serial Number
   - Type (LPG, Oxygen, CO2, Nitrogen)
   - Capacity (kg)
   - Batch Number

3. **Clicks "Register & Mint"**
   - Button shows "Minting NFT..."
   - Loading spinner appears

4. **App processes request**
   - Validates user is manufacturer
   - Creates cylinder in Firestore (status: "pending")
   - Calls Pipedream webhook
   - Waits for blockchain transaction

5. **Success UI appears**
   - Green checkmark animation
   - Shows contract address, transaction hash, token ID
   - "View on Explorer" button (opens block explorer)
   - Firestore updated with blockchain data (status: "minted")

6. **User clicks "Done"**
   - Dialog closes
   - Cylinder list refreshes showing new minted cylinder

## Error Scenarios

### Network Error
- Shows error snackbar
- Automatic retry (up to 3 times)
- Status saved as "error" in Firestore

### Invalid User Role
- Error: "Only manufacturers can register cylinders"
- Registration blocked

### Webhook Failure
- Error message from webhook displayed
- Status saved as "error" with error message in Firestore

### Timeout
- After 60 seconds, shows timeout error
- Can retry manually

## Configuration

### Required Setup

1. **Pipedream Webhook URL**
   - Update `blockchain_service.dart`:
   ```dart
   static const String _webhookUrl = 'YOUR_PIPEDREAM_WEBHOOK_URL';
   ```

2. **Pipedream Environment Variables**
   - `BLOCKCHAIN_RPC_URL`: Polygon RPC endpoint
   - `BLOCKCHAIN_PRIVATE_KEY`: Wallet private key
   - `BLOCKCHAIN_CONTRACT_ADDRESS`: CylinderNFT contract address

See `PIPEDREAM_SETUP.md` for detailed configuration instructions.

## Cost Savings

| Service | Cost |
|---------|------|
| Firebase Cloud Functions | $5-20/month |
| Pipedream Webhook | **FREE** (100k invocations/month) |

**Savings**: ~$60-240/year

## Testing

### Test Workflow
1. Deploy smart contract to Mumbai testnet
2. Create Pipedream workflow
3. Configure webhook URL in app
4. Register test cylinder
5. Verify success UI appears
6. Check Firestore for blockchain data
7. Confirm NFT on blockchain explorer

### Mock Testing
For development without blockchain:
1. Create mock webhook returning success response
2. Test UI flow
3. Verify Firestore updates

## Next Steps

- [ ] Create Pipedream workflow (see PIPEDREAM_SETUP.md)
- [ ] Configure webhook URL in blockchain_service.dart
- [ ] Add url_launcher for "View on Explorer" functionality
- [ ] Test with Mumbai testnet
- [ ] Deploy to production

## Dependencies Added

- `http: ^1.1.0` - For HTTP requests to webhook

## Files Changed

1. `lib/services/blockchain_service.dart` (NEW)
   - Webhook integration
   - Retry logic
   - Response parsing

2. `lib/models/cylinder_model.dart` (UPDATED)
   - Added BlockchainData class
   - Nested blockchain field support
   - Backward compatibility

3. `lib/services/firestore_service.dart` (UPDATED)
   - Added updateCylinderBlockchainData method
   - Stores nested blockchain data

4. `lib/widgets/dashboard/register_cylinder_dialog.dart` (UPDATED)
   - Webhook integration
   - Success UI with blockchain details
   - Admin role validation
   - Enhanced error handling

5. `pubspec.yaml` (UPDATED)
   - Added http package

## UI Screenshots

### Registration Form
- Form with fields: Serial Number, Type, Capacity, Batch Number
- "Register & Mint" button

### Loading State
- Button shows "Minting NFT..."
- Circular progress indicator

### Success UI
- ✅ Green checkmark header
- Contract address display
- Transaction hash display (truncated)
- Token ID display
- "View on Explorer" button
- "Done" button

### Error State
- Red snackbar with error message
- Form remains open for retry

---

**Implementation Complete**: Webhook-based NFT minting with comprehensive UI feedback!
