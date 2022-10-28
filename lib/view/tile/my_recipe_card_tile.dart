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
  final isMyUser;
  final bool isClickable;
  MyRecipeCardTile(
      {required this.recipe,
      required this.isMyUser,
      this.isClickable = true,
      Key? key})
      : super(key: key);
  final width = 135.0;
  MyRecipeController myRecipeController = Get.find();
  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: recipe.statusRecipe == StatusRevisionRecipe.Revision
                  ? Colors.yellow
                  : recipe.statusRecipe == StatusRevisionRecipe.Error
                      ? Colors.red
                      : Colors.transparent)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: width,
            height: 110,
            child: Stack(
              children: [
                ImageTile(width: width, height: 110, imageUrl: recipe.imageUrl),
                isMyUser
                    ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: context.theme.secondaryHeaderColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: IconButton(
                                splashColor: Colors.transparent,
                                padding: const EdgeInsets.all(2.0),
                                constraints: const BoxConstraints(),
                                highlightColor: Colors.transparent,
                                onPressed: isClickable
                                    ? () {
                                        showDialog(
                                            context: context,
                                            builder: (cxt) {
                                              return AlertDialog(
                                                title:
                                                    const CustomTextRecipeTile(
                                                  text: "Confirmar exclusão",
                                                  required: false,
                                                ),
                                                content: RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                "Deseja excluir a receita: ",
                                                            style: context
                                                                .theme
                                                                .textTheme
                                                                .titleMedium),
                                                        TextSpan(
                                                            text: recipe.title
                                                                .toUpperCase(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                        TextSpan(
                                                            text: "?",
                                                            style: context
                                                                .theme
                                                                .textTheme
                                                                .titleMedium),
                                                      ]),
                                                ),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: GFButton(
                                                          size: GFSize.MEDIUM,
                                                          color: context.theme
                                                              .splashColor,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      32),
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          textColor: context
                                                              .theme
                                                              .splashColor,
                                                          type: GFButtonType
                                                              .outline,
                                                          shape: GFButtonShape
                                                              .pills,
                                                          child: const Text(
                                                            "Voltar",
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: GFButton(
                                                          size: GFSize.MEDIUM,
                                                          color: context.theme
                                                              .secondaryHeaderColor,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      32),
                                                          onPressed: () async {
                                                            if (!mounted)
                                                              return;
                                                            var result =
                                                                await myRecipeController
                                                                    .deleteRecipe(
                                                                        recipe);
                                                            if (result == "") {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              GFToast.showToast(
                                                                  backgroundColor: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium!
                                                                      .color!,
                                                                  textStyle:
                                                                      TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .bottomSheetTheme
                                                                        .backgroundColor,
                                                                  ),
                                                                  toastDuration:
                                                                      3,
                                                                  toastPosition:
                                                                      GFToastPosition
                                                                          .BOTTOM,
                                                                  "Receita deletada com sucesso!!",
                                                                  context);
                                                            } else {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              GFToast.showToast(
                                                                  backgroundColor: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium!
                                                                      .color!,
                                                                  textStyle:
                                                                      TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .bottomSheetTheme
                                                                        .backgroundColor,
                                                                  ),
                                                                  toastDuration:
                                                                      3,
                                                                  toastPosition:
                                                                      GFToastPosition
                                                                          .BOTTOM,
                                                                  result,
                                                                  context);
                                                            }
                                                          },
                                                          shape: GFButtonShape
                                                              .pills,
                                                          child: const Text(
                                                            "Excluir receita",
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              );
                                            });
                                      }
                                    : null,
                                icon: const Icon(
                                  FontAwesomeIcons.xmark,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              )),
                        ),
                      )
                    : Container(),
                isMyUser
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              splashColor: Colors.transparent,
                              padding: const EdgeInsets.all(2.0),
                              constraints: const BoxConstraints(),
                              highlightColor: Colors.transparent,
                              onPressed: isClickable
                                  ? () {
                                      print("aaa ${recipe.toJson()}");
                                      Get.toNamed(Routes.UPDATE_RECIPE,
                                          arguments: {
                                            "recipe": recipe.toJson()
                                          });
                                    }
                                  : null,
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
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
      ),
    );
  }
}
