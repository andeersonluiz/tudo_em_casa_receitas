import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/view/tile/loader_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/app_bar_text_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/custom_drawer_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/error_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/filter_recipe_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/recipe_list_widget.dart';

import '../controller/recipe_controller.dart';

class RecipeListAllResults extends StatelessWidget {
  const RecipeListAllResults({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMatched = Get.arguments["isMatched"];

    RecipeResultController recipeResultController = Get.find();
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Get.back();
          await Future.delayed(const Duration(milliseconds: 200));
          recipeResultController.clearlistFilters();
          return true;
        },
        child: Scaffold(
          endDrawer: CustomDrawerWidget(),
          drawerEdgeDragWidth: 0,
          appBar: AppBarWithText(
            text: isMatched
                ? "Receitas Encontradas"
                : "Falta apenas um ingrediente",
            onPressed: () async {
              Get.back();
              await Future.delayed(const Duration(milliseconds: 200));
              recipeResultController.clearlistFilters();
            },
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: FilterRecipeWidget(
                    listType: isMatched
                        ? ListType.RecipeResultMatched
                        : ListType.RecipeResultMissingOne),
              ),
              Obx(() {
                if (isMatched) {
                  if (recipeResultController
                              .listRecipesResultMatched.isNotEmpty &&
                          recipeResultController.statusRecipesResult.value ==
                              StatusRecipeResult.Finished ||
                      Get.arguments == null) {
                    return RecipeListWidget(
                        listRecipe:
                            recipeResultController.listRecipesResultMatched);
                  } else if (recipeResultController.statusRecipesResult.value ==
                      StatusRecipeResult.Error) {
                    return Expanded(
                        child: CustomErrorWidget(
                      "Erro ao carregar receitas, verifique sua conexão",
                      onRefresh: () async {
                        await recipeResultController.getRecipesResults();
                      },
                    ));
                  } else {
                    return const Expanded(
                        child: LoaderTile(
                      size: GFSize.LARGE,
                    ));
                  }
                } else {
                  if (recipeResultController
                              .listRecipesResultMissingOne.isNotEmpty &&
                          recipeResultController.statusRecipesResult.value ==
                              StatusRecipeResult.Finished ||
                      Get.arguments == null) {
                    return RecipeListWidget(
                        listRecipe:
                            recipeResultController.listRecipesResultMissingOne);
                  } else if (recipeResultController.statusRecipesResult.value ==
                      StatusRecipeResult.Error) {
                    return Expanded(
                        child: CustomErrorWidget(
                      "Erro ao carregar receitas, verifique sua conexão",
                      onRefresh: () async {
                        await recipeResultController.getRecipesResults();
                      },
                    ));
                  } else {
                    return const Expanded(
                        child: LoaderTile(
                      size: GFSize.LARGE,
                    ));
                  }
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
