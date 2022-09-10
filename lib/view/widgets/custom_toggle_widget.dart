import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/custom_animation_controller.dart';
import 'package:tudo_em_casa_receitas/controller/home_view_controller.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';
import 'package:tudo_em_casa_receitas/support/custom_shake.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

class CustomToggle extends StatelessWidget {
  const CustomToggle({super.key});

  @override
  Widget build(BuildContext context) {
    HomeViewController homeViewController = Get.find();
    IngredientController ingredientController = Get.find();
    RecipeResultController recipeResultController = Get.find();
    CustomAnimationController customAnimationController = Get.find();
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        width: 170,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              blurRadius: 5,
              color: Colors.black.withOpacity(0.3),
            ),
          ],
          color: CustomTheme.greyAccent,
        ),
        child: Stack(children: [
          !customAnimationController.isShaking.value
              ? AnimatedPositioned(
                  top: 1.5,
                  right: homeViewController.toggleValue.value ? 90 : 0,
                  left: homeViewController.toggleValue.value ? 0 : 80,
                  curve: Curves.easeIn,
                  onEnd: () {
                    homeViewController.updateToggleStatus(Status.Finished);
                  },
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 90,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.white),
                  ),
                )
              : ShakeWidget(
                  shakeConstant: CustomShake(
                      offSetX: homeViewController.toggleValue.value ? 0 : 80),
                  duration: const Duration(milliseconds: 200),
                  autoPlay: true,
                  child: Container(
                    width: 90,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.white),
                  ),
                ),
          Positioned(
              child: Row(children: [
            GestureDetector(
              onTap: () async {
                homeViewController.updateToogleValue(true);
                recipeResultController.getRecipesHomeView();
              },
              child: SizedBox(
                  height: 160,
                  width: 80,
                  child: Center(
                      child: Text(
                    textAlign: TextAlign.center,
                    "Padrão",
                    style: TextStyle(
                        fontFamily: 'CostaneraAltBlack',
                        color: homeViewController.toggleValue.value
                            ? Colors.black
                            : CustomTheme.greyColor),
                  ))),
            ),
            GestureDetector(
              onTap: () async {
                if (ingredientController.verifyMinIngredients()) {
                  homeViewController.updateToogleValue(false);
                  recipeResultController.getRecipesPantryView();
                } else {
                  GFToast.showToast(
                      "Você deve ter mais de ${LocalVariables.minIngredients} ingredientes na sua despensa",
                      toastDuration: 3,
                      toastPosition: GFToastPosition.BOTTOM,
                      context);
                  await customAnimationController.shake();
                }
              },
              child: SizedBox(
                  height: 160,
                  width: 90,
                  child: Center(
                      child: Text(
                    "Despensa",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'CostaneraAltBlack',
                        color: !homeViewController.toggleValue.value
                            ? Colors.black
                            : CustomTheme.greyColor),
                  ))),
            ),
          ]))
        ]),
      ),
    );
  }
}
