import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/view/tile/my_recipe_card_tile.dart';

class MyRecipesListWidget extends StatelessWidget {
  final List<Recipe> listRecipes;
  const MyRecipesListWidget({required this.listRecipes, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
          child: DynamicHeightGridView(
            crossAxisCount: MediaQuery.of(context).size.width ~/ 130,
            mainAxisSpacing: 15.0,
            crossAxisSpacing: 10.0,
            itemCount: listRecipes.length,
            builder: (ctx, index) {
              return MyRecipeCardTile(recipe: listRecipes[index]);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
                decoration: const ShapeDecoration(
                    color: Colors.red, shape: CircleBorder()),
                child: IconButton(
                    onPressed: () {
                      Get.toNamed(Routes.ADD_RECIPE);
                    },
                    icon: const Icon(Icons.add, color: Colors.white))),
          ),
        ),
      ],
    );
  }
}
