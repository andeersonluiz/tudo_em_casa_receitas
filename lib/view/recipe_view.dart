import 'package:flutter/material.dart';
import 'package:fsearch/fsearch.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/widgets/error_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/modal_filter_widget.dart';
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
  //late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();
    /*scrollController.addListener(scrollListener);
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) fSearchController.clearFocus();
    });*/
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
        Obx(() {
          return Container(
            padding: const EdgeInsets.only(bottom: 8),
            height: 35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recipeResultController.listFilters.length,
              itemBuilder: (ctx, index) {
                var textFilter = recipeResultController.listFilters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: InkWell(
                    onTap: () {
                      if (recipeResultController.statusRecipesPage.value !=
                          StatusRecipe.Loading) {
                        if (textFilter.item3 == "open") {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return ModalFilterWidget(
                                    itens: textFilter.item2);
                              });
                        } else {
                          recipeResultController.updateTagValue(textFilter);
                          recipeResultController
                              .updateFilterSelected(textFilter.item1);
                          recipeResultController.sortListFilter();
                          recipeResultController.filterResults(
                              isFilter:
                                  recipeResultController.textValue.value == ""
                                      ? false
                                      : true);
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 1),
                      decoration:
                          (recipeResultController.filterSelected.value ==
                                      textFilter.item1 ||
                                  recipeResultController.selectedTupleString ==
                                      textFilter.item1)
                              ? BoxDecoration(
                                  color: Colors.red,
                                  border: Border.all(
                                      width: 1.5,
                                      color: CustomTheme.thirdColor),
                                  borderRadius: BorderRadius.circular(20))
                              : BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1.5,
                                      color: CustomTheme.thirdColor),
                                  borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          textFilter.item1,
                          style: TextStyle(
                            color: (recipeResultController
                                            .filterSelected.value ==
                                        textFilter.item1 ||
                                    recipeResultController
                                            .selectedTupleString ==
                                        textFilter
                                            .item1) //GAMBIARRA >< NAO ADICIONAR SUBSTRING
                                ? Colors.white
                                : CustomTheme.thirdColor,
                            fontFamily: 'CostaneraAltBook',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
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
                      isFilter: recipeResultController.textValue.value == ""
                          ? false
                          : true);
                },
              ));
            } else if (recipeResultController.statusRecipesPage.value ==
                StatusRecipe.Error) {
              return Expanded(
                  child: CustomErrorWidget(
                "Erro ao carregar receitas, verifique sua conexão",
                onRefresh: () async {
                  await recipeResultController.filterResults(
                      isFilter: recipeResultController.textValue.value == ""
                          ? false
                          : true);
                },
              ));
            } else {
              return const Expanded(
                  child: GFLoader(
                size: GFSize.LARGE,
                androidLoaderColor:
                    AlwaysStoppedAnimation<Color>(CustomTheme.thirdColor),
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
                  child: GFLoader(
                size: GFSize.LARGE,
                androidLoaderColor:
                    AlwaysStoppedAnimation<Color>(CustomTheme.thirdColor),
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
