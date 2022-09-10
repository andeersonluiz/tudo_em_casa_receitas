import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/home_view_controller.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/view/tile/ingredient_pantry_tile.dart';

class IngredientsPantryWidget extends StatefulWidget {
  const IngredientsPantryWidget({super.key});

  @override
  State<IngredientsPantryWidget> createState() =>
      _IngredientsPantryWidgetState();
}

class _IngredientsPantryWidgetState extends State<IngredientsPantryWidget>
    with AutomaticKeepAliveClientMixin<IngredientsPantryWidget> {
  final scrollController = ScrollController();
  IngredientController ingredientController = Get.find();
  HomeViewController homeViewController = Get.find();
  @override
  void initState() {
    super.initState();
    //scrollController.addListener(scrollListener);
  }

  @override
  bool get wantKeepAlive => true;

  /*void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {}
  }*/

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      if (ingredientController.listIngredientsPantry.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: ingredientController.listIngredientsPantry.length,
            itemBuilder: (ctx, index) {
              var element = ingredientController.listIngredientsPantry[index];
              if (ingredientController.listIngredientsPantry.last == element) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 58),
                  child: Column(
                    children: [
                      IngredientPantryTile(
                          ingredient: element as Ingredient,
                          onPressDelete: () {
                            ingredientController
                                .removeIngredientPantry(element);
                            homeViewController.updateToogleValue(
                                !ingredientController.verifyMinIngredients());
                          }),
                    ],
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    IngredientPantryTile(
                        ingredient: element as Ingredient,
                        onPressDelete: () {
                          ingredientController.removeIngredientPantry(element);
                          homeViewController.updateToogleValue(
                              !ingredientController.verifyMinIngredients());
                        }),
                  ],
                ),
              );
            },
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
          ),
        );
      } else {
        return const Center(
          child: Text(
            "Despensa vazia :(",
            style: TextStyle(fontFamily: 'CostaneraAltBook', fontSize: 20),
          ),
        );
      }
    });
  }
}
