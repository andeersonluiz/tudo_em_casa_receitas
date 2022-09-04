// ignore_for_file: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fsearch/fsearch.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/ingredient_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/error_widget.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class SearchIngredientView extends StatefulWidget {
  const SearchIngredientView({Key? key}) : super(key: key);

  @override
  State<SearchIngredientView> createState() => _SearchIngredientViewState();
}

class _SearchIngredientViewState extends State<SearchIngredientView> {
  late IngredientController ingredientController = Get.find();
  FSearchController fSearchController = FSearchController();
  late StreamSubscription<bool> keyboardSubscription;
  bool isPantry = Get.arguments["isPantry"];
  @override
  void initState() {
    ingredientController.sortListIngredient(refresh: true, isHome: !isPantry);
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) fSearchController.clearFocus();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leadingWidth: 45,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: CustomTheme.thirdColor,
              )),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, left: 8, bottom: 8, right: 12.0),
                child: InkWell(
                  onTap: () {
                    fSearchController.clearFocus();
                    fSearchController.text = "";
                    ingredientController.updateTextValue("");
                    ingredientController.sortListIngredient(
                        refresh: true, isHome: !isPantry);
                  },
                  child: const Text("Limpar",
                      style: TextStyle(
                          fontFamily: 'CostaneraAltBook',
                          color: CustomTheme.thirdColor)),
                ),
              ),
            )
          ],
          title: FSearch(
            height: 40,
            controller: fSearchController,
            hints: const ["Buscar Ingredientes"],
            hintPrefix: const Text(
              "Buscar Ingredientes",
              style: TextStyle(
                  fontFamily: 'CostaneraAltBook',
                  fontSize: 17,
                  color: Colors.black38),
            ),
            center: true,
            style: const TextStyle(
                fontFamily: 'CostaneraAltBook', color: Colors.black),
            corner: FSearchCorner.all(16),
            backgroundColor: CustomTheme.greyAccent.withOpacity(0.5),
            onSearch: (value) {
              ingredientController.updateTextValue(value);
              ingredientController.filterSearch(value, isHome: !isPantry);
            },
          ),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: Obx(
            () {
              if (ingredientController.textValue.value != "") {
                if (ingredientController.listIngredientsFiltred.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: ListView(
                      children: ingredientController.listIngredientsFiltred
                          .map((element) {
                        Ingredient ingredient = element as Ingredient;
                        if (isPantry && ingredient.isHome) {
                          return Container();
                        }
                        return IngredientTile(
                          ingredient: ingredient,
                          param: isPantry
                              ? ingredient.isPantry
                              : ingredient.isHome,
                          onPressedAdd: () {
                            isPantry
                                ? ingredientController
                                    .addIngredientPantry(ingredient)
                                : ingredientController
                                    .addIngredientHomePantry(ingredient);
                          },
                          onPressedRemove: () {
                            isPantry
                                ? ingredientController
                                    .removeIngredientPantry(ingredient)
                                : ingredientController
                                    .removeIngredientHomePantry(ingredient);
                          },
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return const Center(
                    child:
                        CustomErrorWidget("Não há resultados para sua busca"),
                  );
                }
              } else {
                if (ingredientController.listIngredients.isNotEmpty &&
                    !ingredientController.isLoadingIngredients.value) {
                  return Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: ListView(
                      children:
                          ingredientController.listIngredients.map((element) {
                        Ingredient ingredient = element as Ingredient;

                        if (isPantry && ingredient.isHome) {
                          return Container();
                        }
                        return IngredientTile(
                          ingredient: ingredient,
                          param: isPantry
                              ? ingredient.isPantry
                              : ingredient.isHome,
                          onPressedAdd: () {
                            isPantry
                                ? ingredientController
                                    .addIngredientPantry(ingredient)
                                : ingredientController
                                    .addIngredientHomePantry(ingredient);
                          },
                          onPressedRemove: () {
                            isPantry
                                ? ingredientController
                                    .removeIngredientPantry(ingredient)
                                : ingredientController
                                    .removeIngredientHomePantry(ingredient);
                          },
                        );
                      }).toList(),
                    ),
                  );
                } else if (ingredientController.hasErrorIngredients.value) {
                  return const Center(
                    child: CustomErrorWidget(
                        "Erro ao carregar, verifique sua conexão"),
                  );
                } else if (ingredientController.isLoadingIngredients.value) {
                  return const GFLoader(
                    size: GFSize.LARGE,
                    androidLoaderColor:
                        AlwaysStoppedAnimation<Color>(CustomTheme.thirdColor),
                  );
                } else {
                  return Container();
                }
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    print("disposing..");
    ingredientController.updateTextValue("");
    ingredientController.clearListFiltring();
    fSearchController.dispose();
    keyboardSubscription.cancel();
    super.dispose();
  }
}
