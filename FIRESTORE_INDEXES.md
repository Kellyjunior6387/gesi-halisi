# Firestore Indexes Configuration Guide

This guide explains the Firestore indexes required for the Gesi Halisi application to query cylinders and orders efficiently.

## Why Indexes Are Needed

Firestore requires composite indexes when you combine:
- Multiple `where` clauses
- A `where` clause with an `orderBy` clause
- Multiple `orderBy` clauses

Without these indexes, queries will fail with an error message containing a link to create the required index.

## Required Indexes for Cylinders Collection

### 1. Cylinders by Manufacturer (Ordered by Creation Date)

**Query**: Get all cylinders for a specific manufacturer, ordered by creation date (descending)

**Fields**:
- `manufacturerId` (Ascending)
- `createdAt` (Descending)

**Used in**: `getCylindersForManufacturer()`, `streamCylindersForManufacturer()`

### 2. All Cylinders (Ordered by Creation Date)

**Query**: Get all cylinders ordered by creation date (descending)

**Fields**:
- `createdAt` (Descending)

**Used in**: `getAllCylinders()`, `streamAllCylinders()`

**Note**: This is a single-field index and may be created automatically, but if you get an error, create it manually.

## Required Indexes for Orders Collection

### 3. Orders by User (Ordered by Creation Date)

**Query**: Get all orders for a specific user, ordered by creation date (descending)

**Fields**:
- `userId` (Ascending)
- `createdAt` (Descending)

**Used in**: `getOrdersForUser()`

### 4. Orders by Manufacturer (Ordered by Creation Date)

**Query**: Get all orders for a specific manufacturer, ordered by creation date (descending)

**Fields**:
- `manufacturerId` (Ascending)
- `createdAt` (Descending)

**Used in**: `getOrdersForManufacturer()`

## How to Create Indexes

### Method 1: Using Firebase Console (Recommended)

1. **Go to Firebase Console**
   - Navigate to [https://console.firebase.google.com](https://console.firebase.google.com)
   - Select your project
   - Go to **Firestore Database** → **Indexes** tab

2. **Create Index Manually**
   - Click **"Create Index"**
   - Select **Collection ID**
   - Add **Fields** with their sort order
   - Click **"Create"**

### Method 2: Using Error Message Link

When you run a query that needs an index, Firestore provides a direct link in the error message:

```
The query requires an index. You can create it here: https://console.firebase.google.com/...
```

Simply click the link and Firebase will create the index automatically.

### Method 3: Using Firebase CLI with firestore.indexes.json

Create a `firestore.indexes.json` file in your project root:

```json
{
  "indexes": [
    {
      "collectionGroup": "cylinders",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "manufacturerId",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "createdAt",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "cylinders",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "createdAt",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "orders",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "userId",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "createdAt",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "orders",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "manufacturerId",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "createdAt",
          "order": "DESCENDING"
        }
      ]
    }
  ],
  "fieldOverrides": []
}
```

Then deploy indexes using Firebase CLI:

```bash
firebase deploy --only firestore:indexes
```

## Index Creation Time

- **Small databases**: Indexes typically build in seconds to minutes
- **Large databases**: May take hours depending on document count
- **Status**: Check build status in Firebase Console under Firestore → Indexes

## Exemptions (Single-field Indexes)

Firestore automatically creates single-field indexes for most fields. You don't need to manually create indexes for:

- Simple equality queries: `where('status', isEqualTo: 'minted')`
- Simple ordering: `orderBy('createdAt')` (without filters)

## Testing Your Indexes

After creating indexes, test your queries:

1. **In Flutter App**:
   - Navigate to Cylinders screen
   - Verify cylinders load without errors
   - Check console for any index-related errors

2. **In Firebase Console**:
   - Go to Firestore → Data
   - Manually test queries using the query builder
   - Ensure results return without errors

## Common Errors and Solutions

### Error: "The query requires an index"

**Solution**: Click the link in the error message or create the index manually as described above.

### Error: "Index creation failed"

**Possible Causes**:
- Invalid field names
- Conflicting index definitions
- Database permission issues

**Solution**: 
- Double-check field names match your Firestore documents
- Delete conflicting indexes in Firebase Console
- Ensure you have Owner/Editor permissions

### Query Still Fails After Index Creation

**Solutions**:
- Wait for index to finish building (check status in Console)
- Clear app cache and restart
- Verify field names are spelled correctly
- Check that the index mode (ASCENDING/DESCENDING) matches your query

## Index Limits

Firestore has limits on indexes:
- **200 composite indexes** per database
- **200 field configurations** per database
- **60,000 index entries** per document

For the Gesi Halisi app, we're well within these limits with only 4 composite indexes.

## Performance Tips

1. **Use indexes wisely**: Only create indexes for queries you actually use
2. **Limit results**: Use `.limit()` to reduce data transfer
3. **Cache data**: Use local caching to reduce repeated queries
4. **Monitor usage**: Check Firebase Console → Usage tab for query performance

## Maintenance

- **Review indexes quarterly**: Remove unused indexes
- **Monitor costs**: Indexes consume storage (minimal for most apps)
- **Update as needed**: Add new indexes when adding new query patterns

## Summary Table

| Collection | Fields | Order | Purpose |
|------------|--------|-------|---------|
| cylinders | manufacturerId, createdAt | ASC, DESC | Manufacturer's cylinders |
| cylinders | createdAt | DESC | All cylinders (admin view) |
| orders | userId, createdAt | ASC, DESC | User's orders |
| orders | manufacturerId, createdAt | ASC, DESC | Manufacturer's orders |

## Support

If you encounter index-related errors:
1. Copy the full error message
2. Click the provided link to auto-create the index
3. Wait for index to build (check Firebase Console)
4. Retry your query

For persistent issues, check:
- Firebase Console → Firestore → Indexes for build status
- Firebase Console → Firestore → Rules for permission issues

---

**Index creation is a one-time setup**. Once created, indexes are maintained automatically by Firestore.
