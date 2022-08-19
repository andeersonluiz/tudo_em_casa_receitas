// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/button_controller.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/recipe_tile.dart';

class RecipeWidget extends StatelessWidget {
  final listRecipes;
  const RecipeWidget({super.key, required this.listRecipes});

  @override
  Widget build(BuildContext context) {
    var sep = listRecipes.where((element) {
      return element.missingIngredients.length == 0;
    }).toList();
    bool locked = false;
    int index = 0;
    ButtonController buttonController = Get.find();
    return ListView(
        physics: const BouncingScrollPhysics(),
        children: listRecipes.map<Widget>((recipe) {
          index += 1;
          if (sep.isNotEmpty && index - 1 == 0) {
            locked = true;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                  child: Text(
                    "Receitas Encontradas (${sep.length})",
                    style: CustomTheme.data.textTheme.headline6!.copyWith(
                        color: CustomTheme.thirdColor,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                RecipeTile(
                  recipe: recipe,
                )
              ],
            );
          } else if (index - 1 == sep.length) {
            locked = true;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                  child: Text(
                    "Falta apenas 1 item (${listRecipes.length - sep.length})",
                    style: CustomTheme.data.textTheme.subtitle2!.copyWith(
                      color: CustomTheme.thirdColor,
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                    ),
                  ),
                ),
                RecipeTile(
                  recipe: recipe,
                )
              ],
            );
          } else if (index - 1 == 10 || index - 1 == sep.length + 10) {
            locked = false;
            return Obx(() {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                child: GFButton(
                  text: "Ver tudo",
                  textStyle: CustomTheme.data.textTheme.button!.copyWith(
                      color: buttonController.pressed.value
                          ? CustomTheme.thirdColor
                          : CustomTheme.primaryColor,
                      fontWeight: FontWeight.bold),
                  onPressed: () {},
                  onHighlightChanged: (value) {
                    buttonController.setPressed(value);
                  },
                  shape: GFButtonShape.pills,
                  fullWidthButton: true,
                  color: CustomTheme.thirdColor,
                  splashColor: CustomTheme.primaryColor,
                  hoverColor: CustomTheme.primaryColor,
                  focusColor: CustomTheme.primaryColor,
                  type: GFButtonType.solid,
                ),
              );
            });
          } else if (locked) {
            return RecipeTile(
              recipe: recipe,
            );
          } else {
            return Container();
          }
        }).toList());
  }
}
//0 0 0 0 1 1 1 length=7 sep = 4 dif=3