class Ingredient {
  final String searchValue;
  bool isSelected;
  int order;
  Ingredient(
      {required this.searchValue,
      required this.isSelected,
      required this.order});

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      Ingredient(searchValue: json['searchValue'], isSelected: false, order: 0);

  toJson() => {
        "searchValue": searchValue,
      };
}
