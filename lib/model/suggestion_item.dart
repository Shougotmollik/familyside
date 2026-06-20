import 'package:familyside/view/family/profile/widgets/suggestion_card.dart';

class SuggestionItem {
  final int id;
  final String name;
  final String description;
  final String location;
  final String status;
  final String category;

  SuggestionItem({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.status,
    required this.category,
  });

  factory SuggestionItem.fromJson(Map<String, dynamic> json) {
    return SuggestionItem(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      status: json['status'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }

  SuggestionStatus get suggestionStatus {
    return status.toLowerCase() == 'approved'
        ? SuggestionStatus.approved
        : SuggestionStatus.pending;
  }
}
