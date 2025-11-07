/// Firestore Service for Gesi Halisi Application
///
/// Handles all Cloud Firestore operations for user data and application data.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

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

  // Cylinder Management Methods (Placeholder for future implementation)

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
