import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/home_view_controller.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/widgets/custom_toggle_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/error_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/recipe_list_home_view_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeViewController homeViewController = Get.find();
    RecipeResultController recipeResultController = Get.find();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: CustomToggle(),
        ),
        Obx(() {
          if (homeViewController.toggleValue.value) {
            if (recipeResultController.listRecipesHomePage.isNotEmpty &&
                recipeResultController.statusRecipesHome.value ==
                    StatusHomePage.Finished) {
              return RecipeListHomeViewWidget(
                  listRecipes: recipeResultController.listRecipesHomePage);
            } else if (recipeResultController.statusRecipesHome.value ==
                StatusHomePage.Error) {
              return Expanded(
                  child: CustomErrorWidget(
                "Erro ao carregar receitas, verifique sua conexão",
                onRefresh: () async {
                  await recipeResultController.getRecipesHomeView();
                },
              ));
            } else {
              return const Expanded(
                  child: GFLoader(
                size: GFSize.LARGE,
                androidLoaderColor:
                    AlwaysStoppedAnimation<Color>(CustomTheme.thirdColor),
              ));
            }
          } else {
            if (recipeResultController.listRecipesPantryPage.isNotEmpty &&
                recipeResultController.statusRecipesHome.value ==
                    StatusHomePage.Finished) {
              return RecipeListHomeViewWidget(
                  listRecipes: recipeResultController.listRecipesPantryPage);
            } else if (recipeResultController.listRecipesPantryPage.isEmpty &&
                recipeResultController.statusRecipesHome.value ==
                    StatusHomePage.Finished) {
              return const Expanded(
                child: Center(
                  child: Text(
                    "Nao há receitas com base nos seus ingredientes :(",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontFamily: 'CostaneraAltBook', fontSize: 20),
                  ),
                ),
              );
            } else if (recipeResultController.statusRecipesHome.value ==
                StatusHomePage.Error) {
              return Expanded(
                  child: CustomErrorWidget(
                "Erro ao carregar receitas, verifique sua conexão",
                onRefresh: () async {
                  await recipeResultController.getRecipesPantryView();
                },
              ));
            } else {
              return const Expanded(
                  child: GFLoader(
                size: GFSize.LARGE,
                androidLoaderColor:
                    AlwaysStoppedAnimation<Color>(CustomTheme.thirdColor),
              ));
            }
          }
        })
      ],
    );
  }
}
