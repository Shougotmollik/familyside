class GiftListModel {
  final String id;
  final String name;
  final String occasion;

  const GiftListModel({
    required this.id,
    required this.name,
    required this.occasion,
  });
}

class CreateNewListResult {
  final String name;
  final String occasion;

  const CreateNewListResult({
    required this.name,
    required this.occasion,
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
