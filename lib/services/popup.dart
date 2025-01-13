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

  Future<Map<String, dynamic>> fetchOrderDetails({
    required String orderId,
    required String userName,
    DateTime? orderDate,
  }) async {
    try {
      final formattedDate = _formatDateForApi(orderDate ?? DateTime.now());

      developer.log(
        'Fetching order details: OrderID: $orderId, Username: $userName, Date: $formattedDate',
        name: 'OrderDetailsService',
      );

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

      // Only process data if ActionType > 0 (matching React implementation)
      if (actionType > 0) {
        Map<String, dynamic> result = {
          'orderMaster': null,
          'orderDetails': <dynamic>[],
          'blankProduct': null
        };

        // Parse order master (JSONData1)
        if (data['JSONData1'] != null && data['JSONData1'] is String) {
          final masterData = json.decode(data['JSONData1']);
          if (masterData is List && masterData.isNotEmpty) {
            result['orderMaster'] = masterData[0];
          }
        }

        // Parse order details (JSONData2)
        if (data['JSONData2'] != null && data['JSONData2'] is String) {
          final detailsData = json.decode(data['JSONData2']);
          if (detailsData is List) {
            result['orderDetails'] = detailsData;
          }
        }

        // Parse blank product template (JSONData3)
        if (data['JSONData3'] != null && data['JSONData3'] is String) {
          final templateData = json.decode(data['JSONData3']);
          if (templateData is List && templateData.isNotEmpty) {
            result['blankProduct'] = templateData[0];
          }
        }

        return result;
      } else {
        // If ActionType <= 0, throw error with message from response
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
