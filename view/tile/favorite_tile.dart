import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/favorite_controller.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';

class FavoriteTile extends StatelessWidget {
  final EdgeInsets padding;
  final double size;
  final Recipe recipe;

  const FavoriteTile(
      {required this.padding,
      required this.size,
      required this.recipe,
      super.key});

  @override
  Widget build(BuildContext context) {
    FavoriteController favoriteController = Get.find();
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () async {
              await favoriteController.setFavorite(recipe);
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: padding,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 500),
                  scale: recipe.isFavorite ? 1.2 : 1,
                  child: Icon(
                    recipe.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: Colors.red,
                    size: size,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
