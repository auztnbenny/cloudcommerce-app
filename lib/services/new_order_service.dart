import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class NewOrderService {
  static const String baseUrl =
      'http://nwbo1.jubilyhrm.in/WebDataProcessingReact.aspx';

  Future<List<Map<String, dynamic>>> fetchPartyList() async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'title': 'GetPartyNBalanceList',
          'description': 'Request Employee List',
          'ReqType': '',
          'ReqNofRcds': '',
          'ReqAcaStart': '',
          'ReqGroups': '',
          'ReqCodes': '',
          'ReqByrName': '',
          'ReqRoute': ''
        },
      );

      if (response.statusCode == 200) {
        String responseBody = response.body.split('||').first.trim();
        final data = json.decode(responseBody);

        if (data['PartyList'] == null || data['PartyList'].isEmpty) {
          throw Exception('No parties found');
        }

        return List<Map<String, dynamic>>.from(
            data['PartyList'].map((party) => {
                  'Byr_nam': party['Byr_nam']?.toString() ?? '',
                  'AccAddress': party['AccAddress']?.toString() ?? '',
                  'PartyID': party['AccAutoID']?.toString() ?? '',
                }));
      } else {
        throw Exception('Failed to load party list');
      }
    } catch (e) {
      throw Exception('Error fetching party list: $e');
    }
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
          'Please enable location services in your device settings');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission is required to create an order');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied. Please enable them in settings');
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
        forceAndroidLocationManager: true,
      );
    } on TimeoutException {
      // Fall back to last known position if getting current position times out
      final lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        return lastPosition;
      }
      throw Exception('Unable to get location. Please check your GPS signal');
    } catch (e) {
      throw Exception('Error getting location: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchLocationDetails(
      double latitude, double longitude) async {
    try {
      final response = await http.post(
        Uri.parse('http://nwbo1.jubilyhrm.in/api/getUserLocationDetails'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': '',
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching location details: $e');
    }
  }

  Future<void> submitOrder({
    required String partyId,
    required String remarks,
    required String deliveryDate,
    required Position? position,
    required Map<String, dynamic>? locationDetails,
  }) async {
    try {
      final locationData = {
        "EntLocID": "0",
        "AccAutoID": partyId,
        "CDateStr": deliveryDate,
        "LocLatLong": position != null
            ? "${position.latitude},${position.longitude}"
            : "0,0",
        "LocationString":
            locationDetails?['display_name'] ?? "Location not available",
        "LocPlace": locationDetails?['address']?['neighbourhood'] ??
            locationDetails?['address']?['town'] ??
            locationDetails?['address']?['village'] ??
            "NA",
        "AprUser": "sadmin",
        "Module": "ORDER",
        "Reason": "",
        "Remarks": remarks
      };

      print('Debug: Location data being sent:');
      print(json.encode(locationData));

      final requestBody = {
        'title': 'UpdateOrderMaster',
        'description': '',
        'ReqOrderID': '',
        'ReqUserID': '',
        'ReqUserAutoID': '',
        'ReqPartyID': partyId,
        'ReqRemarks': remarks,
        'ReqAcastart': '2024',
        'ReqDelDate': deliveryDate,
        'ReqVehNo': '',
        'ReqAccPartyID': '',
        'ReqLocJason': json.encode([locationData]),
      };

      print('Debug: Full request body:');
      print(json.encode(requestBody));

      final response = await http.post(
        Uri.parse(baseUrl),
        body: requestBody,
      );

      print('Debug: Response status code: ${response.statusCode}');
      print('Debug: Response body: ${response.body}');

      if (response.statusCode == 200) {
        String responseBody = response.body.split('||').first.trim();
        final jsonResponse = json.decode(responseBody);
        print('Debug: Parsed response: $jsonResponse');

        if (jsonResponse is List && jsonResponse.isNotEmpty) {
          final firstItem = jsonResponse[0];
          if (firstItem['RcdID'] == -2) {
            throw Exception(firstItem['ItemName'] ?? 'Unknown error occurred');
          }
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Debug: Error in submitOrder:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Error submitting order: $e');
    }
  }
}