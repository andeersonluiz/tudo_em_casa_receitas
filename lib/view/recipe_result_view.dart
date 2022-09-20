import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/recipe_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/app_bar_text_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/custom_drawer_widget.dart';

import '../controller/recipe_controller.dart';
import '../route/app_pages.dart';
import 'widgets/error_widget.dart';

class RecipeResultView extends StatefulWidget {
  const RecipeResultView({super.key});

  @override
  State<RecipeResultView> createState() => _RecipeResultViewState();
}

class _RecipeResultViewState extends State<RecipeResultView>
    with AutomaticKeepAliveClientMixin<RecipeResultView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    RecipeResultController recipeResultController = Get.find();
    bool loadNewList = true;
    return WillPopScope(
      onWillPop: () async {
        loadNewList = false;

        Get.back();
        await Future.delayed(const Duration(milliseconds: 200));
        await recipeResultController.clearListResult();

        return true;
      },
      child: Scaffold(
          endDrawer: CustomDrawerWidget(),
          drawerEdgeDragWidth: 0,
          appBar: AppBarWithText(
            text: "Resultados",
            onPressed: () async {
              loadNewList = false;
              Get.back();
              await Future.delayed(const Duration(milliseconds: 200));
              await recipeResultController.clearListResult();
            },
          ),
          body: Obx(() {
            if (recipeResultController.listRecipesResult.isEmpty &&
                recipeResultController.statusRecipesResult.value ==
                    StatusRecipeResult.None &&
                loadNewList) {
              recipeResultController.getRecipesResults();
            }
            if (recipeResultController.listRecipesResult.isNotEmpty &&
                recipeResultController.statusRecipesResult.value ==
                    StatusRecipeResult.Finished) {
              int listRecipesSize =
                  recipeResultController.listRecipesResult[0].length;
              int listRecipesMissingOneSize =
                  recipeResultController.listRecipesResult[1].length;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    listRecipesSize != 0
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 12.0, right: 16.0, bottom: 3),
                            child: Row(
                              children: [
                                Text("Receitas Encontradas ($listRecipesSize)",
                                    style: const TextStyle(
                                        fontFamily: "CostaneraAltBold",
                                        fontSize: 18)),
                                const Spacer(),
                                listRecipesSize > 10
                                    ? GestureDetector(
                                        onTap: () async {
                                          Get.toNamed(Routes.RECIPE_ALL_RESULTS,
                                              arguments: {
                                                "isMatched": true,
                                              });
                                        },
                                        child: const Text("Ver Tudo",
                                            style: TextStyle(
                                                fontFamily: "CostaneraAltBook",
                                                fontSize: 14,
                                                color: Colors.red)),
                                      )
                                    : Container()
                              ],
                            ),
                          )
                        : Container(),
                    Column(
                      children: recipeResultController.listRecipesResult[0]
                          .take(10)
                          .map<RecipeTile>((element) =>
                              RecipeTile(recipe: element as Recipe))
                          .toList(),
                    ),
                    listRecipesMissingOneSize != 0
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 12.0, right: 16.0, bottom: 6),
                            child: Row(
                              children: [
                                Text(
                                    "Falta apenas um ingrediente ($listRecipesMissingOneSize)",
                                    style: const TextStyle(
                                        fontFamily: "CostaneraAltBold",
                                        fontSize: 18)),
                                const Spacer(),
                                listRecipesMissingOneSize > 10
                                    ? GestureDetector(
                                        onTap: () async {
                                          Get.toNamed(Routes.RECIPE_ALL_RESULTS,
                                              arguments: {
                                                "isMatched": false,
                                              });
                                        },
                                        child: const Text("Ver Tudo",
                                            style: TextStyle(
                                                fontFamily: "CostaneraAltBook",
                                                fontSize: 14,
                                                color: Colors.red)),
                                      )
                                    : Container()
                              ],
                            ),
                          )
                        : Container(),
                    Column(
                      children: recipeResultController.listRecipesResult[1]
                          .take(10)
                          .map<RecipeTile>((element) =>
                              RecipeTile(recipe: element as Recipe))
                          .toList(),
                    )
                  ],
                ),
              );
            } else if (recipeResultController.listRecipesResult.isEmpty &&
                recipeResultController.statusRecipesResult.value ==
                    StatusRecipeResult.Finished) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Não foram encontradas receitas com base nos seus ingredientes :( ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'CostaneraAltBook', fontSize: 20),
                    ),
                  ),
                ),
              );
            } else if (recipeResultController.statusRecipesResult.value ==
                StatusRecipeResult.Error) {
              return CustomErrorWidget(
                "Erro ao carregar receitas, verifique sua conexão",
                onRefresh: () async {
                  await recipeResultController.getRecipesResults();
                },
              );
            } else {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const GFLoader(
                  size: GFSize.LARGE,
                  androidLoaderColor:
                      AlwaysStoppedAnimation<Color>(CustomTheme.thirdColor),
                ),
              );
            }
          })),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
