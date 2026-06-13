class Child {
  final String name;
  final String dob;
  final String gender;

  Child({required this.name, required this.dob, required this.gender});

  Map<String, dynamic> toJson() {
    return {"name": name, "dob": dob, "gender": gender};
  }
}

class ChildInfo {
  final bool isExpecting;
  final List<Child> children;
  final String? expectedDueDate;

  ChildInfo({
    required this.isExpecting,
    required this.children,
    this.expectedDueDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "is_expecting": expectedDueDate != null ? true : false,
      "children": children.map((e) => e.toJson()).toList(),
      "expected_due_date": expectedDueDate,
    };
  }
}
