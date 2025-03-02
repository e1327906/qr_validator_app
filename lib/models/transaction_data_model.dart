class TransactionData {
  final String paymentRefNo;
  final double amount;
  final String currency;

  TransactionData({
    required this.paymentRefNo,
    required this.amount,
    required this.currency,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      paymentRefNo: json['paymentRefNo'],
      // Handle potential integer values by converting to double
      amount: json['amount'] is int ? (json['amount'] as int).toDouble() : json['amount'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentRefNo': paymentRefNo,
      'amount': amount,
      'currency': currency,
    };
  }

  TransactionData copyWith({
    String? paymentRefNo,
    double? amount,
    String? currency,
  }) {
    return TransactionData(
      paymentRefNo: paymentRefNo ?? this.paymentRefNo,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
    );
  }
}