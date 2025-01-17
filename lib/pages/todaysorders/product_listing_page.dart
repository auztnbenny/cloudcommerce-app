// product_listing_page.dart
import 'package:cloudcommerce/pages/todaysorders/popup.dart';
import 'package:cloudcommerce/pages/todaysorders/cart_page.dart'; // Add this import
import 'package:cloudcommerce/services/cart_service.dart';
import 'package:cloudcommerce/services/product_listing.dart';
import 'package:cloudcommerce/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_listing_style.dart';

class ProductListingPage extends StatefulWidget {
  final String orderId;
  final String userName;

  const ProductListingPage({
    Key? key,
    required this.orderId,
    required this.userName,
  }) : super(key: key);

  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  final ProductListingController _controller = ProductListingController();
  final ProductListingStyle _style = ProductListingStyle();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _controller.filterProducts(_searchController.text);
  }

  Future<void> _initializeData() async {
    try {
      await _controller.init();
    } catch (e) {
      print('Error initializing product listing: $e');
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
          ),
          child: Container(
            padding: EdgeInsets.all(AppStyles.spacing16),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
              maxWidth: 400,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filter by Group', style: AppStyles.h2),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: AppStyles.spacing16),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return ListView(
                        children: [
                          _buildFilterOption('All Groups', ''),
                          ..._controller.groups
                              .map((group) => _buildFilterOption(group, group))
                              .toList(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: _buildAppBar(),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Column(
            children: [
              _buildSearchBar(),
              _buildFilterChips(),
              Expanded(
                child: _buildProductGrid(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterOption(String label, String value) {
    final isSelected = _controller.selectedGroup == value;

    return Container(
      margin: EdgeInsets.only(bottom: AppStyles.spacing8),
      child: Material(
        color: isSelected
            ? AppStyles.primaryColor.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
          onTap: () {
            _controller.selectedGroup = value;
            _controller.filterProducts(_searchController.text);
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.all(AppStyles.spacing12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: AppStyles.body1.copyWith(
                      color: isSelected
                          ? AppStyles.primaryColor
                          : AppStyles.textPrimaryColor,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check,
                    color: AppStyles.primaryColor,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Products', style: AppStyles.appBarTitleStyle),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: AppStyles.appBarHeight,
      flexibleSpace: Container(
        decoration: AppStyles.appBarDecoration,
      ),
      actions: [_buildCartButton()],
    );
  }

  Widget _buildCartButton() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart,
                  color: const Color.fromARGB(255, 255, 254, 254)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShoppingCartPage(
                      cartItems: Provider.of<CartProvider>(context).items,
                    ),
                  ),
                );
              },
            ),
            if (_controller.cartCount > 0)
              Positioned(
                right: AppStyles.spacing8,
                top: AppStyles.spacing8,
                child: Container(
                  padding: EdgeInsets.all(AppStyles.spacing4),
                  decoration: BoxDecoration(
                    color: AppStyles.errorColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '${_controller.cartCount}',
                    style: AppStyles.caption.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(AppStyles.spacing16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: _style.searchInputDecoration,
              style: AppStyles.body1,
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            color: _controller.hasActiveFilter
                ? AppStyles.primaryColor
                : AppStyles.secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    if (!_controller.hasActiveFilter) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppStyles.spacing16,
        vertical: AppStyles.spacing8,
      ),
      child: Wrap(
        spacing: AppStyles.spacing8,
        children: [
          FilterChip(
            label: Text(_controller.selectedGroup),
            onDeleted: _controller.clearFilter,
            labelStyle: AppStyles.body2,
            selected: true,
            onSelected: (bool selected) {
              if (!selected) {
                _controller.clearFilter();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    if (_controller.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_controller.hasError) {
      print('Error displaying products: ${_controller.errorMessage}');
      return _buildErrorView();
    }

    if (_controller.filteredProducts.isEmpty) {
      return Center(
        child: Text('No products found', style: AppStyles.body1),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: _controller.init,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: AppStyles.getScreenPadding(context),
              child: GridView.builder(
                gridDelegate: _style.getGridDelegate(constraints),
                itemCount: _controller.filteredProducts.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => _buildProductCard(index),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCard(int index) {
    final product = _controller.filteredProducts[index];
    final isInCart = _controller.isProductInCart(product);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: _buildProductImage(product),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(AppStyles.spacing8),
              child: _buildProductDetails(product, isInCart),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(dynamic product) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppStyles.radiusMedium),
        ),
        child: FadeInImage(
          placeholder: AssetImage('assets/images/mockup.jpg'),
          image: NetworkImage(_controller.getProductImageUrl(product)),
          fit: BoxFit.cover,
          imageErrorBuilder: (context, error, stackTrace) {
            debugPrint('Error loading image: $error');
            return Image.asset(
              'assets/images/mockup.jpg',
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductDetails(dynamic product, bool isInCart) {
    return GestureDetector(
      onTap: () => _showProductDialog(product),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              product['itm_NAM'] ?? '',
              style: AppStyles.h3,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: AppStyles.spacing4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${product['SalePrice'] ?? ''}',
                style: AppStyles.body1.copyWith(color: AppStyles.primaryColor),
              ),
              _buildProductCartButton(product, isInCart),
            ],
          ),
        ],
      ),
    );
  }

  void _showProductDialog(dynamic product) {
    showDialog(
      context: context,
      builder: (context) => OrderDetailsPage(
        itemCode: product['itm_COD']?.toString() ?? '',
        partyCode:
            widget.orderId, // Fixed: using widget.orderId instead of orderId
        orderDetails: product,
        onDone: (updatedProduct) {
          _controller.handleCart(updatedProduct);
        },
      ),
    );
  }

  Widget _buildProductCartButton(dynamic product, bool isInCart) {
    return IconButton(
      icon: Icon(
        isInCart ? Icons.shopping_cart_checkout : Icons.add_shopping_cart,
        color: isInCart ? AppStyles.primaryColor : AppStyles.secondaryColor,
      ),
      onPressed: () => _controller.handleCart(product),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _controller.errorMessage,
            style: AppStyles.body1.copyWith(color: AppStyles.errorColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppStyles.spacing16),
          ElevatedButton(
            onPressed: _controller.retryLoading,
            child: Text('Retry', style: AppStyles.button),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(AppStyles.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
