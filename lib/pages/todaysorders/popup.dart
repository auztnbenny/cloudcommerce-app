// order_details_page.dart
import 'package:cloudcommerce/pages/todaysorders/popup_style.dart';
import 'package:cloudcommerce/services/popup.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloudcommerce/styles/app_styles.dart';
import 'dart:developer' as developer; // Add this import

class OrderDetailsPage extends StatefulWidget {
  final String itemCode;
  final String partyCode;
  final Map<String, dynamic>? orderDetails; // Existing order details if any
  final Function(Map<String, dynamic>) onDone;

  const OrderDetailsPage({
    Key? key,
    required this.itemCode,
    required this.partyCode,
    this.orderDetails,
    required this.onDone,
  }) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final _service = OrderDetailsService();
  final _style = OrderDetailsStyle();
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _orderQtyController = TextEditingController(text: '0');
  final _freeQtyController = TextEditingController(text: '0');
  final _discountController = TextEditingController(text: '0');
  final _remarksController = TextEditingController();

  Map<String, dynamic> _productDetails = {};
  Map<String, dynamic> _stockStatus = {
    'FinalStock': 0.0,
    'OrderQty': 0.0, // This matches the key from service now
  };
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.orderDetails != null) {
      _initializeFromExistingProduct();
    } else {
      _fetchDetails();
    }
    _setupCalculationListeners();
  }

  void _initializeFromExistingProduct() {
    setState(() {
      _productDetails = {
        'OrderRate': widget.orderDetails?['SalePrice'] ??
            0.0, // Changed from OrderRate to SalePrice
        'STKSVRSTOCK': widget.orderDetails?['STKSVRSTOCK'] ?? 0.0,
        'STOCKCOLOR': widget.orderDetails?['STOCKCOLOR'] ?? '',
        'itm_NAM': widget.orderDetails?['itm_NAM'] ?? '',
        'MRP': widget.orderDetails?['MRP'] ?? 0.0,
        'STOCKLastRate': widget.orderDetails?['STOCKLastRate'] ?? 0.0,
        'SalePrice': widget.orderDetails?['SalePrice'] ?? 0.0,
        'WSPrice': widget.orderDetails?['WSPrice'] ?? 0.0,
        'SVRSTKID': widget.orderDetails?['SVRSTKID']?.toString() ?? '',
        'TrnCGSTPer': widget.orderDetails?['STKCGSTRate'] ?? 0.0,
        'TrnIGSTPer': widget.orderDetails?['STKIGSTRate'] ?? 0.0,
        'TrnSGSTPer': widget.orderDetails?['STKSGSTRate'] ?? 0.0,
        'TrnGSTPer': widget.orderDetails?['STKGSTRate'] ?? 0.0,
        'TrnCessPer': widget.orderDetails?['OrderCesPer'] ?? 0.0,
        'SaleRate': widget.orderDetails?['SaleRate'] ?? 0.0,
        'OrderQty': widget.orderDetails?['OrderQty'] ?? 0.0,
        'FreeQty': widget.orderDetails?['FreeQty'] ?? 0.0,
        'Disper': widget.orderDetails?['Disper'] ?? '',
        'OrderAmount': widget.orderDetails?['OrderAmount'] ?? 0.0,
        'TrnAmount': widget.orderDetails?['TrnAmount'] ?? 0.0,
        'ItemDisAmount': widget.orderDetails?['ItemDisAmount'] ?? 0.0,
        'TrnGrossAmt': widget.orderDetails?['TrnGrossAmt'] ?? 0.0,
        'TrnCGSTAmt': widget.orderDetails?['TrnCGSTAmt'] ?? 0.0,
        'TrnSGSTAmt': widget.orderDetails?['TrnSGSTAmt'] ?? 0.0,
        'TrnGSTAmt': widget.orderDetails?['TrnGSTAmt'] ?? 0.0,
        'TrnNetAmount': widget.orderDetails?['TrnNetAmount'] ?? 0.0,
        'TrnCessAmt': widget.orderDetails?['TrnCessAmt'] ?? 0.0,
        'TotQty': widget.orderDetails?['TotQty'] ?? 0.0,
        'OrderRemarks': widget.orderDetails?['OrderRemarks'] ?? '',
      };

      // Initialize controllers with existing values
      _orderQtyController.text =
          (_productDetails['OrderQty'] ?? 0.0).toString();
      _freeQtyController.text = (_productDetails['FreeQty'] ?? 0.0).toString();
      _discountController.text = (_productDetails['Disper'] ?? '').toString();
      _remarksController.text =
          _productDetails['OrderRemarks']?.toString() ?? '';

      _isLoading = false;
    });

    // Fetch latest stock status
    _updateStockStatus();
  }

  Future<void> _updateStockStatus() async {
    try {
      final svrStkId = _productDetails['SVRSTKID']?.toString() ?? '';

      developer.log(
        'Updating stock status with SVRSTKID: $svrStkId',
        name: 'OrderDetailsPage',
      );

      if (svrStkId.isEmpty) {
        developer.log(
          'Empty SVRSTKID, skipping stock status update',
          name: 'OrderDetailsPage',
        );
        return;
      }

      final stockStatus = await _service.getStockStatus(svrStkId);
      developer.log(
        'Stock Status Update: $stockStatus',
        name: 'OrderDetailsPage',
      );

      if (mounted) {
        setState(() {
          _stockStatus = stockStatus;
        });
      }
    } catch (e) {
      developer.log(
        'Error updating stock status: $e',
        name: 'OrderDetailsPage',
      );
    }
  }

  void _setupCalculationListeners() {
    _orderQtyController.addListener(_handleCalculations);
    _freeQtyController.addListener(_handleCalculations);
    _discountController.addListener(_handleCalculations);
  }

  Future<void> _fetchDetails() async {
    if (widget.itemCode.isEmpty) {
      setState(() {
        _error = 'Invalid item code';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await _service.fetchItemMaster(
        itemCode: widget.itemCode,
        partyCode: widget.partyCode,
      );

      if (mounted) {
        setState(() {
          _productDetails = _initializeProductDetails(response['itemDetails']);
          // _stockStatus = response['stockDetails'];
          _isLoading = false;
        });
        await _updateStockStatus();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception:', '').trim();
          _isLoading = false;
        });
      }
    }
  }

  void _handleDone() {
    if (_formKey.currentState?.validate() ?? false) {
      // Ensure all calculations are up to date
      _handleCalculations();

      // Update remarks
      _productDetails['OrderRemarks'] = _remarksController.text;

      // Add any additional fields needed for cart
      _productDetails['itm_COD'] = widget.itemCode;

      widget.onDone(_productDetails);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _orderQtyController.dispose();
    _freeQtyController.dispose();
    _discountController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _initializeProductDetails(
      Map<String, dynamic> response) {
    final orderRate =
        response['SalePrice'] ?? 0.0; // This is correct, keep using SalePrice
    final gstRate = response['STKGSTRate'] ?? 0.0;
    final cessPer = response['OrderCesPer'] ?? 0.0;

    return {
      'OrderRate':
          orderRate, // This is already using SalePrice through orderRate
      'FinalStock': response['FinalStock'] ?? 0.0,
      'STOCKCOLOR': response['STOCKCOLOR'] ?? '',
      'itm_NAM': response['itm_NAM'] ?? '',
      'MRP': response['MRP'] ?? 0.0,
      'STOCKLastRate': response['LastRate'] ?? 0.0,
      'SalePrice': response['SalePrice'] ?? 0.0,
      'WSPrice': response['WSPrice'] ?? 0.0,
      'SVRSTKID': response['SVRSTKID'] ?? '',
      'TrnCGSTPer': response['STKCGSTRate'] ?? 0.0,
      'TrnIGSTPer': response['STKIGSTRate'] ?? 0.0,
      'TrnSGSTPer': response['STKSGSTRate'] ?? 0.0,
      'TrnGSTPer': gstRate,
      'TrnCessPer': cessPer,
      'SaleRate': (orderRate / (gstRate + cessPer + 100)) * 100,

      // Initialize calculated values
      'OrderQty': 0.0,
      'FreeQty': 0.0,
      'Disper': '',
      'OrderAmount': 0.0,
      'TrnAmount': 0.0,
      'ItemDisAmount': 0.0,
      'TrnGrossAmt': 0.0,
      'TrnCGSTAmt': 0.0,
      'TrnSGSTAmt': 0.0,
      'TrnGSTAmt': 0.0,
      'TrnNetAmount': 0.0,
      'TrnCessAmt': 0.0,
      'TotQty': 0.0,
      'OrderRemarks': '',
    };
  }

  void _handleCalculations() {
    if (!mounted) return;

    final orderQty = double.tryParse(_orderQtyController.text) ?? 0;
    final freeQty = double.tryParse(_freeQtyController.text) ?? 0;
    final discount = double.tryParse(_discountController.text) ?? 0;

    setState(() {
      // Update quantities
      _productDetails['OrderQty'] = orderQty;
      _productDetails['FreeQty'] = freeQty;
      _productDetails['Disper'] = discount;

      // Calculate Sale Rate (with proper type conversion)
      final orderRate =
          double.tryParse(_productDetails['OrderRate']?.toString() ?? '0') ??
              0.0;
      final trnGstPer =
          double.tryParse(_productDetails['TrnGSTPer']?.toString() ?? '0') ??
              0.0;
      final trnCessPer =
          double.tryParse(_productDetails['TrnCessPer']?.toString() ?? '0') ??
              0.0;

      // Ensure we don't divide by zero and match React's precision
      final divisor = trnGstPer + trnCessPer + 100;
      _productDetails['SaleRate'] = divisor > 0
          ? double.parse(((orderRate * 100) / divisor).toStringAsFixed(2))
          : double.parse(orderRate.toStringAsFixed(2));

      // Calculate amounts with precision matching React
      _productDetails['OrderAmount'] =
          double.parse((orderRate * orderQty).toStringAsFixed(2));

      final saleRate = _productDetails['SaleRate'] ?? 0.0;
      _productDetails['TrnAmount'] =
          double.parse((saleRate * orderQty).toStringAsFixed(2));

      // Calculate discounts with precision
      _productDetails['ItemDisAmount'] = discount > 0
          ? double.parse(
              ((_productDetails['OrderAmount'] ?? 0.0) * discount / 100)
                  .toStringAsFixed(2))
          : 0.0;

      _productDetails['TrnGrossAmt'] = double.parse(
          ((_productDetails['TrnAmount'] ?? 0.0) -
                  (_productDetails['ItemDisAmount'] ?? 0.0))
              .toStringAsFixed(2));

      final trnGrossAmt = _productDetails['TrnGrossAmt'] ?? 0.0;

      // Calculate GST amounts with precision
      final trncGstPer =
          double.tryParse(_productDetails['TrnCGSTPer']?.toString() ?? '0') ??
              0.0;
      final trnsGstPer =
          double.tryParse(_productDetails['TrnSGSTPer']?.toString() ?? '0') ??
              0.0;

      _productDetails['TrnCGSTAmt'] =
          double.parse((trnGrossAmt * (trncGstPer / 100)).toStringAsFixed(2));

      _productDetails['TrnSGSTAmt'] =
          double.parse((trnGrossAmt * (trnsGstPer / 100)).toStringAsFixed(2));

      _productDetails['TrnGSTAmt'] = double.parse(
          ((_productDetails['TrnCGSTAmt'] ?? 0.0) +
                  (_productDetails['TrnSGSTAmt'] ?? 0.0))
              .toStringAsFixed(2));

      _productDetails['TrnNetAmount'] = double.parse(
          (trnGrossAmt + (_productDetails['TrnGSTAmt'] ?? 0.0))
              .toStringAsFixed(2));

      _productDetails['TrnCessAmt'] =
          double.parse((trnGrossAmt * (trnCessPer / 100)).toStringAsFixed(2));

      _productDetails['TotQty'] =
          double.parse((orderQty + freeQty).toStringAsFixed(2));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildHeader(),
              if (_isLoading)
                Expanded(child: Center(child: CircularProgressIndicator()))
              else if (_error != null)
                Expanded(child: _buildErrorView())
              else
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(AppStyles.spacing16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInitialFields(),
                        SizedBox(height: AppStyles.spacing16),
                        _buildMainFields(),
                        SizedBox(height: AppStyles.spacing16),
                        _buildExpandableSection(),
                      ],
                    ),
                  ),
                ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final rates = [
      'SP: ${_productDetails['SalePrice']}',
      'WSP: ${_productDetails['WSPrice']}',
      'MRP: ${_productDetails['MRP']}',
    ];
    if (_productDetails['STOCKLastRate'] != null &&
        _productDetails['STOCKLastRate'] > 0) {
      rates.add('LP: ${_productDetails['STOCKLastRate']}');
    }

    return Container(
      padding: EdgeInsets.all(AppStyles.spacing16),
      decoration: BoxDecoration(
        color: AppStyles.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppStyles.radiusMedium),
          topRight: Radius.circular(AppStyles.radiusMedium),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Item Rate',
                  style: _style.labelStyle.copyWith(color: Colors.white),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Text(
            rates.join(', '),
            style: _style.valueStyle.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStockInfo(),
        SizedBox(height: AppStyles.spacing16),
        _buildQuantityField(),
      ],
    );
  }

  Widget _buildStockInfo() {
    final stockColor =
        _style.getStockColor(_productDetails['STOCKCOLOR'] ?? '');

    return Row(
      children: [
        _buildStockInfoItem(
          'Stk Avl:',
          '${_stockStatus['FinalStock']}',
          stockColor,
        ),
        SizedBox(width: AppStyles.spacing8),
        _buildStockInfoItem(
          'Order Qty:',
          '${_stockStatus['OrderQty']}',
          stockColor,
        ),
      ],
    );
  }

  Widget _buildStockInfoItem(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppStyles.spacing8,
        vertical: AppStyles.spacing4,
      ),
      decoration: _style.stockInfoDecoration(color),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: _style.labelStyle.copyWith(color: Colors.white),
          ),
          SizedBox(width: AppStyles.spacing4),
          Text(
            value,
            style: _style.stockStyle.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quantity', style: _style.labelStyle),
        SizedBox(height: AppStyles.spacing8),
        TextFormField(
          controller: _orderQtyController,
          keyboardType: TextInputType.number,
          decoration: _style.getInputDecoration(),
          onChanged: (value) {
            _handleCalculations();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter quantity';
            }
            final qty = double.tryParse(value);
            if (qty == null || qty < 0) {
              return 'Please enter valid quantity';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMainFields() {
    final formatCurrency = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReadOnlyField(
          'Rate',
          _productDetails['SalePrice']?.toString() ?? '0',
          // onChanged: (value) {
          //   _productDetails['SalePrice'] = double.tryParse(value) ?? 0;
          // },
        ),
        SizedBox(height: AppStyles.spacing12),
        _buildReadOnlyField(
          'Total Amount',
          formatCurrency.format(_productDetails['OrderAmount'] ?? 0),
        ),
        SizedBox(height: AppStyles.spacing12),
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                'Free Qty',
                _freeQtyController.text,
                onChanged: (value) {
                  _freeQtyController.text = value;
                  _handleCalculations();
                },
              ),
            ),
            SizedBox(width: AppStyles.spacing12),
            Expanded(
              child: _buildInputField(
                'Discount %',
                _discountController.text,
                onChanged: (value) {
                  _discountController.text = value;
                  _handleCalculations();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandableSection() {
    final formatCurrency = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

    return ExpansionTile(
      title: Text('More Options', style: _style.labelStyle),
      children: [
        Padding(
          padding: EdgeInsets.all(AppStyles.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReadOnlyField(
                'Sale Rate',
                formatCurrency.format(_productDetails['SaleRate'] ?? 0),
              ),
              SizedBox(height: AppStyles.spacing12),
              _buildReadOnlyField(
                'Amount',
                formatCurrency.format(_productDetails['TrnAmount'] ?? 0),
              ),
              SizedBox(height: AppStyles.spacing12),
              _buildReadOnlyField(
                'Discounted Amount',
                formatCurrency.format(_productDetails['ItemDisAmount'] ?? 0),
              ),
              SizedBox(height: AppStyles.spacing12),
              _buildReadOnlyField(
                'Gross Amount',
                formatCurrency.format(_productDetails['TrnGrossAmt'] ?? 0),
              ),
              SizedBox(height: AppStyles.spacing12),
              _buildReadOnlyField(
                'GST Amount',
                formatCurrency.format(_productDetails['TrnGSTAmt'] ?? 0),
              ),
              SizedBox(height: AppStyles.spacing12),
              _buildReadOnlyField(
                'Net Amount',
                formatCurrency.format(_productDetails['TrnNetAmount'] ?? 0),
              ),
              SizedBox(height: AppStyles.spacing12),
              _buildInputField(
                'Remarks',
                _remarksController.text,
                onChanged: (value) => _remarksController.text = value,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    String value, {
    Function(String)? onChanged,
    int? maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _style.labelStyle),
        SizedBox(height: AppStyles.spacing4),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          maxLines: maxLines ?? 1,
          keyboardType:
              maxLines == null ? TextInputType.number : TextInputType.text,
          decoration: _style.getInputDecoration(),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _style.labelStyle),
        SizedBox(height: AppStyles.spacing4),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppStyles.spacing12,
            vertical: AppStyles.spacing12,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppStyles.secondaryColor.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
            color: Colors.grey[50],
          ),
          child: Text(value, style: _style.valueStyle),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(AppStyles.spacing16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: _style.secondaryButtonStyle,
            child: Text('Cancel'),
          ),
          SizedBox(width: AppStyles.spacing16),
          ElevatedButton(
            onPressed: _handleDone,
            style: _style.primaryButtonStyle,
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppStyles.spacing16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppStyles.errorColor, size: 48),
            SizedBox(height: AppStyles.spacing16),
            Text(
              _error ?? 'An error occurred',
              style: AppStyles.body1.copyWith(color: AppStyles.errorColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppStyles.spacing24),
            ElevatedButton.icon(
              onPressed: _fetchDetails,
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: _style.primaryButtonStyle,
            ),
          ],
        ),
      ),
    );
  }
}
