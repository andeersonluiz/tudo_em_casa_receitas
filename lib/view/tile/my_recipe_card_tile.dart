import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/view/tile/image_tile.dart';

class MyRecipeCardTile extends StatelessWidget {
  final Recipe recipe;
  const MyRecipeCardTile({required this.recipe, Key? key}) : super(key: key);
  final width = 135.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width,
          height: 110,
          child: Stack(
            children: [
              ImageTile(width: width, height: 110, imageUrl: recipe.imageUrl),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(2.0),
                      constraints: const BoxConstraints(),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.xmark,
                        color: Colors.white,
                        size: 17,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(2.0),
                      constraints: const BoxConstraints(),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        size: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                minFontSize: 10,
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
