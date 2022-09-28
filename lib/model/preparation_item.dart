import 'package:tudo_em_casa_receitas/model/measure_model.dart';

class PreparationItem {
  String id;
  final String description;
  bool isSubtopic;
  PreparationItem({
    this.id = "",
    required this.description,
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
    print("fuuu");
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
