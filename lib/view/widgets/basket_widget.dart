import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/ingredient_pantry_tile.dart';

class BasketWidget extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final listIngredients;
  final bool isSearch;
  const BasketWidget(
      {super.key, required this.listIngredients, required this.isSearch});

  @override
  Widget build(BuildContext context) {
    IngredientController ingredientController = Get.find();
    return isSearch
        ? Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: listIngredients.length,
              itemBuilder: (BuildContext context, int index) {
                return Container();
              },
            ),
          )
        : Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Container(
                    color: CustomTheme.thirdColor,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Meus Ingredientes",
                          style: CustomTheme.data.textTheme.headline5
                              ?.copyWith(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ingredientController
                                .getListIngredientsFiltred()
                                .length !=
                            0
                        ? GestureDetector(
                            onTap: () {
                              ingredientController.clearListFiltred();
                            },
                            child: Text(
                              "Limpar",
                              style: CustomTheme.data.textTheme.bodyText2
                                  ?.copyWith(
                                color: CustomTheme.thirdColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        : Text(
                            "Limpar",
                            style:
                                CustomTheme.data.textTheme.bodyText2?.copyWith(
                              color: Colors.grey,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                  ),
                ]),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: CustomTheme.thirdColor),
                          borderRadius: BorderRadius.circular(8.0)),
                      child: ingredientController
                                  .getListIngredientsFiltred()
                                  .length ==
                              0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  const Icon(Ionicons.cart_outline,
                                      size: 75, color: CustomTheme.thirdColor),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Carrinho de ingredientes vazio",
                                      style: CustomTheme
                                          .data.textTheme.subtitle1
                                          ?.copyWith(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 16),
                                    ),
                                  )
                                ])
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder:
                                  ((BuildContext context, int index) {
                                if (listIngredients[index].isSelected) {
                                  return const Divider(
                                    color: CustomTheme.thirdColor,
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                              itemCount: listIngredients.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (listIngredients[index].isSelected) {
                                  return Container();
                                } else {
                                  return Container();
                                }
                              },
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
