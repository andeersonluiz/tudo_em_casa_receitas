class Info {
  final String yield;
  final String preparationTime;

  Info({required this.yield, required this.preparationTime});

  factory Info.fromJson(Map<String, dynamic> json) =>
      Info(yield: json['yield'], preparationTime: json['preparation_time']);

  toJson() => {"yield": yield, "preparation_time": preparationTime};
}
