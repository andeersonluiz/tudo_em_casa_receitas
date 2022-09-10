class Info {
  final int yieldRecipe;

  final int preparationTime;

  Info({required this.yieldRecipe, required this.preparationTime});

  factory Info.fromJson(Map<String, dynamic> json) => Info(
      yieldRecipe: json['yield'], preparationTime: json['preparation_time']);

  toJson() => {"yield": yieldRecipe, "preparation_time": preparationTime};
}
