import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/view/tile/recipe_tile.dart';

import '../../controller/user_controller.dart';

class RecipeListWidget extends StatelessWidget {
  final List<dynamic> listRecipe;
  const RecipeListWidget({required this.listRecipe, super.key});

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();

    return Expanded(
      child: ListView.builder(
        //controller: scrollController,
        itemCount: listRecipe.length,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: RecipeTile(
                recipe: listRecipe[index],
                isMyRecipe: userController.isMyRecipe(listRecipe[index])),
          );
        },
      ),
    );
  }
}
