import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/view/tile/avatar_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/favorite_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/image_tile.dart';

class CardRecipeTile extends StatelessWidget {
  final Recipe recipe;
  const CardRecipeTile(this.recipe, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: Stack(
          children: [
            Stack(
              children: [
                ImageTile(height: 153, width: 130, imageUrl: recipe.imageUrl),
                Positioned.fill(
                    child: FavoriteTile(
                  padding: const EdgeInsets.all(4.0),
                  size: 15.0,
                  recipe: recipe,
                )),
                const Positioned.fill(
                  child: AvatarTile(
                    size: 15,
                    backgroundImage: AssetImage(
                      "assets/anom_avatar.png",
                    ),
                    alignment: Alignment.topLeft,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    margin: const EdgeInsets.only(top: 100),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, -2),
                          )
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 53,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0, left: 8, bottom: 8.0, top: 8.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: AutoSizeText(recipe.title,
                                  maxLines: 2,
                                  minFontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: "CostaneraAltBold",
                                    color: Colors.white,
                                    fontSize: 16,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
