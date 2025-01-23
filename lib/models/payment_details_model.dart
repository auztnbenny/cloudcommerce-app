import 'package:intl/intl.dart';

class PaymentDetailsModel {
  final int siNo;
  final String date;
  final String refVchNo;
  final String nature;
  final double debit;
  final double credit;
  final double balance;

  PaymentDetailsModel({
    required this.siNo,
    required this.date,
    required this.refVchNo,
    required this.nature,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  factory PaymentDetailsModel.fromAccountLedger(
      Map<String, dynamic> ledgerEntry, int index) {
    return PaymentDetailsModel(
      siNo: index + 1,
      date: _parseDate(ledgerEntry['CT_DTStr']),
      refVchNo: ledgerEntry['vchno']?.toString() ?? '',
      nature: ledgerEntry['TRANSTYPE']?.toString() ?? '',
      debit: double.tryParse(ledgerEntry['DRAMOUNT']?.toString() ?? '0') ?? 0.0,
      credit:
          double.tryParse(ledgerEntry['CRAMOUNT']?.toString() ?? '0') ?? 0.0,
      balance:
          double.tryParse(ledgerEntry['BALANCE']?.toString() ?? '0') ?? 0.0,
    );
  }

  static String _parseDate(dynamic dateStr) {
    if (dateStr == null) return '';
    try {
      if (dateStr is String && dateStr.contains('-')) return dateStr;

      final dateRegex = RegExp(r'/Date\((\d+)[+-]\d+\)/');
      final match = dateRegex.firstMatch(dateStr.toString());

      if (match != null) {
        final milliseconds = int.parse(match.group(1)!);
        final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
        return DateFormat('dd-MM-yyyy').format(date);
      }

      return dateStr.toString();
    } catch (e) {
      print('Date parsing error: $e');
      return dateStr.toString();
    }
  }
}
