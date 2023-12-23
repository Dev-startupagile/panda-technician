import 'dart:convert';

class ChargeTransaction {
  final String object;
  final int amount;
  String get amountFormated =>
      "${(amount / 100).toStringAsFixed(2)} ${currency.toUpperCase()}";
  final int amountCaptured;
  final int amountRefunded;
  final String application;
  final String applicationFee;
  final double applicationFeeAmount;
  final String balanceTransaction;
  final String currency;
  final String receiptUrl;
  final bool captured;
  final bool refunded;
  final String sourceTransfer;
  final String status;
  final DateTime created;
  String get createdFormated => created.toIso8601String();

  ChargeTransaction(
      {required this.object,
      required this.amount,
      required this.amountCaptured,
      required this.amountRefunded,
      required this.application,
      required this.applicationFee,
      required this.applicationFeeAmount,
      required this.balanceTransaction,
      required this.currency,
      required this.receiptUrl,
      required this.captured,
      required this.refunded,
      required this.sourceTransfer,
      required this.status,
      required this.created});

  Map<String, dynamic> toMap() {
    return {
      'object': object,
      'amount': amount,
      'amount_captured': amountCaptured,
      'amount_refunded': amountRefunded,
      'application': application,
      'application_fee': applicationFee,
      'application_fee_amount': applicationFeeAmount,
      'balance_transaction': balanceTransaction,
      'currency': currency,
      'receipt_url': receiptUrl,
      'captured': captured,
      'refunded': refunded,
      'source_transfer': sourceTransfer,
      'status': status,
      'created': created.millisecondsSinceEpoch,
    };
  }

  factory ChargeTransaction.fromMap(Map<String, dynamic> map) {
    return ChargeTransaction(
      object: map['object'] ?? '',
      amount: map['amount']?.toInt() ?? 0,
      amountCaptured: map['amount_captured']?.toInt() ?? 0,
      amountRefunded: map['amount_refunded']?.toInt() ?? 0,
      application: map['application'] ?? '',
      applicationFee: map['application_fee'] ?? '',
      applicationFeeAmount: (map['application_fee_amount']) / 100 ?? 0,
      balanceTransaction: map['balance_transaction'] ?? '',
      currency: map['currency'] ?? '',
      receiptUrl: map['receipt_url'] ?? '',
      captured: map['captured'] ?? false,
      refunded: map['refunded'] ?? false,
      sourceTransfer: map['source_transfer'] ?? '',
      status: map['status'] ?? '',
      created: DateTime.fromMillisecondsSinceEpoch(map['created']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChargeTransaction.fromJson(String source) =>
      ChargeTransaction.fromMap(json.decode(source));
}
