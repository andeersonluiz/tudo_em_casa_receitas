import 'package:extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/loader_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/app_bar_text_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/custom_drawer_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/error_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/filter_recipe_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/recipe_list_widget.dart';

class RecipeListCategoryView extends StatelessWidget {
  const RecipeListCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    bool closing = false;
    print("fuuu");
    RecipeResultController recipeResultController = Get.find();
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          closing = true;
          Get.back();

          await Future.delayed(const Duration(milliseconds: 200));
          recipeResultController.clearlistFilters();
          recipeResultController.clearListCategory();
          return true;
        },
        child: Scaffold(
          appBar: AppBarWithText(
            text: Get.arguments["category"] == ""
                ? "Principais Receitas"
                : "Receitas de ${Get.arguments["category"].toString().toLowerCase().capitalizeFirstLetter()}",
            showDrawer: false,
            onPressed: () async {
              closing = true;
              Get.back();

              await Future.delayed(const Duration(milliseconds: 200));
              recipeResultController.clearlistFilters();
              recipeResultController.clearListCategory();
            },
          ),
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: FilterRecipeWidget(listType: ListType.CategoryPage),
              ),
              Obx(() {
                if (recipeResultController.listRecipesCategory.isEmpty &&
                    recipeResultController.statusRecipesCategory.value ==
                        StatusRecipeCategory.None &&
                    Get.arguments != null &&
                    !closing) {
                  recipeResultController
                      .getRecipeByTag(Get.arguments["category"]);
                }
                if (recipeResultController.listRecipesCategory.isNotEmpty &&
                        recipeResultController.statusRecipesCategory.value ==
                            StatusRecipeCategory.Finished ||
                    Get.arguments == null) {
                  return RecipeListWidget(
                      listRecipe: recipeResultController.listRecipesCategory);
                } else if (recipeResultController.statusRecipesCategory.value ==
                    StatusRecipeCategory.Error) {
                  return Expanded(
                      child: CustomErrorWidget(
                    "Erro ao carregar receitas, verifique sua conexão",
                    onRefresh: () async {
                      await recipeResultController.getAllRecipes();
                    },
                  ));
                } else {
                  return const Expanded(
                      child: LoaderTile(
                    size: GFSize.LARGE,
                  ));
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
