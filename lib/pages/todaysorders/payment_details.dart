import 'package:cloudcommerce/models/payment_details_model.dart';
import 'package:cloudcommerce/services/payment_details_service.dart';
import 'package:flutter/material.dart';

class PaymentDetailsPage extends StatefulWidget {
  final String buyerName;
  final int accAutoId;
  final int year;

  const PaymentDetailsPage({
    Key? key,
    required this.buyerName,
    required this.accAutoId,
    this.year = 2024,
  }) : super(key: key);

  @override
  _PaymentDetailsPageState createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  List<PaymentDetailsModel> _paymentDetails = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchPaymentDetails();
  }

  Future<void> _fetchPaymentDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final details = await PaymentDetailsRepository.fetchPaymentDetails(
        buyerName: widget.buyerName,
        accAutoId: widget.accAutoId,
        year: widget.year,
      );

      setState(() {
        _paymentDetails = details;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching payment details: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details - ${widget.buyerName}'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _buildPaymentDetailsTable(),
    );
  }

  Widget _buildPaymentDetailsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 10,
        columns: const [
          DataColumn(label: Text('SI.No')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Ref/VchNo')),
          DataColumn(label: Text('Nature')),
          DataColumn(label: Text('Debit')),
          DataColumn(label: Text('Credit')),
          DataColumn(label: Text('Balance')),
        ],
        rows: _paymentDetails.map((payment) {
          return DataRow(
            cells: [
              DataCell(Text('${payment.siNo}')),
              DataCell(Text(payment.date)),
              DataCell(Text(payment.refVchNo)),
              DataCell(Text(payment.nature)),
              DataCell(Text('${payment.debit}')),
              DataCell(Text('${payment.credit}')),
              DataCell(Text('${payment.balance}')),
            ],
          );
        }).toList(),
      ),
    );
  }
}
