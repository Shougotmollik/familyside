class FilterResultModel {
  final String location;
  final List<String> categories;
  final List<String> ages;
  final String price;

  FilterResultModel({
    required this.location,
    required this.categories,
    required this.ages,
    required this.price,
  });

  @override
  String toString() {
    return 'FilterResultModel(location: $location, categories: $categories, ages: $ages, price: $price)';
  }
}
