// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/recipeResult_controller.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/widgets/error_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/recipe_widget.dart';

class RecipeResultView extends StatelessWidget {
  const RecipeResultView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RecipeResultController recipeResultController = Get.find();

    //EasyLoading.dismiss();
    return Scaffold(
      appBar: GFAppBar(
        title: const Text(
          "LOGO_APP",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: CustomTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Obx(() {
        if (recipeResultController.listRecipes.isEmpty &&
            recipeResultController.status.value == Status.Finished) {
          //Buscou e nao encontrou receitas
          return const Center(
              child: CustomErrorWidget("Não há receitas para sua pesquisa"));
        } else if (recipeResultController.status.value == Status.Error) {
          return const Center(
            child:
                CustomErrorWidget("Erro ao carregar receitas, tente novamente"),
          );
        } else if (recipeResultController.status.value == Status.Finished) {
          return RecipeWidget(listRecipes: recipeResultController.listRecipes);
        } else {
          return const GFLoader(
              androidLoaderColor:
                  AlwaysStoppedAnimation<Color>(CustomTheme.thirdColor));
        }
      }),
    );
  }
}
