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
  /// 
  /// Note: This method does NOT retry on errors. The caller should handle
  /// errors and decide whether to retry based on the error type.
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

      // Handle success responses (200, 201)
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
      } 
      
      // Handle client errors (400-499) - these should not be retried
      if (response.statusCode >= 400 && response.statusCode < 500) {
        debugPrint('❌ Client error (${response.statusCode}): ${response.body}');
        String errorMessage = 'Client error: ${response.statusCode}';
        
        try {
          final errorResponse = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage = errorResponse['error'] ?? errorResponse['message'] ?? errorMessage;
        } catch (e) {
          errorMessage = response.body.isNotEmpty ? response.body : errorMessage;
        }
        
        return BlockchainResponse(
          success: false,
          errorMessage: errorMessage,
        );
      }
      
      // Handle server errors (500+) or other status codes
      throw Exception('Webhook returned status ${response.statusCode}: ${response.body}');
    } catch (e) {
      debugPrint('❌ Error calling blockchain webhook: $e');
      return BlockchainResponse(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }
}
