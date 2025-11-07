/// Firestore Service for Gesi Halisi Application
///
/// Handles all Cloud Firestore operations for user data and application data.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/cylinder_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _cylindersCollection =>
      _firestore.collection('cylinders');
  CollectionReference get _ordersCollection => _firestore.collection('orders');

  /// Create or update user profile in Firestore
  Future<void> saveUserProfile(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).set(
            user.toFirestore(),
            SetOptions(merge: true),
          );
      debugPrint('✅ User profile saved: ${user.uid}');
    } catch (e) {
      debugPrint('❌ Error saving user profile: $e');
      rethrow;
    }
  }

  /// Get user profile from Firestore
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        debugPrint('📖 Reading user profile for: $uid');
        debugPrint('📋 Data: ${doc.data()}');
        return UserModel.fromFirestore(doc);
      }
      debugPrint('⚠️ User profile not found for: $uid');
      return null;
    } catch (e, stackTrace) {
      debugPrint('❌ Error getting user profile: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Stream user profile changes
  Stream<UserModel?> streamUserProfile(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }

  /// Update user profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _usersCollection.doc(uid).update(data);
      debugPrint('✅ User profile updated: $uid');
    } catch (e) {
      debugPrint('❌ Error updating user profile: $e');
      rethrow;
    }
  }

  /// Delete user profile (use with caution)
  Future<void> deleteUserProfile(String uid) async {
    try {
      await _usersCollection.doc(uid).delete();
      debugPrint('✅ User profile deleted: $uid');
    } catch (e) {
      debugPrint('❌ Error deleting user profile: $e');
      rethrow;
    }
  }

  /// Check if user profile exists
  Future<bool> userProfileExists(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      return doc.exists;
    } catch (e) {
      debugPrint('❌ Error checking user profile: $e');
      return false;
    }
  }

  // Cylinder Management Methods

  /// Register a new cylinder in Firestore
  /// This will trigger the Cloud Function to mint the NFT
  /// 
  /// Returns the document ID of the newly created cylinder
  Future<String> registerCylinder({
    required String serialNumber,
    required String manufacturer,
    required String manufacturerId,
    required String cylinderType,
    required double weight,
    required double capacity,
    required String batchNumber,
  }) async {
    try {
      debugPrint('📝 Registering cylinder: $serialNumber');
      
      final cylinderData = {
        'serialNumber': serialNumber,
        'manufacturer': manufacturer,
        'manufacturerId': manufacturerId,
        'cylinderType': cylinderType,
        'weight': weight,
        'capacity': capacity,
        'batchNumber': batchNumber,
        'status': CylinderStatus.pending.name,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _cylindersCollection.add(cylinderData);
      debugPrint('✅ Cylinder registered with ID: ${docRef.id}');
      debugPrint('⏳ Waiting for Cloud Function to mint NFT...');
      
      return docRef.id;
    } catch (e) {
      debugPrint('❌ Error registering cylinder: $e');
      rethrow;
    }
  }

  /// Get a single cylinder by ID
  Future<CylinderModel?> getCylinder(String cylinderId) async {
    try {
      final doc = await _cylindersCollection.doc(cylinderId).get();
      if (doc.exists) {
        return CylinderModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getting cylinder: $e');
      rethrow;
    }
  }

  /// Stream a single cylinder by ID
  Stream<CylinderModel?> streamCylinder(String cylinderId) {
    return _cylindersCollection.doc(cylinderId).snapshots().map((doc) {
      if (doc.exists) {
        return CylinderModel.fromFirestore(doc);
      }
      return null;
    });
  }

  /// Get cylinders for a manufacturer
  Stream<QuerySnapshot> getCylindersForManufacturer(String manufacturerId) {
    return _cylindersCollection
        .where('manufacturerId', isEqualTo: manufacturerId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Get all cylinders (admin view)
  Stream<QuerySnapshot> getAllCylinders() {
    return _cylindersCollection
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots();
  }

  /// Get cylinders as models for a manufacturer
  Stream<List<CylinderModel>> streamCylindersForManufacturer(
      String manufacturerId) {
    return _cylindersCollection
        .where('manufacturerId', isEqualTo: manufacturerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CylinderModel.fromFirestore(doc))
            .toList());
  }

  /// Get all cylinders as models
  Stream<List<CylinderModel>> streamAllCylinders() {
    return _cylindersCollection
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CylinderModel.fromFirestore(doc))
            .toList());
  }

  /// Update cylinder status (usually done by Cloud Function, but can be manual)
  Future<void> updateCylinderStatus({
    required String cylinderId,
    required CylinderStatus status,
    String? errorMessage,
  }) async {
    try {
      final updateData = {
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (errorMessage != null) {
        updateData['errorMessage'] = errorMessage;
      }

      await _cylindersCollection.doc(cylinderId).update(updateData);
      debugPrint('✅ Cylinder status updated: $cylinderId -> ${status.name}');
    } catch (e) {
      debugPrint('❌ Error updating cylinder status: $e');
      rethrow;
    }
  }

  // Order Management Methods (Placeholder for future implementation)

  /// Get orders for a user
  Stream<QuerySnapshot> getOrdersForUser(String userId) {
    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Get orders for a manufacturer
  Stream<QuerySnapshot> getOrdersForManufacturer(String manufacturerId) {
    return _ordersCollection
        .where('manufacturerId', isEqualTo: manufacturerId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
