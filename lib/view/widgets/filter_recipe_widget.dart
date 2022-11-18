import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/view/widgets/modal_filter_widget.dart';

import '../../controller/recipe_controller.dart';

class FilterRecipeWidget extends StatelessWidget {
  final ListType listType;
  const FilterRecipeWidget({super.key, required this.listType});

  @override
  Widget build(BuildContext context) {
    RecipeResultController recipeResultController = Get.find();
    return Obx(() {
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
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  if (recipeResultController.statusRecipesPage.value !=
                      StatusRecipe.Loading) {
                    if (textFilter.item3 == "open") {
                      recipeResultController.tupleTemp =
                          recipeResultController.tupleSelected.value;
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Theme.of(context)
                              .bottomSheetTheme
                              .backgroundColor,
                          builder: (context) {
                            return ModalFilterWidget(
                              itens: textFilter.item2,
                              listType: listType,
                            );
                          }).whenComplete(() {
                        if (!recipeResultController.applyClicked) {
                          recipeResultController.updateValueListTimePreparation(
                              recipeResultController.tupleTemp);
                        }
                        recipeResultController.applyClicked = false;
                      });
                    } else {
                      recipeResultController.updateTagValue(textFilter);
                      recipeResultController
                          .updateFilterSelected(textFilter.item1);
                      recipeResultController.sortListFilter();
                      recipeResultController.filterResults(listType: listType);
                    }
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  decoration: (recipeResultController.filterSelected.value ==
                              textFilter.item1 ||
                          recipeResultController.selectedTupleString ==
                              textFilter.item1)
                      ? BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          border: Border.all(
                              width: 1.5,
                              color: Theme.of(context).secondaryHeaderColor),
                          borderRadius: BorderRadius.circular(20))
                      : BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 1.5,
                              color: Theme.of(context).dialogBackgroundColor),
                          borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      textFilter.item1,
                      style: TextStyle(
                        color: (recipeResultController.filterSelected.value ==
                                    textFilter.item1 ||
                                recipeResultController.selectedTupleString ==
                                    textFilter
                                        .item1) //GAMBIARRA >< NAO ADICIONAR SUBSTRING
                            ? Colors.white
                            : Theme.of(context).secondaryHeaderColor,
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
    });
  }
}
