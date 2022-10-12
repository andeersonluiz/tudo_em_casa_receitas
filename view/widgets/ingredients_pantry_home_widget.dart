import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/home_view_controller.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/view/tile/ingredient_pantry_tile.dart';

class IngredientsPantryHomeWidget extends StatefulWidget {
  const IngredientsPantryHomeWidget({super.key});

  @override
  State<IngredientsPantryHomeWidget> createState() =>
      _IngredientsPantryHomeWidgetState();
}

class _IngredientsPantryHomeWidgetState
    extends State<IngredientsPantryHomeWidget>
    with AutomaticKeepAliveClientMixin<IngredientsPantryHomeWidget> {
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
/*
  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {}
  }*/

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      if (ingredientController.listIngredientsHomePantry.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: ingredientController.listIngredientsHomePantry.length,
            itemBuilder: (ctx, index) {
              var element =
                  ingredientController.listIngredientsHomePantry[index];
              if (ingredientController.listIngredientsHomePantry.last ==
                  element) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 58),
                  child: IngredientPantryTile(
                      ingredient: element,
                      onPressDelete: () {
                        ingredientController
                            .removeIngredientHomePantry(element);
                        homeViewController.updateToogleValue(
                            !ingredientController.verifyMinIngredients());
                      }),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: IngredientPantryTile(
                    ingredient: element,
                    onPressDelete: () {
                      ingredientController.removeIngredientHomePantry(element);
                      homeViewController.updateToogleValue(
                          !ingredientController.verifyMinIngredients());
                    }),
              );
            },
            controller: scrollController,
          ),
        );
      } else {
        return const Center(
          child: Text(
            "",
            style: TextStyle(fontFamily: 'CostaneraAltBook', fontSize: 20),
          ),
        );
      }
    });
  }
}
