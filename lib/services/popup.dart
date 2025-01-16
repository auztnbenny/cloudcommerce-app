// order_details_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class OrderDetailsService {
  static const String baseUrl1 =
      'http://nwbo1.jubilyhrm.in/WebDataProcessingReact.aspx';
  static const String baseUrl =
      'http://nwbo1.jubilyhrm.in/api/WebServiceBtoBOrders.aspx';

  String _cleanJsonString(String rawResponse) {
    final trimmed = rawResponse.trim();
    final endIndex = trimmed.indexOf('||JasonEnd');
    if (endIndex == -1) {
      throw Exception('Invalid response format: Missing JasonEnd marker');
    }
    return trimmed.substring(0, endIndex).trim();
  }

  Future<Map<String, dynamic>> fetchItemMaster({
    required String itemCode,
    required String partyCode,
  }) async {
    try {
      // Validate input parameters
      if (itemCode.isEmpty) {
        throw Exception('Item code cannot be empty');
      }
      if (partyCode.isEmpty) {
        throw Exception('Party code cannot be empty');
      }

      developer.log(
        'Fetching item details for ItemCode: $itemCode, PartyCode: $partyCode',
        name: 'OrderDetailsService',
      );

      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'title': 'GetItemMasterByCode',
          'description': 'Request For Stock Item Display List',
          'ReqItemCode': itemCode,
          'ReqPartyCode': partyCode,
          'ReqWithStock': 'yes',
        },
      );

      developer.log(
        'Response status: ${response.statusCode}',
        name: 'OrderDetailsService',
      );

      if (response.statusCode != 200) {
        throw Exception('Server returned status code: ${response.statusCode}');
      }

      final jsonStr = _cleanJsonString(response.body);
      developer.log(
        'Cleaned JSON: $jsonStr',
        name: 'OrderDetailsService',
      );

      final List<dynamic> jsonResponse = json.decode(jsonStr);

      if (jsonResponse.isEmpty) {
        throw Exception('Empty response from server');
      }

      final data = jsonResponse[0];
      if (data['ActionType'] != 1 || data['ErrorCode'] != '0') {
        throw Exception(data['ErrorMessage'] ?? 'Failed to fetch item details');
      }

      // Parse item details
      final itemDetails = _parseItemDetails(data['JSONData1']);

      return {
        'itemDetails': itemDetails,
        'stockDetails': await getStockStatus(itemCode),
      };
    } catch (e) {
      developer.log(
        'Error in fetchItemMaster: $e',
        name: 'OrderDetailsService',
      );
      rethrow;
    }
  }

  Map<String, dynamic> _parseItemDetails(String? jsonData) {
    if (jsonData == null || jsonData.isEmpty) {
      throw Exception('No item details found');
    }

    try {
      final List<dynamic> parsed = json.decode(jsonData);
      if (parsed.isEmpty) {
        throw Exception('Empty item details');
      }

      final details = parsed[0];
      return {
        'SalePrice':
            double.tryParse(details['SalePrice']?.toString() ?? '0') ?? 0.0,
        'STKSVRSTOCK':
            double.tryParse(details['STKSVRSTOCK']?.toString() ?? '0') ?? 0.0,
        'STOCKCOLOR': details['STOCKCOLOR'] ?? '',
        'itm_NAM': details['itm_NAM'] ?? '',
        'MRP': double.tryParse(details['MRP']?.toString() ?? '0') ?? 0.0,
        'LastRate':
            double.tryParse(details['LastRate']?.toString() ?? '0') ?? 0.0,
        'WSPrice':
            double.tryParse(details['WSPrice']?.toString() ?? '0') ?? 0.0,
        'SVRSTKID': details['SVRSTKID']?.toString() ?? '',
        'STKGSTRate':
            double.tryParse(details['STKGSTRate']?.toString() ?? '0') ?? 0.0,
        'STKCGSTRate':
            double.tryParse(details['STKCGSTRate']?.toString() ?? '0') ?? 0.0,
        'STKSGSTRate':
            double.tryParse(details['STKSGSTRate']?.toString() ?? '0') ?? 0.0,
        'STKIGSTRate':
            double.tryParse(details['STKIGSTRate']?.toString() ?? '0') ?? 0.0,
        'OrderCesPer':
            double.tryParse(details['OrderCesPer']?.toString() ?? '0') ?? 0.0,
      };
    } catch (e) {
      developer.log(
        'Error parsing item details: $e',
        name: 'OrderDetailsService',
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getStockStatus(String svrStkId) async {
    if (svrStkId.isEmpty) {
      return _getDefaultStockStatus();
    }

    // Update to use the same URL as React

    try {
      developer.log(
        'Fetching stock status for SVRSTKID: $svrStkId',
        name: 'OrderDetailsService',
      );

      // Create FormData similar to React implementation
      var formData = {
        'title': 'GetStockNOrderStatus',
        'description': 'Request For Stock of the day',
        'ReqSvrStkID': svrStkId,
      };

      developer.log(
        'Request Data: $formData',
        name: 'OrderDetailsService',
      );

      final response = await http.post(
        Uri.parse(baseUrl1),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: formData,
      );

      developer.log('Response Status: ${response.statusCode}',
          name: 'OrderDetailsService');

      if (response.statusCode != 200) {
        return _getDefaultStockStatus();
      }

      try {
        // Match React's response handling
        final responseData = response.body;
        final jsonEndIndex = responseData.indexOf('||JasonEnd');
        if (jsonEndIndex == -1) {
          developer.log('No JasonEnd marker found in response');
          return _getDefaultStockStatus();
        }

        final jsonStr = responseData.substring(0, jsonEndIndex);
        developer.log('Extracted JSON string: $jsonStr');

        final jsonData = json.decode(jsonStr);
        developer.log('Parsed JSON data: $jsonData');

        // Extract stock data from response
        if (jsonData is List &&
            jsonData.isNotEmpty &&
            jsonData[0]['JSONData1'] != null) {
          final stockData = json.decode(jsonData[0]['JSONData1'])[0];
          return {
            'FinalStock':
                double.tryParse(stockData['FinalStock']?.toString() ?? '0') ??
                    0.0,
            'OrderQty':
                double.tryParse(stockData['OrderQty']?.toString() ?? '0') ??
                    0.0,
          };
        }

        return _getDefaultStockStatus();
      } catch (e) {
        developer.log(
            'Error parsing response: $e\nResponse body: ${response.body}',
            name: 'OrderDetailsService');
        return _getDefaultStockStatus();
      }
    } catch (e) {
      developer.log('Network error: $e', name: 'OrderDetailsService');
      return _getDefaultStockStatus();
    }
  }

  Map<String, dynamic> _getDefaultStockStatus() {
    return {
      'FinalStock': 0.0,
      'OrderQty': 0.0,
    };
  }
}
