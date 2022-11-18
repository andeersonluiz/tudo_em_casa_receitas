// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/my_recipe_controller.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/view/tile/custom_text_recipe_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/image_tile.dart';

class MyRecipeCardTile extends StatelessWidget {
  final Recipe recipe;
  final bool isMyUser;
  final bool isClickable;
  MyRecipeCardTile(
      {required this.recipe,
      required this.isMyUser,
      this.isClickable = true,
      Key? key})
      : super(key: key);
  final width = 135.0;
  final MyRecipeController myRecipeController = Get.find();
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
                                color: Theme.of(context).secondaryHeaderColor,
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
                                                backgroundColor:
                                                    Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .background
                                                        : Colors.white,
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
                                                              .dialogBackgroundColor,
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
                                                              .dialogBackgroundColor,
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
                                                      Obx(() {
                                                        return Center(
                                                          child: GFButton(
                                                            size: GFSize.MEDIUM,
                                                            color: context.theme
                                                                .secondaryHeaderColor,
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        32),
                                                            onPressed:
                                                                myRecipeController
                                                                        .isDeletingRecipe
                                                                        .value
                                                                    ? null
                                                                    : () async {
                                                                        if (!mounted) {
                                                                          return;
                                                                        }

                                                                        var result =
                                                                            await myRecipeController.deleteRecipe(recipe);
                                                                        if (result ==
                                                                            "") {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          GFToast.showToast(
                                                                              backgroundColor: Theme.of(context).textTheme.titleMedium!.color!,
                                                                              textStyle: TextStyle(
                                                                                color: Theme.of(context).bottomSheetTheme.backgroundColor,
                                                                              ),
                                                                              toastDuration: 3,
                                                                              toastPosition: GFToastPosition.BOTTOM,
                                                                              "Receita deletada com sucesso!!",
                                                                              context);
                                                                        } else {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          GFToast.showToast(
                                                                              backgroundColor: Theme.of(context).textTheme.titleMedium!.color!,
                                                                              textStyle: TextStyle(
                                                                                color: Theme.of(context).bottomSheetTheme.backgroundColor,
                                                                              ),
                                                                              toastDuration: 3,
                                                                              toastPosition: GFToastPosition.BOTTOM,
                                                                              result,
                                                                              context);
                                                                        }
                                                                      },
                                                            shape: GFButtonShape
                                                                .pills,
                                                            child: Text(
                                                              "Excluir receita",
                                                              style: myRecipeController
                                                                      .isDeletingRecipe
                                                                      .value
                                                                  ? const TextStyle(
                                                                      color: Colors
                                                                          .white60)
                                                                  : null,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 2,
                                                            ),
                                                          ),
                                                        );
                                                      }),
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
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.transparent
                : Colors.white,
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
                    fontFamily: "CostaneraAltBold",
                    fontSize: 12,
                  ),
                ),
              )),
            ),
          )
        ],
      ),
    );
  }
}
