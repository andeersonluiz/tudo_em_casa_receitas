import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/widgets/app_bar_text_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/custom_drawer_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/error_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/my_recipes_widget.dart';

class MyRecipesView extends StatelessWidget {
  MyRecipesView({super.key});
  final UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    print("faass");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userController.statusMyRecipes.value == StatusMyRecipes.Finished) {
        userController.wipeMyRecipes();
      }
    });

    return Scaffold(
      endDrawer: CustomDrawerWidget(),
      appBar: AppBarWithText(
          text: "Minhas Receitas",
          onPressed: () {
            Navigator.of(context).pop();
            userController.updateIndexSelected(0);
          }),
      body: Obx(() {
        if (userController.myRecipes.isEmpty &&
            userController.statusMyRecipes.value == StatusMyRecipes.None) {
          Future.delayed(Duration.zero, () {
            userController.getMyRecipes();
            userController.updateIndexSelected(1);
          });
        }
        if (userController.statusMyRecipes.value == StatusMyRecipes.Finished) {
          return MyRecipesListWidget(
              listRecipes: List<Recipe>.from(userController.myRecipes));
        } else if (userController.statusMyRecipes.value ==
            StatusMyRecipes.Error) {
          return Center(
            child: CustomErrorWidget(
              "Erro ao carregar receitas, verifique sua conexão",
              onRefresh: () async {
                await userController.getMyRecipes();
              },
            ),
          );
        } else {
          return const Center(
            child: GFLoader(
              size: GFSize.LARGE,
              androidLoaderColor:
                  AlwaysStoppedAnimation<Color>(CustomTheme.thirdColor),
            ),
          );
        }
      }),
    );
  }
}
