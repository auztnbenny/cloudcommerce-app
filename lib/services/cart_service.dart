// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class CartItem {
//   final String id;
//   final String name;
//   final double price;
//   int quantity;
//   final String imageUrl;

//   CartItem({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.quantity,
//     required this.imageUrl,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'price': price,
//       'quantity': quantity,
//       'imageUrl': imageUrl,
//     };
//   }
// }

// class CartService {
//   List<CartItem> items = [];
//   final double deliveryFee = 30.0;

//   // API Configuration
//   static const String baseUrl =
//       'http://nwbo1.jubilyhrm.in/WebServiceBtoBOrders.aspx';
//   static const Map<String, String> headers = {
//     'Content-Type': 'application/json',
//   };

//   double get subtotal =>
//       items.fold(0, (sum, item) => sum + (item.price * item.quantity));

//   double get total => subtotal + deliveryFee;

//   void incrementQuantity(String itemId) {
//     final item = items.firstWhere((item) => item.id == itemId);
//     item.quantity++;
//     // Update cart state
//   }

//   void decrementQuantity(String itemId) {
//     final item = items.firstWhere((item) => item.id == itemId);
//     if (item.quantity > 1) {
//       item.quantity--;
//       // Update cart state
//     }
//   }

//   void removeItem(String itemId) {
//     items.removeWhere((item) => item.id == itemId);
//     // Update cart state
//   }

//   Future<void> proceedToCheckout() async {
//     try {
//       final orderData = {
//         'ReqOrderID': '0',
//         'ReqUserID': 'sadmin',
//         'ReqUserAutoID': '76',
//         'ReqPartyID': '123',
//         'ReqRemarks': '',
//         'ReqAcastart': '2024',
//         'ReqDelDate': '01-Jan-2025',
//         'ReqVehNo': '1',
//         'ReqAccPartyID': '0',
//         'ReqLocJason': [
//           {
//             'EntLocID': '0',
//             'AccAutoID': '0',
//             'CDateStr': '01-01-2025',
//             'LocLatLong': '',
//             'LocationString': '',
//             'LocPlace': '',
//             'AprUser': '',
//             'Module': '',
//             'Reason': '',
//             'Remarks': ''
//           }
//         ],
//         'items': items.map((item) => item.toJson()).toList(),
//       };

//       final response = await http.post(
//         Uri.parse(baseUrl),
//         headers: headers,
//         body: jsonEncode(orderData),
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         // Handle successful order creation
//         // Clear cart or navigate to success page
//       } else {
//         throw Exception('Failed to create order');
//       }
//     } catch (e) {
//       // Handle error appropriately
//       print('Error during checkout: $e');
//       rethrow;
//     }
//   }

//   Future<void> fetchCartItems() async {
//     try {
//       // Simulated data for demonstration
//       items = [
//         CartItem(
//           id: '1',
//           name: 'Anti Hair Loss Shampoo',
//           price: 79.95,
//           quantity: 1,
//           imageUrl: 'assets/icons/google.png',
//         ),
//         CartItem(
//           id: '2',
//           name: 'Anti Hair Loss Shampoo',
//           price: 58.91,
//           quantity: 1,
//           imageUrl: 'assets/icons/google.png',
//         ),
//         CartItem(
//           id: '3',
//           name: 'Sea Salt Scaler',
//           price: 52.88,
//           quantity: 1,
//           imageUrl: 'assets/icons/google.png',
//         ),
//       ];
//     } catch (e) {
//       print('Error fetching cart items: $e');
//       rethrow;
//     }
//   }

//   // Method to update item quantity
//   Future<void> updateItemQuantity(String itemId, int quantity) async {
//     try {
//       final item = items.firstWhere((item) => item.id == itemId);
//       item.quantity = quantity;
//       // Here you could add API call to update quantity on server
//     } catch (e) {
//       print('Error updating item quantity: $e');
//       rethrow;
//     }
//   }

//   // Method to calculate GST
//   double calculateGST(double amount, double gstPercentage) {
//     return (amount * gstPercentage) / 100;
//   }

//   // Method to validate cart before checkout
//   bool validateCart() {
//     return items.isNotEmpty && items.every((item) => item.quantity > 0);
//   }

//   // Method to clear cart after successful checkout
//   void clearCart() {
//     items.clear();
//   }

//   // Method to save cart data locally
//   Future<void> saveCartLocally() async {
//     try {
//       final cartData = items.map((item) => item.toJson()).toList();
//       // Here you would implement local storage logic
//       // For example, using shared_preferences:
//       // final prefs = await SharedPreferences.getInstance();
//       // await prefs.setString('cart_data', jsonEncode(cartData));
//     } catch (e) {
//       print('Error saving cart data: $e');
//       rethrow;
//     }
//   }

//   // Method to load cart data from local storage
//   Future<void> loadCartFromLocal() async {
//     try {
//       // Here you would implement logic to load from local storage
//       // For example:
//       // final prefs = await SharedPreferences.getInstance();
//       // final cartDataString = prefs.getString('cart_data');
//       // if (cartDataString != null) {
//       //   final cartData = jsonDecode(cartDataString) as List;
//       //   items = cartData.map((item) => CartItem.fromJson(item)).toList();
//       // }
//     } catch (e) {
//       print('Error loading cart data: $e');
//       rethrow;
//     }
//   }

//   // Method to add item to cart
//   Future<void> addItemToCart(CartItem item) async {
//     try {
//       final existingItemIndex = items.indexWhere((i) => i.id == item.id);

//       if (existingItemIndex != -1) {
//         // If item exists, increment quantity
//         items[existingItemIndex].quantity += item.quantity;
//       } else {
//         // If item doesn't exist, add it
//         items.add(item);
//       }

//       await saveCartLocally();
//     } catch (e) {
//       print('Error adding item to cart: $e');
//       rethrow;
//     }
//   }

//   // Method to validate and prepare order data
//   Map<String, dynamic> prepareOrderData() {
//     if (!validateCart()) {
//       throw Exception('Cart validation failed');
//     }

//     return {
//       'ReqOrderID': '0',
//       'ReqUserID': 'sadmin',
//       'ReqUserAutoID': '76',
//       'ReqPartyID': '123',
//       'ReqRemarks': '',
//       'ReqAcastart': '2024',
//       'ReqDelDate': '01-Jan-2025',
//       'ReqVehNo': '1',
//       'ReqAccPartyID': '0',
//       'ReqLocJason': [
//         {
//           'EntLocID': '0',
//           'AccAutoID': '0',
//           'CDateStr': '01-01-2025',
//           'LocLatLong': '',
//           'LocationString': '',
//           'LocPlace': '',
//           'AprUser': '',
//           'Module': '',
//           'Reason': '',
//           'Remarks': ''
//         }
//       ],
//       'OrderItems': items
//           .map((item) => {
//                 'ItemId': item.id,
//                 'Quantity': item.quantity,
//                 'Price': item.price,
//                 'Total': item.price * item.quantity,
//               })
//           .toList(),
//       'SubTotal': subtotal,
//       'DeliveryFee': deliveryFee,
//       'TotalAmount': total,
//     };
//   }
// }
