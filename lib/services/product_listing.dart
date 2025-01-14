import 'package:cloudcommerce/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

class ProductListingController extends ChangeNotifier {
  static const String imageBaseUrl =
      'http://elsabo.cypherinfosolution.com/PICS/stock';
  static const String imageFileBaseUrl =
      'http://elsabo.cypherinfosolution.com/CatLog';
  static const String apiUrl =
      'http://nwbo1.jubilyhrm.in/api/WebServiceBtoBOrders.aspx';

  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  List<dynamic> cartProducts = [];
  List<String> groups = [];
  String _selectedGroup = '';
  bool isLoading = true;
  String errorMessage = '';
  String searchQuery = '';

  String get selectedGroup => _selectedGroup;

  set selectedGroup(String value) {
    _selectedGroup = value;
    notifyListeners();
  }

  bool get hasError => errorMessage.isNotEmpty;
  bool get hasActiveFilter => _selectedGroup.isNotEmpty;
  int get cartCount => cartProducts.length;

  Future<void> init() async {
    try {
      await fetchProducts();
      // Extract groups from products instead of separate API call
      extractGroupsFromProducts();
    } catch (e) {
      debugPrint('Error in init: $e');
    }
  }

  void extractGroupsFromProducts() {
    try {
      Set<String> uniqueGroups = {};

      for (var product in products) {
        // Use Icompany instead of full ProductGroup
        String group = product['Icompany']?.toString() ?? '';
        if (group.isNotEmpty && group != 'null') {
          uniqueGroups.add(group);
        }
      }

      groups = uniqueGroups.toList();
      groups.sort((a, b) => a.compareTo(b));
      debugPrint('Extracted ${groups.length} groups: $groups');
    } catch (e) {
      debugPrint('Error extracting groups: $e');
    }
    notifyListeners();
  }

  String getProductImageUrl(dynamic product) {
    try {
      if (product['ImageFile'] != null &&
          product['ImageFile'].toString().isNotEmpty) {
        final imageName = product['ImageFile'].toString();
        if (imageName.toLowerCase().endsWith('.jpg') ||
            imageName.toLowerCase().endsWith('.png')) {
          return '$imageFileBaseUrl/$imageName';
        }
      }

      String imageFiles = product['ImageFiles'] ?? '';
      if (imageFiles.isNotEmpty) {
        List<String> imgFiles = imageFiles.split('|');
        if (imgFiles.isNotEmpty && imgFiles[0].isNotEmpty) {
          return '$imageBaseUrl/${imgFiles[0]}';
        }
      }
    } catch (e) {
      debugPrint('Error getting image URL: $e');
    }

    // Return a valid asset path
    return 'assets/images/mockup.jpg';
  }

  Future<void> fetchProducts() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'title': 'GetStockItemListForOrder',
          'description': 'Get Stock items list',
          'ReqPartyCode': '',
          'ReqBrand': '',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('API Response received with status: ${response.statusCode}');

        final responseBody = response.body;
        if (responseBody.contains('||JasonEnd')) {
          final jsonPart = responseBody.split('||JasonEnd')[0];
          final jsonResponse = json.decode(jsonPart);

          if (jsonResponse.isNotEmpty && jsonResponse[0]['JSONData1'] != null) {
            final jsonData1 = json.decode(jsonResponse[0]['JSONData1']);
            products = jsonData1;
            filteredProducts = List.from(products);
            debugPrint('Fetched ${products.length} products');

            if (products.isNotEmpty) {
              debugPrint(
                  'Sample product data structure: ${products[0].keys.join(", ")}');
            }

            errorMessage = '';
          } else {
            throw Exception('Invalid data format in JSONData1');
          }
        } else {
          throw Exception('Invalid response format - missing ||JasonEnd');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
      errorMessage = 'Error: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterProducts(String query) {
    debugPrint(
        'Filtering products with query: $query and group: $_selectedGroup');
    searchQuery = query.toLowerCase();

    filteredProducts = products.where((product) {
      final name = (product['itm_NAM'] ?? '').toString().toLowerCase();
      final group = (product['Icompany'] ?? '').toString();

      bool matchesSearch = name.contains(searchQuery);
      bool matchesGroup = _selectedGroup.isEmpty || group == _selectedGroup;

      return matchesSearch && matchesGroup;
    }).toList();

    debugPrint('Filtered to ${filteredProducts.length} products');
    notifyListeners();
  }

  void handleCart(dynamic product) {
    try {
      final productId = product['SVRSTKID'].toString();
      if (isProductInCart(product)) {
        cartProducts
            .removeWhere((item) => item['SVRSTKID'].toString() == productId);
      } else {
        cartProducts.add(product);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error handling cart operation: $e');
    }
  }

  bool isProductInCart(dynamic product) {
    try {
      final productId = product['SVRSTKID'].toString();
      return cartProducts
          .any((item) => item['SVRSTKID'].toString() == productId);
    } catch (e) {
      debugPrint('Error checking if product is in cart: $e');
      return false;
    }
  }

  void clearFilter() {
    _selectedGroup = '';
    filterProducts(searchQuery);
  }

  void retryLoading() {
    errorMessage = '';
    init();
  }
}
