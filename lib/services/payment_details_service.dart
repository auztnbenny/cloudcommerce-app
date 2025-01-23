import 'dart:async';
import 'dart:convert';
import 'package:cloudcommerce/models/payment_details_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PaymentDetailsRepository {
  static Future<List<PaymentDetailsModel>> fetchPaymentDetails({
    required String buyerName,
    required int accAutoId,
    int year = 2024,
  }) async {
    try {
      debugPrint('Fetching Payment Details:');
      debugPrint('Buyer Name: $buyerName');
      debugPrint('Account Auto ID: $accAutoId');
      debugPrint('Year: $year');

      final response = await http.post(
        Uri.parse('http://nwbo1.jubilyhrm.in/WebDataProcessingReact.aspx'),
        body: {
          'title': 'GetPartyPaymentDetails',
          'description': '',
          'ReqYear': year.toString(),
          'ReqAccNane': buyerName,
          'ReqAccCode': accAutoId.toString(),
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          debugPrint('Request timed out');
          throw TimeoutException('Connection timeout');
        },
      );

      debugPrint('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final cleanedBody = _cleanJsonString(response.body);
        debugPrint('Cleaned Body: $cleanedBody');

        final jsonResponse = json.decode(cleanedBody);
        final List<dynamic> accountLedger = _extractAccountLedger(jsonResponse);

        debugPrint('Total ledger entries: ${accountLedger.length}');

        return accountLedger
            .asMap()
            .entries
            .map((entry) =>
                PaymentDetailsModel.fromAccountLedger(entry.value, entry.key))
            .toList();
      } else {
        throw Exception(
            'Failed to load payment details. Status: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      debugPrint('Comprehensive Error:');
      debugPrint('Error Type: ${e.runtimeType}');
      debugPrint('Error: $e');
      debugPrint('Stack Trace: $stackTrace');
      rethrow;
    }
  }

  static String _cleanJsonString(String input) {
    input = input.trim();
    input = input.replaceAll(RegExp(r'<[^>]*>'), '');

    final startIndex = input.indexOf('[');
    final endIndex = input.lastIndexOf(']') + 1;

    if (startIndex != -1 && endIndex != -1) {
      input = input.substring(startIndex, endIndex);
    }

    input = input.replaceAll('||JasonEnd', '').trim();
    return input;
  }

  static List<dynamic> _extractAccountLedger(dynamic jsonResponse) {
    if (jsonResponse is List) {
      if (jsonResponse.isNotEmpty &&
          jsonResponse.first is Map &&
          jsonResponse.first.containsKey('AccountLedger')) {
        return jsonResponse.first['AccountLedger'] ?? [];
      }
      return jsonResponse;
    }

    if (jsonResponse is Map) {
      if (jsonResponse.containsKey('AccountLedger')) {
        return jsonResponse['AccountLedger'] ?? [];
      }
    }

    return [];
  }
}
