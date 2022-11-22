class ItemType {
  String? category;
  String? item;
  int? shippingFee;
  int? pickupFee;
  int? quantity;

  ItemType(
      {this.category,
      this.item,
      this.shippingFee,
      this.pickupFee,
      this.quantity});

  ItemType.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    item = json['item'];
    shippingFee = json['shipping_fee'];
    pickupFee = json['pickup_fee'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['item'] = this.item;
    data['shipping_fee'] = this.shippingFee;
    data['pickup_fee'] = this.pickupFee;
    data['quantity'] = this.quantity;
    return data;
  }
}
