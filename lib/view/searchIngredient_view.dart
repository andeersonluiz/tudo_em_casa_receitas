// ignore_for_file: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fsearch/fsearch.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/home_view_controller.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/widgets/error_widget.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:tudo_em_casa_receitas/view/widgets/ingredients_list_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/search_widget.dart';

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
  HomeViewController homeViewController = Get.find();
  @override
  void initState() {
    ingredientController.sortListIngredient(refresh: true, isHome: !isPantry);
    var keyboardVisibilityController = KeyboardVisibilityController();
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
                      if (fSearchController.text != "") {
                        fSearchController.clearFocus();
                        fSearchController.text = "";
                        ingredientController.updateTextValue("");
                        ingredientController.sortListIngredient(
                            refresh: true, isHome: !isPantry);
                      }
                    },
                    child: const Text("Limpar",
                        style: TextStyle(
                            fontFamily: 'CostaneraAltBook',
                            color: CustomTheme.thirdColor)),
                  ),
                ),
              )
            ],
            title: SearchWidget(
              controller: fSearchController,
              hint: "Buscar Ingrediente",
              onSearch: (value) {
                ingredientController.updateTextValue(value);
                ingredientController.filterSearch(value, isHome: !isPantry);
              },
            )),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: Obx(
            () {
              if (ingredientController.textValue.value != "") {
                if (ingredientController.listIngredientsFiltred.isNotEmpty) {
                  return IngredientListWidget(
                    listIngredients:
                        ingredientController.listIngredientsFiltred,
                    isPantry: isPantry,
                  );
                } else {
                  return Center(
                    child: CustomErrorWidget(
                      "Não há resultados para sua busca",
                      onRefresh: () async {
                        ingredientController.filterSearch(
                            ingredientController.textValue.value,
                            isHome: !isPantry);
                      },
                    ),
                  );
                }
              } else {
                if (ingredientController.listIngredients.isNotEmpty &&
                    ingredientController.statusIngredients.value ==
                        StatusIngredients.Finished) {
                  return IngredientListWidget(
                      listIngredients: ingredientController.listIngredients,
                      isPantry: isPantry);
                } else if (ingredientController.statusIngredients.value ==
                    StatusIngredients.Error) {
                  return Center(
                    child: CustomErrorWidget(
                      "Erro ao carregar ingredientes, verifique sua conexão",
                      onRefresh: () async {
                        await ingredientController.getIngredients();
                      },
                    ),
                  );
                } else {
                  return const GFLoader(
                    size: GFSize.LARGE,
                    androidLoaderColor:
                        AlwaysStoppedAnimation<Color>(CustomTheme.thirdColor),
                  );
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
    ingredientController.updateTextValue("");
    ingredientController.clearListFiltring();
    fSearchController.dispose();
    keyboardSubscription.cancel();
    super.dispose();
  }
}
