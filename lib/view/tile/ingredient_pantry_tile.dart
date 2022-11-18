import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';

class IngredientPantryTile extends StatelessWidget {
  final Ingredient ingredient;
  final Function() onPressDelete;
  const IngredientPantryTile(
      {super.key, required this.ingredient, required this.onPressDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        trailing: IconButton(
            splashColor: Colors.transparent,
            onPressed: onPressDelete,
            icon: const Icon(Icons.close),
            color: Theme.of(context).secondaryHeaderColor),
        title: Text(StringUtils.capitalize(ingredient.name)),
      ),
    );
  }
}
