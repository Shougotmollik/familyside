class GiftFilterResultModel {
  final String? recipient;
  final String? forWhom;
  final String? childAge;
  final String? price;

  const GiftFilterResultModel({
    this.recipient,
    this.forWhom,
    this.childAge,
    this.price,
  });

  bool get hasAnyFilter =>
      recipient != null ||
      forWhom != null ||
      childAge != null ||
      price != null;

  @override
  String toString() {
    return 'GiftFilterResultModel(recipient: $recipient, forWhom: $forWhom, '
        'childAge: $childAge, price: $price)';
  }
}
