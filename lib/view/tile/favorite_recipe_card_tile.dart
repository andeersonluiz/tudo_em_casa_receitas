// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/my_recipe_controller.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/custom_text_recipe_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/image_tile.dart';

class FavoriteRecipeCardTile extends StatelessWidget {
  final Recipe recipe;
  const FavoriteRecipeCardTile({required this.recipe, Key? key})
      : super(key: key);
  final width = 135.0;
  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width,
          height: 110,
          child:
              ImageTile(width: width, height: 110, imageUrl: recipe.imageUrl),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: SizedBox(
            width: width,
            height: 45,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                recipe.title,
                minFontSize: 11,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontFamily: "CostaneraAltBold", fontSize: 12),
              ),
            )),
          ),
        )
      ],
    );
  }
}
