import 'package:auto_size_text/auto_size_text.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/avatar_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/favorite_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/image_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/infos_tile.dart';

class RecipeTile extends StatelessWidget {
  final Recipe recipe;
  const RecipeTile({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: recipe.missingIngredient == "" ? 140 : 170,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Card(
          elevation: 3,
          child: Row(children: [
            Expanded(
                flex: 33,
                child: Stack(
                  children: [
                    ImageTile(
                      height: 140,
                      width: 280,
                      imageUrl: recipe.imageUrl,
                    ),
                    const Positioned.fill(
                      child: AvatarTile(
                        size: 13,
                        backgroundImage: AssetImage(
                          "assets/anom_avatar.png",
                        ),
                        alignment: Alignment.bottomLeft,
                      ),
                    ),
                  ],
                )),
            Expanded(
              flex: 67,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: recipe.missingIngredient != ""
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: AutoSizeText(recipe.title,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            minFontSize: 12,
                                            style: const TextStyle(
                                                fontFamily: "CostaneraAltBold",
                                                fontSize: 13)),
                                      ),
                                    ),
                                    FavoriteTile(
                                      padding: const EdgeInsets.all(8),
                                      size: 20,
                                      recipe: recipe,
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 6),
                                        child: AutoSizeText.rich(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            minFontSize: 12,
                                            style:
                                                const TextStyle(fontSize: 14),
                                            TextSpan(children: [
                                              const TextSpan(
                                                  text: "Falta: ",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "CostaneraAltBook",
                                                  )),
                                              TextSpan(
                                                  text: StringUtils.capitalize(
                                                      recipe.missingIngredient),
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        "CostaneraAltBold",
                                                    color:
                                                        CustomTheme.thirdColor,
                                                  )),
                                            ]))),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: AutoSizeText(recipe.title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        minFontSize: 12,
                                        style: const TextStyle(
                                            fontFamily: "CostaneraAltBold",
                                            fontSize: 13)),
                                  ),
                                ),
                                FavoriteTile(
                                  padding: const EdgeInsets.all(8),
                                  size: 20,
                                  recipe: recipe,
                                ),
                              ],
                            )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InfosTile(
                      infos: recipe.infos,
                      fontSize: 12,
                      iconSize: 17,
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
