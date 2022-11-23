import 'package:equatable/equatable.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';

// ignore: must_be_immutable
class Categorie extends Equatable {
  final String id;
  final String name;
  bool isSelected;
  int order;
  bool isRevision;
  String userId;
  bool hasError;
  Categorie({
    required this.id,
    required this.name,
    this.isSelected = false,
    this.order = 0,
    this.isRevision = false,
    this.hasError = false,
    this.userId = "",
  });

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json['name']
          .toString()
          .toLowerCase()
          .toTitleCase()
          .replaceAll(" ", ""),
      name: json['name'],
      userId: json['userId'] ??= "",
    );
  }

  toJson() => {"name": name, "userId": userId};

  @override
  String toString() {
    return "$name $isRevision $hasError";
  }

  static Categorie emptyClass() => Categorie(id: "", name: "");

  @override
  List<Object> get props => [
        id,
        name,
        isSelected,
        order,
        isRevision,
        hasError,
        userId,
      ];
}
