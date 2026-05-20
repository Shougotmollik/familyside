import 'package:flutter_riverpod/legacy.dart';

class ChildModel {
  String name;
  DateTime? dob;
  String? gender;

  ChildModel({this.name = '', this.dob, this.gender});

  ChildModel copyWith({String? name, DateTime? dob, String? gender}) {
    return ChildModel(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'dob': dob?.toIso8601String(), 'gender': gender};

  bool get isEmpty => name.isEmpty && dob == null && gender == null;
}

class ChildInfoState {
  final bool isExpecting;
  final DateTime? selectedDueDate;
  final List<ChildModel> kids;
  final bool showForm;
  final int? editingKidIndex;

  ChildInfoState({
    this.isExpecting = true,
    this.selectedDueDate,
    this.kids = const [],
    this.showForm = false,
    this.editingKidIndex,
  });

  ChildInfoState copyWith({
    bool? isExpecting,
    DateTime? selectedDueDate,
    List<ChildModel>? kids,
    bool? showForm,
    int? editingKidIndex,
    bool clearDueDate = false,
    bool clearEditing = false,
  }) {
    return ChildInfoState(
      isExpecting: isExpecting ?? this.isExpecting,
      selectedDueDate: clearDueDate ? null : (selectedDueDate ?? this.selectedDueDate),
      kids: kids ?? this.kids,
      showForm: clearEditing ? false : (showForm ?? this.showForm),
      editingKidIndex: clearEditing ? null : (editingKidIndex ?? this.editingKidIndex),
    );
  }
}

class ChildInfoNotifier extends StateNotifier<ChildInfoState> {
  ChildInfoNotifier() : super(ChildInfoState());

  void setIsExpecting(bool value) {
    state = state.copyWith(isExpecting: value, showForm: false, editingKidIndex: null);
  }

  void setDueDate(DateTime date) {
    state = state.copyWith(selectedDueDate: date);
  }

  void clearDueDate() {
    state = state.copyWith(clearDueDate: true);
  }

  void openAddForm() {
    state = state.copyWith(showForm: true, editingKidIndex: null);
  }

  void openEditForm(int index) {
    if (index >= 0 && index < state.kids.length) {
      state = state.copyWith(showForm: true, editingKidIndex: index);
    }
  }

  void closeForm() {
    state = state.copyWith(clearEditing: true);
  }

  void saveKid({required String name, DateTime? dob, String? gender}) {
    final newKids = List<ChildModel>.from(state.kids);
    
    if (state.editingKidIndex != null && state.editingKidIndex! < newKids.length) {
      newKids[state.editingKidIndex!] = ChildModel(name: name, dob: dob, gender: gender);
    } else {
      newKids.add(ChildModel(name: name, dob: dob, gender: gender));
    }
    
    state = state.copyWith(kids: newKids, showForm: false, editingKidIndex: null);
  }

  void removeKid(int index) {
    if (index >= 0 && index < state.kids.length) {
      final newKids = List<ChildModel>.from(state.kids)..removeAt(index);
      
      int? newEditingIndex = state.editingKidIndex;
      if (state.editingKidIndex == index) {
        newEditingIndex = null;
        state = state.copyWith(showForm: false);
      }
      
      state = state.copyWith(kids: newKids, editingKidIndex: newEditingIndex);
    }
  }

  ChildModel? getEditingKid() {
    if (state.editingKidIndex != null && state.editingKidIndex! < state.kids.length) {
      return state.kids[state.editingKidIndex!];
    }
    return null;
  }

  void reset() {
    state = ChildInfoState();
  }
}

final childInfoProvider = StateNotifierProvider<ChildInfoNotifier, ChildInfoState>((ref) {
  return ChildInfoNotifier();
});