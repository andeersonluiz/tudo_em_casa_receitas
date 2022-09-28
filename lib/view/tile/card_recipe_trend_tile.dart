import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/view/tile/avatar_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/favorite_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/image_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/infos_tile.dart';

class CardRecipeTrendTile extends StatelessWidget {
  final Recipe recipe;
  const CardRecipeTrendTile(this.recipe, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 3),
                      )
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0, left: 10, top: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(recipe.title,
                              maxLines: 1,
                              minFontSize: 13,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: "CostaneraAltBold",
                                fontSize: 16,
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4.0),
                      child: InfosTile(infos: recipe.infos),
                    )
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                ImageTile(
                  height: 150,
                  width: 280,
                  imageUrl: recipe.imageUrl,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                Positioned.fill(
                  child: FavoriteTile(
                    padding: const EdgeInsets.all(6.0),
                    size: 15.0,
                    recipe: recipe,
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
