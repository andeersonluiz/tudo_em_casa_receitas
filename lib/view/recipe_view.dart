import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fsearch/fsearch.dart';
import 'package:get/get.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';
import 'package:tudo_em_casa_receitas/view/tile/loader_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/error_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/filter_recipe_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/search_widget.dart';

import 'widgets/recipe_list_widget.dart';

class RecipeView extends StatefulWidget {
  const RecipeView({super.key});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  //final scrollController = ScrollController();
  RecipeResultController recipeResultController = Get.find();
  FSearchController fSearchController = FSearchController();
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) fSearchController.clearFocus();
    });
  }
/*
  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {}
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: SearchWidget(
              controller: fSearchController,
              hint: "Buscar Receitas...",
              center: false,
              padding: const EdgeInsets.all(8),
              onClear: () {
                fSearchController.text = "";
                fSearchController.clearFocus();
                recipeResultController.updateTextValue("");
                recipeResultController.clearListFiltring();
              },
              onSearch: (value) {
                if (value == "") {
                  fSearchController.text = "";
                  fSearchController.clearFocus();
                  recipeResultController.updateTextValue("");
                  recipeResultController.clearListFiltring();
                } else if (value != recipeResultController.textValue.value &&
                    value != "") {
                  recipeResultController.updateTextValue(value);
                  recipeResultController.filterSearch();
                }
              }),
        ),
        FilterRecipeWidget(
            listType: recipeResultController.textValue.value == ""
                ? ListType.RecipePage
                : ListType.RecipePageFiltered),
        Obx(() {
          if (recipeResultController.listRecipesFiltered.isNotEmpty) {
            if (recipeResultController.listRecipesFiltered.isNotEmpty &&
                recipeResultController.statusRecipesPage.value ==
                    StatusRecipe.Finished) {
              return RecipeListWidget(
                  listRecipe: recipeResultController.listRecipesFiltered);
            } else if (recipeResultController.listRecipesFiltered.isEmpty &&
                recipeResultController.statusRecipesPage.value ==
                    StatusRecipe.Finished) {
              return Expanded(
                  child: CustomErrorWidget(
                "Não há receitas para sua busca :(",
                onRefresh: () async {
                  await recipeResultController.filterResults(
                      listType: recipeResultController.textValue.value == ""
                          ? ListType.RecipePage
                          : ListType.RecipePageFiltered);
                },
              ));
            } else if (recipeResultController.statusRecipesPage.value ==
                StatusRecipe.Error) {
              return Expanded(
                  child: CustomErrorWidget(
                "Erro ao carregar receitas, verifique sua conexão",
                onRefresh: () async {
                  await recipeResultController.filterResults(
                      listType: recipeResultController.textValue.value == ""
                          ? ListType.RecipePage
                          : ListType.RecipePageFiltered);
                },
              ));
            } else {
              return const Expanded(
                  child: LoaderTile(
                size: GFSize.LARGE,
              ));
            }
          } else {
            if (recipeResultController.listRecipes.isEmpty &&
                recipeResultController.statusRecipesPage.value ==
                    StatusRecipe.None) {
              recipeResultController.getAllRecipes();
            }
            if (recipeResultController.listRecipes.isNotEmpty &&
                recipeResultController.statusRecipesPage.value ==
                    StatusRecipe.Finished) {
              return RecipeListWidget(
                  listRecipe: recipeResultController.listRecipes);
            } else if (recipeResultController.statusRecipesPage.value ==
                StatusRecipe.Error) {
              return Expanded(
                  child: CustomErrorWidget(
                "Erro ao carregar receitas, verifique sua conexão",
                onRefresh: () async {
                  await recipeResultController.getAllRecipes();
                },
              ));
            } else {
              return const Expanded(
                  child: LoaderTile(
                size: GFSize.LARGE,
              ));
            }
          }
        })
      ],
    );
  }

  @override
  void dispose() {
    recipeResultController.updateTextValue("");
    recipeResultController.clearListFiltring();

    fSearchController.dispose();
    //keyboardSubscription.cancel();
    super.dispose();
  }
}
