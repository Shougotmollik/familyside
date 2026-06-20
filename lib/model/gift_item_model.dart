class GiftItemModel {
  final int id;
  final String imagePath;
  final String title;
  final String price;
  final String description;
  final String location;

  const GiftItemModel({
    this.id = 0,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.description,
    required this.location,
  });
}
