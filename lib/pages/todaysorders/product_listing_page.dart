// product_listing_page.dart
import 'package:cloudcommerce/pages/todaysorders/popup.dart';
import 'package:cloudcommerce/services/product_listing.dart';
import 'package:cloudcommerce/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'product_listing_style.dart';

class ProductListingPage extends StatefulWidget {
  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  final ProductListingController _controller = ProductListingController();
  final ProductListingStyle _style = ProductListingStyle();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await _controller.init();
    } catch (e) {
      print('Error initializing product listing: $e');
    }
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
              onPressed: _controller.navigateToCart,
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
              onChanged: _controller.filterProducts,
              decoration: _style.searchInputDecoration,
              style: AppStyles.body1,
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _controller.showGroupFilterDialog(context),
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
        child: Image.network(
          _controller.getProductImageUrl(product),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading image: $error');
            return Container(
              color: AppStyles.secondaryColor.withOpacity(0.1),
              child: Icon(Icons.image_not_supported,
                  color: AppStyles.secondaryColor),
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
      builder: (context) => ProductDialog(
        product: product,
        onDone: (Map<String, dynamic> updatedProduct) {
          // Handle the updated product, for example:
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
