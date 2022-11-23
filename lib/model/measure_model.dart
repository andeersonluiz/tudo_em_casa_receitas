import 'package:equatable/equatable.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';

// ignore: must_be_immutable
class Measure extends Equatable {
  final String id;
  final String name;
  final String plural;
  int order;
  bool isRevision;
  bool hasError;
  String userId;
  Measure({
    required this.id,
    required this.name,
    required this.plural,
    this.isRevision = false,
    this.hasError = false,
    this.order = 0,
    this.userId = "",
  });

  factory Measure.fromJson(Map<String, dynamic> json) => Measure(
      id: json['name']
              .toString()
              .toLowerCase()
              .toTitleCase()
              .replaceAll(" ", "") +
          json['plural']
              .toString()
              .toLowerCase()
              .toTitleCase()
              .replaceAll(" ", ""),
      name: json['name'],
      plural: json['plural'],
      userId: json['userId'] ??= "");

  toJson() => {
        'name': name,
        'plural': plural,
        "userId": userId,
      };

  static Measure copyWith(Measure measure) {
    return Measure(
        id: measure.id,
        name: measure.name,
        plural: measure.plural,
        order: measure.order,
        isRevision: measure.isRevision,
        hasError: measure.hasError,
        userId: measure.userId);
  }

  @override
  String toString() {
    return "'name': $name, 'plural': $plural, 'userId': $userId , 'isRevision' :$isRevision 'hasError' $hasError";
  }

  static Measure emptyClass() {
    return Measure(id: "", name: "", plural: "");
  }

  @override
  List<Object> get props => [
        id,
        name,
        plural,
        order,
        isRevision,
        hasError,
        userId,
      ];
}
