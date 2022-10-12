import 'package:extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/view/tile/card_recipe_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/card_recipe_trend_tile.dart';

class RecipeListHomeViewWidget extends StatelessWidget {
  final List<dynamic> listRecipes;
  const RecipeListHomeViewWidget({required this.listRecipes, super.key});

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();

    RecipeResultController recipeResultController = Get.find();
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: listRecipes.length,
        itemBuilder: (ctx, index) {
          var tupleRecipe = listRecipes[index];
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Row(
                  children: [
                    Text(
                        tupleRecipe[0] == ""
                            ? "Principais Receitas"
                            : tupleRecipe[0]
                                .toString()
                                .toLowerCase()
                                .capitalizeFirstLetter(),
                        style: const TextStyle(
                            fontFamily: "CostaneraAltBook", fontSize: 18)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        recipeResultController.clearlistFilters();
                        await Get.toNamed(Routes.RECIPE_CATEGORY,
                            arguments: {"category": tupleRecipe[0]});
                      },
                      child: const Text("Ver Tudo",
                          style: TextStyle(
                              fontFamily: "CostaneraAltBook",
                              fontSize: 14,
                              color: Colors.red)),
                    )
                  ],
                ),
              ),
              Container(
                height: tupleRecipe[0] == "" ? 235 : 170,
                padding: const EdgeInsets.only(left: 8.0),
                child: ListView.builder(
                  itemCount: tupleRecipe[1].length,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    if (tupleRecipe[0] == "") {
                      return CardRecipeTrendTile(tupleRecipe[1][index],
                          userController.isMyRecipe(tupleRecipe[1][index]));
                    } else {
                      return CardRecipeTile(tupleRecipe[1][index],
                          userController.isMyRecipe(tupleRecipe[1][index]));
                    }
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
