// shopping_cart_page.dart
import 'package:cloudcommerce/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloudcommerce/styles/app_styles.dart';
import 'package:cloudcommerce/pages/todaysorders/cart_styles.dart';
import 'package:intl/intl.dart';

class ShoppingCartPage extends StatelessWidget {
  ShoppingCartPage({Key? key, required List<Map<String, dynamic>> cartItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: AppStyles.appBarHeight,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: AppStyles.appBarDecoration,
      ),
      title: Text(
        'Shopping Cart',
        style: AppStyles.appBarTitleStyle,
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final items = cartProvider.items;

        if (items.isEmpty) {
          return Center(
            child: Text(
              'Your cart is empty',
              style: AppStyles.body1,
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: AppStyles.spacing16,
                  vertical: AppStyles.spacing20,
                ),
                itemCount: items.length,
                separatorBuilder: (context, index) =>
                    SizedBox(height: AppStyles.spacing16),
                itemBuilder: (context, index) => CartItemWidget(
                  item: items[index], onRemove: () {},
                  // onRemove: () {
                  //   cartProvider.removeFromCart(index);
                  // },
                ),
              ),
            ),
            CartSummaryWidget(
              items: items,
            ),
          ],
        );
      },
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

    return Container(
      padding: EdgeInsets.all(AppStyles.spacing12),
      decoration: CartStyles.itemDecoration,
      child: Row(
        children: [
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['itm_NAM'] ?? '',
                  style: CartStyles.itemNameStyle,
                ),
                SizedBox(height: AppStyles.spacing4),
                Text(
                  formatCurrency.format(item['OrderAmount'] ?? 0),
                  style: CartStyles.priceStyle,
                ),
                SizedBox(height: AppStyles.spacing8),
                QuantityDisplay(quantity: item['OrderQty'] ?? 0),
              ],
            ),
          ),

          // Remove Button
          IconButton(
            icon: Icon(Icons.close, size: 20),
            color: AppStyles.textSecondaryColor,
            onPressed: onRemove,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}

class QuantityDisplay extends StatelessWidget {
  final double quantity;

  const QuantityDisplay({
    Key? key,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppStyles.spacing12,
        vertical: AppStyles.spacing4,
      ),
      decoration: CartStyles.quantityButtonDecoration,
      child: Text(
        'Quantity: ${quantity.toStringAsFixed(0)}',
        style: AppStyles.body2,
      ),
    );
  }
}

class CartSummaryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const CartSummaryWidget({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

    double itemTotal = 0;
    for (var item in items) {
      itemTotal += item['OrderAmount'] ?? 0;
    }

    return Container(
      padding: EdgeInsets.all(AppStyles.spacing16),
      decoration: CartStyles.summaryDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSummaryRow('Item total', itemTotal),
          SizedBox(height: AppStyles.spacing12),
          Divider(color: AppStyles.secondaryColor.withOpacity(0.2)),
          SizedBox(height: AppStyles.spacing12),
          _buildSummaryRow('Total', itemTotal, isTotal: true),
          SizedBox(height: AppStyles.spacing20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Implement checkout functionality
              },
              style: CartStyles.checkoutButtonStyle,
              child: Text('Proceed to Checkout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    final formatCurrency = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
    final style = isTotal ? AppStyles.h2 : AppStyles.body1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          formatCurrency.format(amount),
          style: isTotal ? CartStyles.totalPriceStyle : style,
        ),
      ],
    );
  }
}
