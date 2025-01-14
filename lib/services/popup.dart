// order_details_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class OrderDetailsService {
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

  Future<Map<String, dynamic>> getStockStatus(String itemId) async {
    if (itemId.isEmpty) {
      return _getDefaultStockStatus();
    }

    try {
      developer.log(
        'Fetching stock status for ItemId: $itemId',
        name: 'OrderDetailsService',
      );

      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'title': 'getStockNOrderStatus',
          'description': 'Request For Stock Status',
          'ReqItemCode': itemId,
        },
      );

      if (response.statusCode != 200) {
        return _getDefaultStockStatus();
      }

      try {
        final jsonStr = _cleanJsonString(response.body);
        final List<dynamic> jsonResponse = json.decode(jsonStr);

        if (jsonResponse.isEmpty ||
            jsonResponse[0]['JSONData1'] == null ||
            jsonResponse[0]['JSONData1'].toString().isEmpty) {
          return _getDefaultStockStatus();
        }

        final stockData = json.decode(jsonResponse[0]['JSONData1'])[0];
        return {
          'finalStock':
              double.tryParse(stockData['FinalStock']?.toString() ?? '0') ??
                  0.0,
          'orderStock':
              double.tryParse(stockData['OrderQty']?.toString() ?? '0') ?? 0.0,
        };
      } catch (e) {
        developer.log(
          'Error parsing stock status: $e',
          name: 'OrderDetailsService',
        );
        return _getDefaultStockStatus();
      }
    } catch (e) {
      developer.log(
        'Error in getStockStatus: $e',
        name: 'OrderDetailsService',
      );
      return _getDefaultStockStatus();
    }
  }

  Map<String, dynamic> _getDefaultStockStatus() {
    return {
      'finalStock': 0.0,
      'orderStock': 0.0,
    };
  }
}
