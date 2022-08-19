import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
//import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  final bool isSearch;
  const IngredientTile(
      {super.key, required this.ingredient, required this.isSearch});

  @override
  Widget build(BuildContext context) {
    IngredientController ingredientController = Get.find();

    return isSearch
        ? Card(
            margin: EdgeInsets.zero,
            elevation: 8.0,
            child: GFListTile(
              titleText: StringUtils.capitalize(ingredient.searchValue),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              icon: ingredient.isSelected
                  ? IconButton(
                      onPressed: () {
                        ingredientController.updateIsSelected(ingredient);
                        //FocusManager.instance.primaryFocus?.unfocus();
                        GFToast.showToast(
                          "${StringUtils.capitalize(ingredient.searchValue)} removido",
                          context,
                          toastPosition: GFToastPosition.BOTTOM,
                          textStyle: CustomTheme.data.textTheme.caption!
                              .copyWith(color: Colors.white, fontSize: 14),
                          backgroundColor:
                              const Color.fromARGB(255, 114, 114, 114),
                        );
                      },
                      icon: const Icon(
                        Ionicons.trash,
                        color: CustomTheme.thirdColor,
                      ))
                  : IconButton(
                      onPressed: () {
                        ingredientController.updateIsSelected(ingredient);
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      icon: const Icon(
                        Ionicons.add_circle,
                        color: Color.fromARGB(255, 84, 128, 85),
                      )),
            ),
          )
        : GFListTile(
            titleText: StringUtils.capitalize(ingredient.searchValue),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            icon: ingredient.isSelected
                ? IconButton(
                    onPressed: () {
                      ingredientController.updateIsSelected(ingredient);
                      FocusManager.instance.primaryFocus?.unfocus();
                      GFToast.showToast(
                        "${StringUtils.capitalize(ingredient.searchValue)} removido",
                        context,
                        toastPosition: GFToastPosition.BOTTOM,
                        textStyle: CustomTheme.data.textTheme.caption!
                            .copyWith(color: Colors.white, fontSize: 14),
                        backgroundColor:
                            const Color.fromARGB(255, 114, 114, 114),
                      );
                    },
                    icon: const Icon(
                      Ionicons.trash,
                      color: CustomTheme.thirdColor,
                    ))
                : IconButton(
                    onPressed: () {
                      ingredientController.updateIsSelected(ingredient);
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    icon: const Icon(
                      Ionicons.add_circle,
                      color: Color.fromARGB(255, 84, 128, 85),
                    )),
          );
  }
}
