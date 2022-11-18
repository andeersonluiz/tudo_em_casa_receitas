import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/view/tile/loader_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/error_widget.dart';

import 'widgets/app_bar_text_widget.dart';
import 'widgets/custom_drawer_widget.dart';
import 'widgets/recipe_list_widget.dart';

class FavoriteView extends StatelessWidget {
  FavoriteView({super.key});
  final UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userController.statusMyFavorites.value == StatusMyRecipes.Finished) {
        userController.wipeMyRecipesFavorites();
      }
    });

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        userController.updateIndexSelected(0);
        return Future.delayed(Duration.zero, () => true);
      },
      child: SafeArea(
        child: Scaffold(
          endDrawer: CustomDrawerWidget(),
          appBar: AppBarWithText(
              text: "Meus Favoritos",
              onPressed: () {
                Navigator.of(context).pop();
                userController.updateIndexSelected(0);
              }),
          body: Column(
            children: [
              Obx(() {
                if (userController.favoriteRecipes.isEmpty &&
                    userController.statusMyFavorites.value ==
                        StatusMyRecipes.None) {
                  Future.delayed(Duration.zero, () {
                    userController.getFavoritesRecipes();
                    userController.updateIndexSelected(3);
                  });
                }
                if (userController.statusMyFavorites.value ==
                    StatusMyRecipes.Finished) {
                  return RecipeListWidget(
                    listRecipe:
                        List<Recipe>.from(userController.favoriteRecipes),
                  );
                } else if (userController.statusMyFavorites.value ==
                    StatusMyRecipes.Error) {
                  return Center(
                    child: CustomErrorWidget(
                      "Erro ao carregar receitas, verifique sua conexão",
                      onRefresh: () async {
                        await userController.getFavoritesRecipes();
                      },
                    ),
                  );
                } else {
                  return const Expanded(
                      child: LoaderTile(
                    size: GFSize.LARGE,
                  ));
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
