import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
//import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  final bool param;
  final Function()? onPressedAdd;
  final Function()? onPressedRemove;
  const IngredientTile(
      {super.key,
      required this.ingredient,
      required this.onPressedAdd,
      required this.onPressedRemove,
      required this.param});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(1),
      elevation: 4,
      child: ListTile(
        trailing: ClipOval(
          child: param
              ? Material(
                  color: CustomTheme.thirdColor, // Button color
                  child: InkWell(
                    splashColor: Colors.redAccent, // Splash color
                    onTap: onPressedRemove,
                    child: const SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(Icons.close, color: Colors.white)),
                  ),
                )
              : Material(
                  color: Colors.green, // Button color
                  child: InkWell(
                    splashColor: Colors.greenAccent, // Splash color
                    onTap: onPressedAdd,
                    child: const SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(FontAwesomeIcons.plus,
                            size: 20, color: Colors.white)),
                  ),
                ),
        ),
        title: Text(StringUtils.capitalize(ingredient.name)),
      ),
    );
  }
}
