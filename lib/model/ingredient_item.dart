import 'package:tudo_em_casa_receitas/model/measure_model.dart';

class IngredientItem {
  final String name;
  final String format;
  final bool isOptional;
  final int qtd;
  final Measure measure;

  IngredientItem(
      {required this.name,
      required this.format,
      required this.isOptional,
      required this.measure,
      required this.qtd});

  @override
  String toString() {
    return "$qtd ${qtd > 1 ? measure.plural : measure.name} de $name $format";
  }
}
