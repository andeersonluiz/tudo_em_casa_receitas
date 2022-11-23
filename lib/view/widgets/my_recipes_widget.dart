import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/view/tile/favorite_recipe_card_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/my_recipe_card_tile.dart';

class MyRecipesListWidget extends StatefulWidget {
  final List<Recipe> listRecipes;
  final bool isMyRecipe;
  const MyRecipesListWidget(
      {required this.listRecipes, this.isMyRecipe = true, super.key});

  @override
  State<MyRecipesListWidget> createState() => _MyRecipesListWidgetState();
}

class _MyRecipesListWidgetState extends State<MyRecipesListWidget> {
  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.listRecipes.isEmpty && widget.isMyRecipe
            ? const Center(
                child: Text(
                "Não há receitas, adicione uma.",
                style: TextStyle(fontFamily: 'CostaneraAltBook', fontSize: 20),
              ))
            : widget.listRecipes.isEmpty && !widget.isMyRecipe
                ? const Center(
                    child: Text(
                    "Não há favoritos adicionados.",
                    style:
                        TextStyle(fontFamily: 'CostaneraAltBook', fontSize: 20),
                  ))
                : Padding(
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24.0, top: 24.0),
                    child: DynamicHeightGridView(
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: MediaQuery.of(context).size.width ~/ 130,
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 10.0,
                      itemCount: widget.listRecipes.length,
                      builder: (ctx, index) {
                        return InkWell(
                          onTap: () {
                            if (widget.listRecipes[index].statusRecipe ==
                                StatusRevisionRecipe.Revision) {
                              GFToast.showToast(
                                  backgroundColor: context
                                      .theme.textTheme.titleMedium!.color!,
                                  textStyle: TextStyle(
                                    color: context
                                        .theme.bottomSheetTheme.backgroundColor,
                                  ),
                                  toastDuration: 3,
                                  toastPosition: GFToastPosition.BOTTOM,
                                  "Receita em revisão, aguarde a atualização da receita",
                                  context);
                            } else if (widget.listRecipes[index].statusRecipe ==
                                StatusRevisionRecipe.Error) {
                              GFToast.showToast(
                                  backgroundColor: context
                                      .theme.textTheme.titleMedium!.color!,
                                  textStyle: TextStyle(
                                    color: context
                                        .theme.bottomSheetTheme.backgroundColor,
                                  ),
                                  toastDuration: 3,
                                  toastPosition: GFToastPosition.BOTTOM,
                                  "Sua receita possui erros, corrija-os para enviar",
                                  context);
                            } else {
                              Get.toNamed(
                                  "${Routes.RECIPE_VIEW}/${widget.listRecipes[index].id}",
                                  arguments: {
                                    "recipe":
                                        widget.listRecipes[index].toJson(),
                                    "isMyRecipe": widget.isMyRecipe,
                                  });
                            }
                          },
                          child: widget.isMyRecipe
                              ? MyRecipeCardTile(
                                  recipe: widget.listRecipes[index],
                                  isMyUser: widget.isMyRecipe)
                              : FavoriteRecipeCardTile(
                                  recipe: widget.listRecipes[index],
                                ),
                        );
                      },
                    ),
                  ),
        widget.isMyRecipe
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      decoration: ShapeDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          shape: const CircleBorder()),
                      child: IconButton(
                          splashColor: Colors.transparent,
                          onPressed: () {
                            Get.toNamed(Routes.ADD_RECIPE);
                          },
                          icon: const Icon(Icons.add, color: Colors.white))),
                ),
              )
            : Container(),
      ],
    );
  }
}
