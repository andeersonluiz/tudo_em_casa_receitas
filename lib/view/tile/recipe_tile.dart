import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

class RecipeTile extends StatelessWidget {
  final Recipe recipe;
  const RecipeTile({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: recipe.missingIngredients.isEmpty ? 150 : 170,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Card(
          elevation: 3,
          child: Row(children: [
            Expanded(
              flex: 33,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    image: recipe.imageUrl == ""
                        ? const DecorationImage(
                            image: AssetImage("assets/no-photo-available.png"),
                            fit: BoxFit.cover)
                        : DecorationImage(
                            image: NetworkImage(recipe.imageUrl),
                            fit: BoxFit.cover)),
              ),
            ),
            Expanded(
              flex: 67,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: recipe.missingIngredients.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: CustomTheme.data.textTheme.headline6!
                                      .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    "Ingrediente faltante: ${StringUtils.capitalize(recipe.missingIngredients.join(", "))}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: CustomTheme.data.textTheme.subtitle2!
                                        .copyWith(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              recipe.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: CustomTheme.data.textTheme.headline6!
                                  .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(
                              Ionicons.time_outline,
                              color: Colors.grey,
                              size: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                recipe.infos.preparationTime,
                                style: CustomTheme.data.textTheme.caption!
                                    .copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.favorite,
                              color: CustomTheme.thirdColor,
                            )),
                      )
                    ],
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
