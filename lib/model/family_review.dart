class FamilyReview {
  final int id;
  final String placeName;
  final String date;
  final String comment;
  final String recommendationLabel;

  FamilyReview({
    required this.id,
    required this.placeName,
    required this.date,
    required this.comment,
    required this.recommendationLabel,
  });

  factory FamilyReview.fromJson(Map<String, dynamic> json) {
    return FamilyReview(
      id: json['id'] as int? ?? 0,
      placeName: json['place_name'] as String? ?? '',
      date: json['date'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      recommendationLabel: json['recommendation_label'] as String? ?? '',
    );
  }
}
