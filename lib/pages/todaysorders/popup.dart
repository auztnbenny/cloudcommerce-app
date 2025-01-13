import 'package:cloudcommerce/pages/todaysorders/popup_style.dart';
import 'package:flutter/material.dart';
import 'package:cloudcommerce/styles/app_styles.dart';

class ProductDialog extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onDone;

  const ProductDialog({
    Key? key,
    required this.product,
    required this.onDone,
  }) : super(key: key);

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  late Map<String, dynamic> productDetails;
  bool showMoreOptions = false;
  final _style = ProductDialogStyle();
  final _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productDetails = Map.from(widget.product);
  }

  void updateValue(String key, dynamic value) {
    setState(() {
      productDetails[key] = value;
      // Recalculate dependent values
      calculateAmounts();
    });
  }

  void calculateAmounts() {
    double rate = double.tryParse(productDetails['OrderRate'].toString()) ?? 0;
    double quantity =
        double.tryParse(productDetails['Quantity'].toString()) ?? 0;
    double discount = double.tryParse(productDetails['Disper'].toString()) ?? 0;

    // Basic calculations
    double amount = rate * quantity;
    double discountAmount = amount * (discount / 100);
    double grossAmount = amount - discountAmount;
    double gstRate = double.tryParse(productDetails['GSTRate'].toString()) ?? 0;
    double gstAmount = grossAmount * (gstRate / 100);
    double netAmount = grossAmount + gstAmount;

    setState(() {
      productDetails['OrderAmount'] = amount.toStringAsFixed(2);
      productDetails['ItemDisAmount'] = discountAmount.toStringAsFixed(2);
      productDetails['TrnGrossAmt'] = grossAmount.toStringAsFixed(2);
      productDetails['TrnGSTAmt'] = gstAmount.toStringAsFixed(2);
      productDetails['TrnNetAmount'] = netAmount.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Padding(
              padding: EdgeInsets.all(AppStyles.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainInputs(),
                  _buildSecondaryInputs(),
                  _buildMoreOptions(),
                  _buildActions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(AppStyles.spacing16),
      decoration: _style.headerDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              productDetails['itm_NAM'] ?? '',
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

  Widget _buildMainInputs() {
    return Column(
      children: [
        _buildInputPair(
          'Rate',
          'OrderRate',
          'Amount',
          'OrderAmount',
          canEditSecond: false,
        ),
        SizedBox(height: AppStyles.spacing16),
        _buildInputPair(
          'Free Qty',
          'FreeQty',
          'Discount %',
          'Disper',
        ),
      ],
    );
  }

  Widget _buildInputPair(
    String label1,
    String key1,
    String label2,
    String key2, {
    bool canEditSecond = true,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildInputField(
            label: label1,
            value: productDetails[key1]?.toString() ?? '',
            onChanged: (value) => updateValue(key1, value),
          ),
        ),
        SizedBox(width: AppStyles.spacing16),
        Expanded(
          child: _buildInputField(
            label: label2,
            value: productDetails[key2]?.toString() ?? '',
            onChanged:
                canEditSecond ? (value) => updateValue(key2, value) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String value,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _style.labelStyle),
        SizedBox(height: AppStyles.spacing8),
        TextField(
          controller: TextEditingController(text: value),
          style: AppStyles.body1,
          decoration: _style.inputDecoration,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: onChanged,
          enabled: onChanged != null,
        ),
      ],
    );
  }

  Widget _buildSecondaryInputs() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppStyles.spacing16),
      child: _buildInputPair(
        'Sale Rate',
        'SaleRate',
        'Amount',
        'TrnAmount',
        canEditSecond: false,
      ),
    );
  }

  Widget _buildMoreOptions() {
    return ExpansionTile(
      title: Text('More options', style: AppStyles.body1),
      children: [
        _buildInputPair(
          'Discounted Amt',
          'ItemDisAmount',
          'Gross Amt',
          'TrnGrossAmt',
          canEditSecond: false,
        ),
        SizedBox(height: AppStyles.spacing16),
        _buildInputPair(
          'GST Amt',
          'TrnGSTAmt',
          'Net Amt',
          'TrnNetAmount',
          canEditSecond: false,
        ),
        SizedBox(height: AppStyles.spacing16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Remarks', style: _style.labelStyle),
            SizedBox(height: AppStyles.spacing8),
            TextField(
              controller: _remarksController,
              decoration: _style.inputDecoration.copyWith(
                hintText: 'Enter Remarks',
              ),
              maxLines: 2,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Container(
      margin: EdgeInsets.only(top: AppStyles.spacing16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: _style.primaryButtonStyle,
            onPressed: () {
              productDetails['Remarks'] = _remarksController.text;
              widget.onDone(productDetails);
              Navigator.pop(context);
            },
            child: Text('DONE', style: AppStyles.button),
          ),
        ],
      ),
    );
  }
}
