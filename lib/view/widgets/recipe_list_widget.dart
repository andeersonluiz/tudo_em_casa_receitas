import 'package:flutter/material.dart';
import 'package:tudo_em_casa_receitas/view/tile/recipe_tile.dart';

class RecipeListWidget extends StatelessWidget {
  final List<dynamic> listRecipe;
  const RecipeListWidget({required this.listRecipe, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        //controller: scrollController,
        itemCount: listRecipe.length,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: RecipeTile(recipe: listRecipe[index]),
          );
        },
      ),
    );
  }
}
