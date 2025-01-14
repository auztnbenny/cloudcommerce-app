import 'package:cloudcommerce/pages/todaysorders/cart_styles.dart';
import 'package:cloudcommerce/styles/app_styles.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  CartPage({Key? key}) : super(key: key);

  // Sample data remains the same...
  final List<CartItem> items = [
    CartItem(
      name: 'Anti Hair Loss Shampoo',
      price: 79.95,
      quantity: 1,
      image: 'assets/images/mockup.jpg',
    ),
    CartItem(
      name: 'Anti Hair Loss Shampoo',
      price: 58.91,
      quantity: 1,
      image: 'assets/images/mockup.jpg',
    ),
    CartItem(
      name: 'Sea Salt Scaler',
      price: 52.88,
      quantity: 1,
      image: 'assets/images/mockup.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: _buildAppBar(context),
      body: _buildBody(),
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
      // leading: IconButton(
      //   icon: Icon(Icons.arrow_back, color: Colors.white),
      //   onPressed: () => Navigator.of(context).pop(),
      // ),
      title: Text(
        'Shopping Cart',
        style: AppStyles.appBarTitleStyle,
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
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
            itemBuilder: (context, index) => CartItemWidget(item: items[index]),
          ),
        ),
        CartSummaryWidget(
          itemTotal: 191.74,
          deliveryFee: 30.00,
        ),
      ],
    );
  }
}

class CartItem {
  final String name;
  final double price;
  final int quantity;
  final String image;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppStyles.spacing12),
      decoration: CartStyles.itemDecoration,
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
            child: Image.asset(
              item.image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: AppStyles.spacing12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: CartStyles.itemNameStyle),
                SizedBox(height: AppStyles.spacing4),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: CartStyles.priceStyle,
                ),
                SizedBox(height: AppStyles.spacing8),
                QuantityControl(quantity: item.quantity),
              ],
            ),
          ),

          // Remove Button
          IconButton(
            icon: Icon(Icons.close, size: 20),
            color: AppStyles.textSecondaryColor,
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}

class QuantityControl extends StatelessWidget {
  final int quantity;

  const QuantityControl({
    Key? key,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildControlButton(Icons.remove),
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppStyles.spacing16),
          child: Text(
            quantity.toString(),
            style: AppStyles.body1,
          ),
        ),
        _buildControlButton(Icons.add),
      ],
    );
  }

  Widget _buildControlButton(IconData icon) {
    return Container(
      decoration: CartStyles.quantityButtonDecoration,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Icon(icon, size: 16),
          ),
        ),
      ),
    );
  }
}

class CartSummaryWidget extends StatelessWidget {
  final double itemTotal;
  final double deliveryFee;

  const CartSummaryWidget({
    Key? key,
    required this.itemTotal,
    required this.deliveryFee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppStyles.spacing16),
      decoration: CartStyles.summaryDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSummaryRow('Item total', itemTotal),
          SizedBox(height: AppStyles.spacing8),
          _buildSummaryRow('Delivery fee', deliveryFee),
          SizedBox(height: AppStyles.spacing12),
          Divider(color: AppStyles.secondaryColor.withOpacity(0.2)),
          SizedBox(height: AppStyles.spacing12),
          _buildSummaryRow('Total', itemTotal + deliveryFee, isTotal: true),
          SizedBox(height: AppStyles.spacing20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: CartStyles.checkoutButtonStyle,
              child: Text('Go to Checkout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    final style = isTotal ? AppStyles.h2 : AppStyles.body1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: isTotal ? CartStyles.totalPriceStyle : style,
        ),
      ],
    );
  }
}
