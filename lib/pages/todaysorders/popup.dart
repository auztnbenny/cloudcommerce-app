// order_details_page.dart
import 'package:cloudcommerce/pages/todaysorders/popup_style.dart';
import 'package:cloudcommerce/services/popup.dart';
import 'package:cloudcommerce/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;
  final String userName;
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onDone;

  const OrderDetailsPage({
    Key? key,
    required this.orderId,
    required this.userName,
    required this.product,
    required this.onDone,
  }) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final _service = OrderDetailsService();
  final _style = OrderDetailsStyle();
  Map<String, dynamic>? _orderMaster;
  List<dynamic> _orderDetails = [];
  Map<String, dynamic>? _blankProduct;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final data = await _service.fetchOrderDetails(
        orderId: widget.orderId,
        userName: widget.userName,
        orderDate: DateTime.now(),
      );

      setState(() {
        _orderMaster = data['orderMaster'];
        _orderDetails = data['orderDetails'] ?? [];
        _blankProduct = data['blankProduct'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception:', '').trim();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildBody(),
            ),
          ],
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Order Details #${widget.orderId}',
            style: AppStyles.h2.copyWith(color: Colors.white),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _buildErrorView();
    }

    if (_orderMaster == null || _orderDetails.isEmpty) {
      return Center(child: Text('No data available', style: AppStyles.body1));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppStyles.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderInfo(),
          SizedBox(height: AppStyles.spacing16),
          _buildItemsTable(),
          SizedBox(height: AppStyles.spacing16),
          _buildTotals(),
          SizedBox(height: AppStyles.spacing24),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Card(
      elevation: 2,
      shape: _style.cardShape,
      child: Padding(
        padding: EdgeInsets.all(AppStyles.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
                'Order No:', _orderMaster!['OrderNo']?.toString() ?? ''),
            _buildInfoRow('Date:', _orderMaster!['OrderDateStr'] ?? ''),
            _buildInfoRow('Party:', _orderMaster!['PartyName'] ?? ''),
            if (_orderMaster!['Remarks']?.isNotEmpty ?? false)
              _buildInfoRow('Remarks:', _orderMaster!['Remarks']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppStyles.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: _style.labelStyle),
          ),
          Expanded(
            child: Text(value, style: _style.valueStyle),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsTable() {
    return Card(
      elevation: 2,
      shape: _style.cardShape,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Item', style: _style.tableHeaderStyle)),
            DataColumn(label: Text('Qty', style: _style.tableHeaderStyle)),
            DataColumn(label: Text('Rate', style: _style.tableHeaderStyle)),
            DataColumn(label: Text('Disc %', style: _style.tableHeaderStyle)),
            DataColumn(label: Text('Amount', style: _style.tableHeaderStyle)),
          ],
          rows: _orderDetails.map((item) => _buildTableRow(item)).toList(),
        ),
      ),
    );
  }

  DataRow _buildTableRow(Map<String, dynamic> item) {
    final formatCurrency = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 2,
      locale: 'en_IN',
    );

    return DataRow(
      cells: [
        DataCell(Text(item['itm_NAM'] ?? '', style: _style.tableContentStyle)),
        DataCell(Text(item['OrderQty']?.toString() ?? '0',
            style: _style.tableContentStyle)),
        DataCell(Text(formatCurrency.format(item['OrderRate'] ?? 0),
            style: _style.tableContentStyle)),
        DataCell(Text(item['Disper']?.toString() ?? '0',
            style: _style.tableContentStyle)),
        DataCell(Text(formatCurrency.format(item['OrderAmount'] ?? 0),
            style: _style.tableContentStyle)),
      ],
    );
  }

  Widget _buildTotals() {
    final formatCurrency = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 2,
      locale: 'en_IN',
    );

    return Card(
      elevation: 2,
      shape: _style.cardShape,
      child: Padding(
        padding: EdgeInsets.all(AppStyles.spacing16),
        child: Column(
          children: [
            _buildTotalRow(
              'Sub Total:',
              formatCurrency.format(_orderMaster!['TotAmount'] ?? 0),
            ),
            _buildTotalRow(
              'Discount:',
              formatCurrency.format(_orderMaster!['TotItemDiscount'] ?? 0),
            ),
            _buildTotalRow(
              'GST:',
              formatCurrency.format(_orderMaster!['GSTAmt'] ?? 0),
            ),
            Divider(height: AppStyles.spacing24),
            _buildTotalRow(
              'Net Amount:',
              formatCurrency.format(_orderMaster!['NetAmount'] ?? 0),
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppStyles.spacing4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal ? _style.totalLabelStyle : _style.labelStyle,
          ),
          Text(
            value,
            style: isTotal ? _style.totalValueStyle : _style.valueStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          //   style: _style.secondaryButtonStyle,
          child: Text('Cancel'),
        ),
        SizedBox(width: AppStyles.spacing16),
        ElevatedButton(
          onPressed: () {
            widget.onDone(_orderMaster!);
            Navigator.pop(context);
          },
          //   style: _style.primaryButtonStyle,
          child: Text('Done'),
        ),
      ],
    );
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
              onPressed: _fetchOrderDetails,
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: _style.retryButtonStyle,
            ),
          ],
        ),
      ),
    );
  }
}
