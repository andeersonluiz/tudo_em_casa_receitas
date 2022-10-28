class PreparationItem {
  String id;
  final String description;
  bool isSubtopic;
  bool isChecked;
  PreparationItem({
    this.id = "",
    required this.description,
    this.isChecked = false,
    required this.isSubtopic,
  });
  factory PreparationItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return PreparationItem(
      description: json['description'],
      isSubtopic: json['isSubtopic'],
    );
  }
  toJson() {
    return {
      "description": description,
      "isSubtopic": isSubtopic,
    };
  }

  @override
  String toString() {
    return "$id $description";
  }
}
