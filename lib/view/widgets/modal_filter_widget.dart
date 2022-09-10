import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/modal_filter_tile.dart';
import 'package:tuple/tuple.dart';

class ModalFilterWidget extends StatelessWidget {
  final List<Tuple3> itens;
  const ModalFilterWidget({super.key, required this.itens});

  @override
  Widget build(BuildContext context) {
    RecipeResultController recipeResultController = Get.find();
    return Obx(() {
      if (recipeResultController.listFiltersModal.isEmpty) {
        recipeResultController.assingListModal(itens);
      }
      return Container(
          height: 220,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  recipeResultController.listFiltersModal[0].item2,
                  style: const TextStyle(
                      fontFamily: "CostaneraAltBold",
                      color: CustomTheme.thirdColor,
                      fontSize: 17),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: recipeResultController.listFiltersModal
                      .sublist(1)
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                var tupleValue =
                                    recipeResultController.tupleSelected.value;
                                if (tupleValue.item3 +
                                        tupleValue.item1.toString() ==
                                    e.item3 + e.item1.toString()) {
                                  recipeResultController.resetValueTuple();
                                } else {
                                  recipeResultController
                                      .updateValueListTimePreparation(e);
                                }
                              },
                              child: ModalFilterTile(
                                tuple: e,
                                typeFilter: recipeResultController
                                    .listFiltersModal[0].item1,
                                isSelected: recipeResultController
                                            .tupleSelected.value ==
                                        e
                                    ? true
                                    : false,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34.0),
                child: GFButton(
                  size: GFSize.MEDIUM,
                  color: CustomTheme.thirdColor,
                  onPressed: () {
                    if (recipeResultController.verifyIfItemSelected()) {
                      recipeResultController.filterResults(
                          isFilter: recipeResultController.textValue.value == ""
                              ? false
                              : true);
                      recipeResultController.updateValueListFilter();
                    } else {
                      recipeResultController.resetListModal();
                    }
                    recipeResultController.sortListFilter();
                    Navigator.pop(context);
                  },
                  text: "Aplicar",
                  blockButton: true,
                  shape: GFButtonShape.pills,
                ),
              ),
            ],
          ));
    });
  }
}
