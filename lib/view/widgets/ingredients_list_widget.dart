import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/home_view_controller.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/view/tile/ingredient_tile.dart';

class IngredientListWidget extends StatelessWidget {
  final List<dynamic> listIngredients;
  final bool isPantry;
  const IngredientListWidget(
      {required this.listIngredients, required this.isPantry, super.key});

  @override
  Widget build(BuildContext context) {
    IngredientController ingredientController = Get.find();
    HomeViewController homeViewController = Get.find();
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: ListView.builder(
          itemCount: listIngredients.length,
          itemBuilder: (_, index) {
            Ingredient ingredient = listIngredients[index] as Ingredient;
            if (isPantry && ingredient.isHome) {
              return Container();
            }
            return IngredientTile(
                ingredient: ingredient,
                param: isPantry ? ingredient.isPantry : ingredient.isHome,
                onPressedAdd: () {
                  isPantry
                      ? ingredientController.addIngredientPantry(ingredient)
                      : ingredientController
                          .addIngredientHomePantry(ingredient);
                },
                onPressedRemove: () {
                  isPantry
                      ? ingredientController.removeIngredientPantry(ingredient)
                      : ingredientController
                          .removeIngredientHomePantry(ingredient);
                  homeViewController.updateToogleValue(
                      !ingredientController.verifyMinIngredients());
                });
          }),
    );
  }
}
