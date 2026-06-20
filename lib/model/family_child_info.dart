class FamilyChildInfoData {
  final String locationName;
  final bool isExpecting;
  final String? expectedDueDate;
  final List<FamilyKid> kids;

  FamilyChildInfoData({
    required this.locationName,
    required this.isExpecting,
    this.expectedDueDate,
    required this.kids,
  });

  factory FamilyChildInfoData.fromJson(Map<String, dynamic> json) {
    return FamilyChildInfoData(
      locationName: json['location_name'] as String? ?? '',
      isExpecting: json['is_expecting'] as bool? ?? false,
      expectedDueDate: json['expected_due_date'] as String?,
      kids: (json['kids'] as List<dynamic>?)
              ?.map((e) => FamilyKid.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class FamilyKid {
  final int? id;
  final String name;
  final String? dob;
  final String? gender;

  FamilyKid({
    this.id,
    required this.name,
    this.dob,
    this.gender,
  });

  factory FamilyKid.fromJson(Map<String, dynamic> json) {
    return FamilyKid(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      dob: json['dob'] as String?,
      gender: json['gender'] as String?,
    );
  }
}
