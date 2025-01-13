import 'package:cloudcommerce/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  String selectedGroup = '';
  bool isLoading = true;
  String errorMessage = '';
  String searchQuery = '';

  bool get hasError => errorMessage.isNotEmpty;
  bool get hasActiveFilter => selectedGroup.isNotEmpty;
  int get cartCount => cartProducts.length;

  Future<void> init() async {
    await Future.wait([
      fetchProducts(),
      fetchGroups(),
    ]);
  }

  String getProductImageUrl(dynamic product) {
    String imageFiles = product['ImageFiles'] ?? '';
    List<String> imgFiles = imageFiles.split('|');

    if (product['ImageFile'] != null &&
        product['ImageFile'].toString().isNotEmpty) {
      return '$imageFileBaseUrl/${product['ImageFile']}';
    } else if (imgFiles.isNotEmpty && imgFiles[0].isNotEmpty) {
      return '$imageBaseUrl/${imgFiles[0]}';
    }
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
        final responseBody = response.body;
        if (responseBody.contains('||JasonEnd')) {
          final jsonPart = responseBody.split('||JasonEnd')[0];
          final jsonResponse = json.decode(jsonPart);

          if (jsonResponse.isNotEmpty && jsonResponse[0]['JSONData1'] != null) {
            final jsonData1 = json.decode(jsonResponse[0]['JSONData1']);
            products = jsonData1;
            filteredProducts = products;
            errorMessage = '';
          } else {
            throw Exception('Invalid data format');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      errorMessage = 'Error: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchGroups() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'title': 'GetGroupMasterList',
          'description': '',
          'ReqGroupType': 'B',
          'ReqGroupName': '',
          'ReqSerType': '0',
        },
      );
      groups = products
          .map((product) => product['ProductGroup']?.toString() ?? '')
          .where((group) => group.isNotEmpty)
          .toSet()
          .toList();

      groups.sort((a, b) => a.compareTo(b));

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.contains('||JasonEnd')) {
          final jsonPart = responseBody.split('||JasonEnd')[0];
          final jsonResponse = json.decode(jsonPart);

          if (jsonResponse.isNotEmpty && jsonResponse[0]['JSONData1'] != null) {
            final jsonData1 = json.decode(jsonResponse[0]['JSONData1']);
            groups = jsonData1
                .map<String>((item) => item['ProductGroup'].toString())
                .toSet()
                .toList();
            groups.sort();
          } else {
            throw Exception('Invalid data format');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load groups');
      }
    } catch (e) {
      errorMessage = 'Error loading groups: ${e.toString()}';
    }
    notifyListeners();
  }

  void filterProducts(String query) {
    searchQuery = query;
    filteredProducts = products.where((product) {
      final productName = product['itm_NAM']?.toString().toLowerCase() ?? '';
      final searchLower = searchQuery.toLowerCase();
      final productGroup = product['ProductGroup']?.toString() ?? '';

      return productName.contains(searchLower) &&
          (selectedGroup.isEmpty || productGroup == selectedGroup);
    }).toList();
    notifyListeners();
  }

  void showGroupFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Group', style: AppStyles.h2),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: ListView(
              children: [
                ListTile(
                  title: Text('All Groups', style: AppStyles.body1),
                  selected: selectedGroup.isEmpty,
                  onTap: () {
                    selectedGroup = '';
                    filterProducts(searchQuery);
                    Navigator.pop(context);
                  },
                ),
                ...groups.map((group) => ListTile(
                      title: Text(group, style: AppStyles.body1),
                      selected: selectedGroup == group,
                      onTap: () {
                        selectedGroup = group;
                        filterProducts(searchQuery);
                        Navigator.pop(context);
                      },
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  void handleCart(dynamic product) {
    final productId = int.parse(product['SVRSTKID'].toString());
    if (isProductInCart(product)) {
      cartProducts.removeWhere(
          (item) => int.parse(item['SVRSTKID'].toString()) == productId);
    } else {
      cartProducts.add(product);
    }
    notifyListeners();
  }

  bool isProductInCart(dynamic product) {
    final productId = int.parse(product['SVRSTKID'].toString());
    return cartProducts
        .any((item) => int.parse(item['SVRSTKID'].toString()) == productId);
  }

  void clearFilter() {
    selectedGroup = '';
    filterProducts(searchQuery);
  }

  void retryLoading() {
    errorMessage = '';
    init();
  }

  void navigateToCart() {
    // Implement cart navigation
  }
}
