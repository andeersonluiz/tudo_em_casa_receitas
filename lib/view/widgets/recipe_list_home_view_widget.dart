import 'package:extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/model/categorie_list_model.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/view/tile/card_recipe_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/card_recipe_trend_tile.dart';

class RecipeListHomeViewWidget extends StatefulWidget {
  final UserController userController = Get.find();
  final RecipeResultController recipeResultController = Get.find();
  RecipeListHomeViewWidget({super.key});

  @override
  State<RecipeListHomeViewWidget> createState() =>
      _RecipeListHomeViewWidgetState();
}

class _RecipeListHomeViewWidgetState extends State<RecipeListHomeViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        return LazyLoadScrollView(
          onEndOfPage: () {
            print("final pag");
            widget.recipeResultController.getMoreRecipesHomeView();
          },
          scrollOffset: 400,
          isLoading: widget.recipeResultController.isLastPage.value,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: widget.recipeResultController.listRecipesHomePage.length,
            itemBuilder: (ctx, index) {
              var tupleRecipe =
                  widget.recipeResultController.listRecipesHomePage[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 16.0, right: 16.0),
                    child: Row(
                      children: [
                        Text(
                            tupleRecipe[0] == ""
                                ? "Principais Receitas"
                                : tupleRecipe[0]
                                    .toString()
                                    .toLowerCase()
                                    .capitalizeFirstLetter(),
                            style: context.theme.textTheme.titleMedium!
                                .copyWith(fontSize: 18)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            widget.recipeResultController.clearlistFilters();
                            await Get.toNamed(Routes.RECIPE_CATEGORY,
                                arguments: {"category": tupleRecipe[0]});
                          },
                          child: Text("Ver Tudo",
                              style: context.theme.textTheme.bodyText1!
                                  .copyWith(fontSize: 14)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: tupleRecipe[0] == "" ? 235 : 170,
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ListView.builder(
                      itemCount: tupleRecipe[1].length,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        if (tupleRecipe[0] == "") {
                          return CardRecipeTrendTile(
                              tupleRecipe[1][index],
                              widget.userController
                                  .isMyRecipe(tupleRecipe[1][index]));
                        } else {
                          return CardRecipeTile(
                              tupleRecipe[1][index],
                              widget.userController
                                  .isMyRecipe(tupleRecipe[1][index]));
                        }
                      },
                    ),
                  )
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
