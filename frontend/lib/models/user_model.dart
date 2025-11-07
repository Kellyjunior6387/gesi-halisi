/// User Model for Gesi Halisi Application
///
/// Represents a user in the system with authentication and role information.
/// Supports three roles: manufacturer, distributor, and customer.

import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  manufacturer,
  distributor,
  customer;

  String get displayName {
    switch (this) {
      case UserRole.manufacturer:
        return 'Manufacturer';
      case UserRole.distributor:
        return 'Distributor';
      case UserRole.customer:
        return 'Customer';
    }
  }
}

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final UserRole role;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? profileImageUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.role,
    required this.createdAt,
    this.updatedAt,
    this.profileImageUrl,
  });

  String get fullName => '$firstName $lastName';

  /// Create UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Helper function to safely convert to String
    String _toString(dynamic value, String defaultValue) {
      if (value == null) return defaultValue;
      if (value is String) return value;
      if (value is List && value.isNotEmpty) return value.first.toString();
      return value.toString();
    }
    
    // Helper function to safely convert to nullable String
    String? _toStringOrNull(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is List && value.isNotEmpty) return value.first.toString();
      return value.toString();
    }
    
    return UserModel(
      uid: doc.id,
      email: _toString(data['email'], ''),
      firstName: _toString(data['firstName'], 'User'),
      lastName: _toString(data['lastName'], ''),
      phoneNumber: _toStringOrNull(data['phoneNumber']),
      role: UserRole.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => UserRole.customer,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      profileImageUrl: _toStringOrNull(data['profileImageUrl']),
    );
  }

  /// Convert UserModel to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'role': role.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'profileImageUrl': profileImageUrl,
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profileImageUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
