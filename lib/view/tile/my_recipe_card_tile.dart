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

class MyRecipeCardTile extends StatelessWidget {
  final Recipe recipe;
  MyRecipeCardTile({required this.recipe, Key? key}) : super(key: key);
  final width = 135.0;
  final MyRecipeController myRecipeController = Get.find();
  @override
  Widget build(BuildContext context, [bool mounted = true]) {
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
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (cxt) {
                              return AlertDialog(
                                title: const CustomTextRecipeTile(
                                  text: "Confirmar exclusão",
                                  required: false,
                                ),
                                content: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      style: const TextStyle(fontSize: 15),
                                      children: [
                                        const TextSpan(
                                            text: "Deseja excluir a receita ",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        TextSpan(
                                            text: recipe.title.toUpperCase(),
                                            style: const TextStyle(
                                                fontFamily: "CostaneraAltBold",
                                                color: Colors.black)),
                                        const TextSpan(
                                            text: "?",
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ]),
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: GFButton(
                                          size: GFSize.MEDIUM,
                                          color: CustomTheme.thirdColor,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 32),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                          },
                                          textColor: CustomTheme.thirdColor,
                                          type: GFButtonType.outline,
                                          shape: GFButtonShape.pills,
                                          child: const Text(
                                            "Voltar",
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: GFButton(
                                          size: GFSize.MEDIUM,
                                          color: CustomTheme.thirdColor,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 32),
                                          onPressed: () async {
                                            if (!mounted) return;
                                            var result =
                                                await myRecipeController
                                                    .deleteRecipe(recipe);
                                            if (result == "") {
                                              Navigator.of(context).pop();
                                              GFToast.showToast(
                                                  toastDuration: 3,
                                                  toastPosition:
                                                      GFToastPosition.BOTTOM,
                                                  "Receita deletada com sucesso!!",
                                                  context);
                                            } else {
                                              Navigator.of(context).pop();
                                              GFToast.showToast(
                                                  toastDuration: 3,
                                                  toastPosition:
                                                      GFToastPosition.BOTTOM,
                                                  result,
                                                  context);
                                            }
                                          },
                                          shape: GFButtonShape.pills,
                                          child: const Text(
                                            "Excluir receita",
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            });
                      },
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
                      onPressed: () {
                        Get.toNamed(Routes.UPDATE_RECIPE,
                            arguments: {"recipe": recipe.toJson()});
                      },
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
