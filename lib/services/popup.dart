import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:intl/intl.dart';

class OrderDetailsService {
  static const String baseUrl =
      'http://nwbo1.jubilyhrm.in/api/WebServiceBtoBOrders.aspx';

  String _formatDateForApi(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<Map<String, dynamic>> fetchItemMaster({
    required String itemCode,
    required String partyCode,
  }) async {
    try {
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

      if (response.statusCode != 200) {
        throw Exception('Server returned status code: ${response.statusCode}');
      }

      final responseBody = response.body;
      final jsonStr = responseBody.split('||JasonEnd')[0].trim();
      final List<dynamic> jsonResponse = json.decode(jsonStr);

      if (jsonResponse.isEmpty) {
        throw Exception('Empty response from server');
      }

      final data = jsonResponse[0];
      if (data['ActionType'] != 1 || data['ErrorCode'] != '0') {
        throw Exception(data['ErrorMessage'] ?? 'Failed to fetch item details');
      }

      final itemDetails = json.decode(data['JSONData1'])[0];
      return itemDetails;
    } catch (e, stackTrace) {
      developer.log(
        'Error in fetchItemMaster',
        error: e,
        stackTrace: stackTrace,
        name: 'OrderDetailsService',
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchOrderDetails({
    required String orderId,
    required String userName,
    DateTime? orderDate,
  }) async {
    try {
      final formattedDate = _formatDateForApi(orderDate ?? DateTime.now());

      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'title': 'GetOrderDetailsByCode',
          'description': 'Request For Stock of the day',
          'ReqOrderID': orderId,
          'ReqUserName': userName,
          'ReqOrderDate': formattedDate,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Server returned status code: ${response.statusCode}');
      }

      final responseBody = response.body;
      final jsonStr = responseBody.split('||JasonEnd')[0].trim();
      final List<dynamic> jsonResponse = json.decode(jsonStr);

      if (jsonResponse.isEmpty) {
        throw Exception('Empty response from server');
      }

      final data = jsonResponse[0];
      final int actionType = data['ActionType'] ?? -1;

      if (actionType > 0) {
        Map<String, dynamic> result = {
          'orderMaster': null,
          'orderDetails': <dynamic>[],
          'blankProduct': null
        };

        if (data['JSONData1'] != null && data['JSONData1'] is String) {
          final masterData = json.decode(data['JSONData1']);
          if (masterData is List && masterData.isNotEmpty) {
            result['orderMaster'] = masterData[0];
          }
        }

        if (data['JSONData2'] != null && data['JSONData2'] is String) {
          final detailsData = json.decode(data['JSONData2']);
          if (detailsData is List) {
            result['orderDetails'] = detailsData;
          }
        }

        if (data['JSONData3'] != null && data['JSONData3'] is String) {
          final templateData = json.decode(data['JSONData3']);
          if (templateData is List && templateData.isNotEmpty) {
            result['blankProduct'] = templateData[0];
          }
        }

        return result;
      } else {
        throw Exception(
            data['ErrorMessage'] ?? 'Failed to fetch order details');
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error in fetchOrderDetails',
        error: e,
        stackTrace: stackTrace,
        name: 'OrderDetailsService',
      );
      rethrow;
    }
  }
}
