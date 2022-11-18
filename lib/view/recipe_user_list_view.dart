import 'package:extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';
import 'package:tudo_em_casa_receitas/model/user_model.dart';
import 'package:tudo_em_casa_receitas/view/tile/loader_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/app_bar_text_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/error_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/filter_recipe_widget.dart';

import 'widgets/recipe_list_widget.dart';

class RecipeUserListView extends StatelessWidget {
  const RecipeUserListView({super.key});
  @override
  Widget build(BuildContext context) {
    bool closing = false;
    RecipeResultController recipeResultController = Get.find();
    UserModel user = UserModel.fromJson(Get.arguments["user"]);
    return WillPopScope(
      onWillPop: () async {
        closing = true;
        Get.back();

        await Future.delayed(const Duration(milliseconds: 200));
        recipeResultController.clearlistFilters();
        recipeResultController.clearListRecipeUser();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBarWithText(
            text:
                "Receitas de ${user.name.toString().toLowerCase().capitalizeFirstLetter()}",
            showDrawer: false,
            onPressed: () async {
              closing = true;
              Get.back();

              await Future.delayed(const Duration(milliseconds: 200));
              recipeResultController.clearlistFilters();
              recipeResultController.clearListRecipeUser();
            },
          ),
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: FilterRecipeWidget(listType: ListType.RecipeUser),
              ),
              Obx(() {
                if (recipeResultController.listRecipesUser.isEmpty &&
                    recipeResultController.statusRecipesResult.value ==
                        StatusRecipeResult.None &&
                    Get.arguments != null &&
                    !closing) {
                  recipeResultController.getRecipesByUser(user);
                }
                if (recipeResultController.listRecipesUser.isNotEmpty &&
                        recipeResultController.statusRecipesResult.value ==
                            StatusRecipeResult.Finished ||
                    Get.arguments == null) {
                  return RecipeListWidget(
                      listRecipe: recipeResultController.listRecipesUser);
                } else if (recipeResultController.statusRecipesResult.value ==
                    StatusRecipeResult.Error) {
                  return Expanded(
                      child: CustomErrorWidget(
                    "Erro ao carregar receitas, verifique sua conexão",
                    onRefresh: () async {
                      await recipeResultController.getRecipesByUser(user);
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
