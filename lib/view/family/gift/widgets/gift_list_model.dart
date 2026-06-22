class GiftListModel {
  final String id;
  final String name;
  final String occasion;
  final String? imagePath;

  const GiftListModel({
    required this.id,
    required this.name,
    required this.occasion,
    this.imagePath,
  });
}

class CreateNewListResult {
  final String? id;
  final String name;
  final String occasion;
  final String? imagePath;

  const CreateNewListResult({
    this.id,
    required this.name,
    required this.occasion,
    this.imagePath,
  });
}

class AddToGiftListResult {
  final GiftListModel list;
  final String giftItemTitle;

  const AddToGiftListResult({
    required this.list,
    required this.giftItemTitle,
  });
}
