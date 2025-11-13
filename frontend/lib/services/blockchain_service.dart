/// Blockchain Service for Gesi Halisi Application
///
/// Handles blockchain NFT minting via Pipedream webhook integration.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BlockchainResponse {
  final bool success;
  final String? transactionHash;
  final String? contractAddress;
  final String? tokenId;
  final String? errorMessage;

  BlockchainResponse({
    required this.success,
    this.transactionHash,
    this.contractAddress,
    this.tokenId,
    this.errorMessage,
  });

  factory BlockchainResponse.fromJson(Map<String, dynamic> json) {
    return BlockchainResponse(
      success: json['success'] ?? false,
      transactionHash: json['transactionHash'],
      contractAddress: json['contractAddress'],
      tokenId: json['tokenId']?.toString(),
      errorMessage: json['error'] ?? json['errorMessage'],
    );
  }
}

class BlockchainService {
  // TODO: Replace with your actual Pipedream webhook URL
  static const String _webhookUrl = 'https://eoc36i3go8hgb1j.m.pipedream.net';
  
  /// Mint cylinder NFT via Pipedream webhook
  /// 
  /// Sends cylinder metadata to webhook which handles blockchain minting
  /// Returns blockchain data (transactionHash, contractAddress, tokenId)
  Future<BlockchainResponse> mintCylinderNFT({
    required String serialNumber,
    required String manufacturer,
    required String manufacturerId,
    required String cylinderType,
    required double weight,
    required double capacity,
    required String batchNumber,
  }) async {
    try {
      debugPrint('🔗 Calling blockchain webhook for cylinder: $serialNumber');
      
      final requestBody = {
        'serialNumber': serialNumber,
        'manufacturer': manufacturer,
        'manufacturerId': manufacturerId,
        'cylinderType': cylinderType,
        'weight': weight,
        'capacity': capacity,
        'batchNumber': batchNumber,
        'timestamp': DateTime.now().toIso8601String(),
      };

      debugPrint('📤 Request payload: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse(_webhookUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 60), // 60 second timeout for blockchain transaction
        onTimeout: () {
          throw Exception('Request timeout: Blockchain transaction took too long');
        },
      );

      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final blockchainResponse = BlockchainResponse.fromJson(jsonResponse);
        
        if (blockchainResponse.success) {
          debugPrint('✅ NFT minted successfully!');
          debugPrint('   Transaction: ${blockchainResponse.transactionHash}');
          debugPrint('   Contract: ${blockchainResponse.contractAddress}');
          debugPrint('   Token ID: ${blockchainResponse.tokenId}');
        } else {
          debugPrint('❌ Minting failed: ${blockchainResponse.errorMessage}');
        }
        
        return blockchainResponse;
      } else {
        throw Exception('Webhook returned status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error calling blockchain webhook: $e');
      return BlockchainResponse(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Retry logic for minting NFT
  /// 
  /// Attempts to mint up to maxRetries times with exponential backoff
  Future<BlockchainResponse> mintCylinderNFTWithRetry({
    required String serialNumber,
    required String manufacturer,
    required String manufacturerId,
    required String cylinderType,
    required double weight,
    required double capacity,
    required String batchNumber,
    int maxRetries = 3,
  }) async {
    int attempt = 0;
    
    while (attempt < maxRetries) {
      attempt++;
      debugPrint('🔄 Attempt $attempt of $maxRetries');
      
      final response = await mintCylinderNFT(
        serialNumber: serialNumber,
        manufacturer: manufacturer,
        manufacturerId: manufacturerId,
        cylinderType: cylinderType,
        weight: weight,
        capacity: capacity,
        batchNumber: batchNumber,
      );

      if (response.success) {
        return response;
      }

      if (attempt < maxRetries) {
        // Exponential backoff: wait 2^attempt seconds before retry
        final waitSeconds = (1 << attempt); // 2, 4, 8 seconds
        debugPrint('⏳ Waiting $waitSeconds seconds before retry...');
        await Future.delayed(Duration(seconds: waitSeconds));
      }
    }

    // All retries failed
    debugPrint('❌ All $maxRetries attempts failed');
    return BlockchainResponse(
      success: false,
      errorMessage: 'Failed after $maxRetries attempts',
    );
  }
}
