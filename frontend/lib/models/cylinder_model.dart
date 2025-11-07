/// Cylinder Model for Gesi Halisi Application
///
/// Represents a gas cylinder in the system with blockchain NFT integration.

import 'package:cloud_firestore/cloud_firestore.dart';

enum CylinderStatus {
  pending,
  minted,
  error;

  String get displayName {
    switch (this) {
      case CylinderStatus.pending:
        return 'Pending';
      case CylinderStatus.minted:
        return 'Minted';
      case CylinderStatus.error:
        return 'Error';
    }
  }
}

class CylinderModel {
  final String id;
  final String serialNumber;
  final String manufacturer;
  final String manufacturerId;
  final String cylinderType;
  final double weight; // in kg
  final double capacity; // in kg
  final String batchNumber;
  final CylinderStatus status;
  final String? tokenId;
  final String? transactionHash;
  final int? blockNumber;
  final String? gasUsed;
  final String? blockchainNetwork;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? mintedAt;
  final String? errorMessage;

  CylinderModel({
    required this.id,
    required this.serialNumber,
    required this.manufacturer,
    required this.manufacturerId,
    required this.cylinderType,
    required this.weight,
    required this.capacity,
    required this.batchNumber,
    required this.status,
    this.tokenId,
    this.transactionHash,
    this.blockNumber,
    this.gasUsed,
    this.blockchainNetwork,
    required this.createdAt,
    this.updatedAt,
    this.mintedAt,
    this.errorMessage,
  });

  /// Create CylinderModel from Firestore document
  factory CylinderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CylinderModel(
      id: doc.id,
      serialNumber: data['serialNumber'] ?? '',
      manufacturer: data['manufacturer'] ?? '',
      manufacturerId: data['manufacturerId'] ?? '',
      cylinderType: data['cylinderType'] ?? '',
      weight: _toDouble(data['weight']),
      capacity: _toDouble(data['capacity']),
      batchNumber: data['batchNumber'] ?? '',
      status: CylinderStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => CylinderStatus.pending,
      ),
      tokenId: data['tokenId']?.toString(),
      transactionHash: data['transactionHash'],
      blockNumber: data['blockNumber'],
      gasUsed: data['gasUsed'],
      blockchainNetwork: data['blockchainNetwork'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      mintedAt: (data['mintedAt'] as Timestamp?)?.toDate(),
      errorMessage: data['errorMessage'],
    );
  }

  /// Helper function to safely convert to double
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Convert CylinderModel to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'serialNumber': serialNumber,
      'manufacturer': manufacturer,
      'manufacturerId': manufacturerId,
      'cylinderType': cylinderType,
      'weight': weight,
      'capacity': capacity,
      'batchNumber': batchNumber,
      'status': status.name,
      'tokenId': tokenId,
      'transactionHash': transactionHash,
      'blockNumber': blockNumber,
      'gasUsed': gasUsed,
      'blockchainNetwork': blockchainNetwork,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'mintedAt': mintedAt != null ? Timestamp.fromDate(mintedAt!) : null,
      'errorMessage': errorMessage,
    };
  }

  /// Create a copy with updated fields
  CylinderModel copyWith({
    String? id,
    String? serialNumber,
    String? manufacturer,
    String? manufacturerId,
    String? cylinderType,
    double? weight,
    double? capacity,
    String? batchNumber,
    CylinderStatus? status,
    String? tokenId,
    String? transactionHash,
    int? blockNumber,
    String? gasUsed,
    String? blockchainNetwork,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? mintedAt,
    String? errorMessage,
  }) {
    return CylinderModel(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      manufacturer: manufacturer ?? this.manufacturer,
      manufacturerId: manufacturerId ?? this.manufacturerId,
      cylinderType: cylinderType ?? this.cylinderType,
      weight: weight ?? this.weight,
      capacity: capacity ?? this.capacity,
      batchNumber: batchNumber ?? this.batchNumber,
      status: status ?? this.status,
      tokenId: tokenId ?? this.tokenId,
      transactionHash: transactionHash ?? this.transactionHash,
      blockNumber: blockNumber ?? this.blockNumber,
      gasUsed: gasUsed ?? this.gasUsed,
      blockchainNetwork: blockchainNetwork ?? this.blockchainNetwork,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      mintedAt: mintedAt ?? this.mintedAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Check if cylinder has been successfully minted
  bool get isMinted => status == CylinderStatus.minted && tokenId != null;

  /// Check if cylinder has an error
  bool get hasError => status == CylinderStatus.error;

  /// Check if cylinder is still pending
  bool get isPending => status == CylinderStatus.pending;

  /// Get blockchain explorer URL for the transaction
  String? get explorerUrl {
    if (transactionHash == null || blockchainNetwork == null) return null;

    switch (blockchainNetwork) {
      case 'polygon':
        return 'https://polygonscan.com/tx/$transactionHash';
      case 'polygon-mumbai':
        return 'https://mumbai.polygonscan.com/tx/$transactionHash';
      default:
        return null;
    }
  }
}
