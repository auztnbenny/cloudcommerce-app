// order_details_page.dart
import 'package:cloudcommerce/pages/todaysorders/popup_style.dart';
import 'package:cloudcommerce/services/popup.dart';
import 'package:cloudcommerce/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailsPage extends StatefulWidget {
  final String itemCode;
  final String partyCode;
  final Function(Map<String, dynamic>) onDone;

  const OrderDetailsPage({
    Key? key,
    required this.itemCode,
    required this.partyCode,
    required this.onDone,
  }) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final _service = OrderDetailsService();
  final _style = OrderDetailsStyle();
  final _formKey = GlobalKey<FormState>();

  final _orderQtyController = TextEditingController(text: '0');
  final _freeQtyController = TextEditingController(text: '0');
  final _discountController = TextEditingController(text: '0');
  final _remarksController = TextEditingController();

  Map<String, dynamic> _blankProduct = {
    "ActionType": 0,
    "DelFlag": 0,
    "Disper": "",
    "FreeQty": 0,
    "ItemDisAmount": 0,
    "OrderAmount": 0,
    "OrderID": 0,
    "OrderQty": 0,
    "OrderRate": 0,
    "OrderRemarks": "",
    "OrderTransID": 0,
    "PLUCODE": "",
    "STKSVRSTOCK": 0,
    "STOCKCOLOR": "",
    "STOCKLastRate": 0,
    "STOCKMRP": 0,
    "STOCKSalePrice": 0,
    "STOCKWSPrice": 0,
    "SVRSTKID": 0,
    "SaleRate": 0,
    "TotQty": 0,
    "TrnAmount": 0,
    "TrnCGSTAmt": 0,
    "TrnCGSTPer": 0,
    "TrnCessAmt": 0,
    "TrnCessPer": 0,
    "TrnGSTAmt": 0,
    "TrnGSTPer": 0,
    "TrnGrossAmt": 0,
    "TrnIGSTAmt": 0,
    "TrnIGSTPer": 0,
    "TrnNetAmount": 0,
    "TrnSGSTAmt": 0,
    "TrnSGSTPer": 0,
    "itm_CD": 0,
    "itm_NAM": ""
  };

  bool _isLoading = true;
  bool _showMoreOptions = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchItemDetails();
    _setupCalculationListeners();
  }

  void _setupCalculationListeners() {
    _orderQtyController.addListener(_handleCalculations);
    _freeQtyController.addListener(_handleCalculations);
    _discountController.addListener(_handleCalculations);
  }

  @override
  void dispose() {
    _orderQtyController.dispose();
    _freeQtyController.dispose();
    _discountController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _fetchItemDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await _service.fetchItemMaster(
        itemCode: widget.itemCode,
        partyCode: widget.partyCode,
      );

      _initializeFromResponse(response);
      _handleCalculations();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception:', '').trim();
        _isLoading = false;
      });
    }
  }

  void _initializeFromResponse(Map<String, dynamic> response) {
    _blankProduct.update('OrderRate',
        (_) => double.tryParse(response['SalePrice']?.toString() ?? '0') ?? 0);
    _blankProduct.update(
        'STKSVRSTOCK',
        (_) =>
            double.tryParse(response['STKSVRSTOCK']?.toString() ?? '0') ?? 0);
    _blankProduct.update('STOCKCOLOR', (_) => response['STOCKCOLOR'] ?? '');
    _blankProduct.update('itm_NAM', (_) => response['itm_NAM'] ?? '');
    _blankProduct.update('STOCKMRP',
        (_) => double.tryParse(response['MRP']?.toString() ?? '0') ?? 0);
    _blankProduct.update('STOCKLastRate',
        (_) => double.tryParse(response['LastRate']?.toString() ?? '0') ?? 0);
    _blankProduct.update('STOCKSalePrice',
        (_) => double.tryParse(response['SalePrice']?.toString() ?? '0') ?? 0);
    _blankProduct.update('STOCKWSPrice',
        (_) => double.tryParse(response['WSPrice']?.toString() ?? '0') ?? 0);
    _blankProduct.update('SVRSTKID', (_) => response['SVRSTKID'] ?? 0);
    _blankProduct.update(
        'TrnCGSTPer',
        (_) =>
            double.tryParse(response['STKCGSTRate']?.toString() ?? '0') ?? 0);
    _blankProduct.update(
        'TrnIGSTPer',
        (_) =>
            double.tryParse(response['STKIGSTRate']?.toString() ?? '0') ?? 0);
    _blankProduct.update(
        'TrnSGSTPer',
        (_) =>
            double.tryParse(response['STKSGSTRate']?.toString() ?? '0') ?? 0);
    _blankProduct.update('TrnGSTPer',
        (_) => double.tryParse(response['STKGSTRate']?.toString() ?? '0') ?? 0);
    _blankProduct.update(
        'TrnCessPer',
        (_) =>
            double.tryParse(response['OrderCesPer']?.toString() ?? '0') ?? 0);
  }

  void _handleCalculations() {
    final orderQty = double.tryParse(_orderQtyController.text) ?? 0;
    final freeQty = double.tryParse(_freeQtyController.text) ?? 0;
    final discount = double.tryParse(_discountController.text) ?? 0;
    final orderRate = _blankProduct['OrderRate'] ?? 0.0;

    setState(() {
      // Update input values
      _blankProduct['OrderQty'] = orderQty;
      _blankProduct['FreeQty'] = freeQty;
      _blankProduct['Disper'] = discount;

      // Calculate SaleRate
      final trnGstPer = _blankProduct['TrnGSTPer'] ?? 0.0;
      final trnCessPer = _blankProduct['TrnCessPer'] ?? 0.0;
      _blankProduct['SaleRate'] =
          (orderRate / (trnGstPer + trnCessPer + 100)) * 100;

      // Calculate Order Amount and Transaction Amount
      _blankProduct['OrderAmount'] = orderRate * orderQty;
      _blankProduct['TrnAmount'] = _blankProduct['SaleRate'] * orderQty;

      // Calculate Discount Amount
      _blankProduct['ItemDisAmount'] =
          (_blankProduct['OrderAmount'] * discount) / 100;
      _blankProduct['TrnGrossAmt'] =
          _blankProduct['TrnAmount'] - _blankProduct['ItemDisAmount'];

      final trnGrossAmt = _blankProduct['TrnGrossAmt'];

      // Calculate GST Amounts
      _blankProduct['TrnCGSTAmt'] =
          trnGrossAmt * (_blankProduct['TrnCGSTPer'] / 100);
      _blankProduct['TrnSGSTAmt'] =
          trnGrossAmt * (_blankProduct['TrnSGSTPer'] / 100);
      _blankProduct['TrnGSTAmt'] =
          _blankProduct['TrnCGSTAmt'] + _blankProduct['TrnSGSTAmt'];
      _blankProduct['TrnCessAmt'] = trnGrossAmt * (trnCessPer / 100);

      // Calculate Net Amount
      _blankProduct['TrnNetAmount'] = trnGrossAmt + _blankProduct['TrnGSTAmt'];
      _blankProduct['TotQty'] = orderQty + freeQty;
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
                Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_error != null)
                Expanded(child: _buildErrorView())
              else
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(AppStyles.spacing16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStockInfo(),
                        SizedBox(height: AppStyles.spacing16),
                        _buildMainForm(),
                        SizedBox(height: AppStyles.spacing16),
                        _buildMoreOptionsSection(),
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
    return Container(
      padding: EdgeInsets.all(AppStyles.spacing16),
      decoration: BoxDecoration(
        color: AppStyles.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppStyles.radiusMedium),
          topRight: Radius.circular(AppStyles.radiusMedium),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _blankProduct['itm_NAM'] ?? 'Item Details',
              style: AppStyles.h2.copyWith(color: Colors.white),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStockInfo() {
    final stock = _blankProduct['STKSVRSTOCK'] ?? 0;
    return Row(
      children: [
        Text('Stock Available:', style: _style.labelStyle),
        SizedBox(width: AppStyles.spacing8),
        Text(
          stock.toString(),
          style: stock > 0
              ? _style.stockAvailableStyle
              : _style.stockUnavailableStyle,
        ),
      ],
    );
  }

  Widget _buildMainForm() {
    final formatCurrency = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

    return Column(
      children: [
        _buildInputField(
          label: 'Order Quantity',
          controller: _orderQtyController,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: AppStyles.spacing12),
        _buildReadOnlyField(
          label: 'Rate',
          value: formatCurrency.format(_blankProduct['OrderRate']),
        ),
        SizedBox(height: AppStyles.spacing12),
        _buildReadOnlyField(
          label: 'Total Amount',
          value: formatCurrency.format(_blankProduct['OrderAmount']),
        ),
        SizedBox(height: AppStyles.spacing12),
        _buildInputField(
          label: 'Free Quantity',
          controller: _freeQtyController,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: AppStyles.spacing12),
        _buildInputField(
          label: 'Discount %',
          controller: _discountController,
          keyboardType: TextInputType.number,
          suffix: '%',
        ),
      ],
    );
  }

  Widget _buildMoreOptionsSection() {
    final formatCurrency = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text('More Options', style: _style.inputLabelStyle),
          children: [
            Padding(
              padding: EdgeInsets.all(AppStyles.spacing16),
              child: Column(
                children: [
                  _buildReadOnlyField(
                    label: 'Sale Rate',
                    value: formatCurrency.format(_blankProduct['SaleRate']),
                  ),
                  SizedBox(height: AppStyles.spacing12),
                  _buildReadOnlyField(
                    label: 'Amount',
                    value: formatCurrency.format(_blankProduct['TrnAmount']),
                  ),
                  SizedBox(height: AppStyles.spacing12),
                  _buildReadOnlyField(
                    label: 'Discounted Amount',
                    value:
                        formatCurrency.format(_blankProduct['ItemDisAmount']),
                  ),
                  SizedBox(height: AppStyles.spacing12),
                  _buildReadOnlyField(
                    label: 'Gross Amount',
                    value: formatCurrency.format(_blankProduct['TrnGrossAmt']),
                  ),
                  SizedBox(height: AppStyles.spacing12),
                  _buildReadOnlyField(
                    label: 'GST Amount',
                    value: formatCurrency.format(_blankProduct['TrnGSTAmt']),
                  ),
                  SizedBox(height: AppStyles.spacing12),
                  _buildReadOnlyField(
                    label: 'Net Amount',
                    value: formatCurrency.format(_blankProduct['TrnNetAmount']),
                  ),
                  SizedBox(height: AppStyles.spacing12),
                  _buildInputField(
                    label: 'Remarks',
                    controller: _remarksController,
                    keyboardType: TextInputType.text,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _style.inputLabelStyle),
        SizedBox(height: AppStyles.spacing4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: _style.getInputDecoration().copyWith(
                suffixText: suffix,
              ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label is required';
            }
            if (keyboardType == TextInputType.number) {
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              if (label.contains('Quantity') && double.parse(value) < 0) {
                return 'Quantity cannot be negative';
              }
              if (label.contains('Discount') &&
                  (double.parse(value) < 0 || double.parse(value) > 100)) {
                return 'Discount must be between 0 and 100';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _style.inputLabelStyle),
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
          child: Text(
            value,
            style: _style.valueStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(AppStyles.spacing16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
            style: _style.secondaryButtonStyle,
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

  void _handleDone() {
    if (_formKey.currentState?.validate() ?? false) {
      // Update remarks
      _blankProduct['OrderRemarks'] = _remarksController.text;

      // Do final calculations
      _handleCalculations();

      // Notify parent with updated product
      widget.onDone(_blankProduct);
      Navigator.pop(context);
    }
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppStyles.spacing16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: AppStyles.errorColor,
              size: 48,
            ),
            SizedBox(height: AppStyles.spacing16),
            Text(
              _error ?? 'An error occurred',
              style: AppStyles.body1.copyWith(color: AppStyles.errorColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppStyles.spacing24),
            ElevatedButton.icon(
              onPressed: _fetchItemDetails,
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
