class ListTransactionModel {
  ListTransactionModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Transaction> data;

  ListTransactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? List.from(json['data']).map((e) => Transaction.fromJson(e)).toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Transaction {
  Transaction({
    required this.id,
    required this.bookingType,
    required this.transactionId,
    required this.cardType,
    required this.totalAmount,
    required this.createdAt,
  });
  late final int id;
  late final String bookingType;
  late final String transactionId;
  late final String cardType;
  late final String totalAmount;
  late final String createdAt;

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingType = json['booking_type'];
    transactionId = json['transaction_id'];
    cardType = json['card_type'];
    totalAmount = json['total_amount'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['booking_type'] = bookingType;
    _data['transaction_id'] = transactionId;
    _data['card_type'] = cardType;
    _data['total_amount'] = totalAmount;
    _data['created_at'] = createdAt;
    return _data;
  }
}
// ==================================//=================================

class MarketPlaceListTransaction {
  MarketPlaceListTransaction({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<MktListTransactionData> data;

  MarketPlaceListTransaction.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data'])
        .map((e) => MktListTransactionData.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class MktListTransactionData {
  MktListTransactionData({
    required this.mid,
    this.transactionId,
    this.cardType,
    this.totalAmount,
    required this.createdAt,
  });
  late final int mid;
  late final String? transactionId;
  late final String? cardType;
  late final int? totalAmount;
  late final String createdAt;

  MktListTransactionData.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    transactionId =
        json['transaction_id'] == null ? "" : json['transaction_id'];

    cardType = json['card_type'] == null ? "" : json['card_type'];
    totalAmount = json['total_amount'] == null ? 0 : json['total_amount'];
    createdAt = json['created_at'] == null ? "" : json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['mid'] = mid;
    _data['transaction_id'] = transactionId;
    _data['card_type'] = cardType;
    _data['total_amount'] = totalAmount;
    _data['created_at'] = createdAt;
    return _data;
  }
}
