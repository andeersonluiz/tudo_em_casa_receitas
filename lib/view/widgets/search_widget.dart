// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/widgets/basket_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/error_widget.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
//removercontroller
  const SearchWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    IngredientController ingredientController = Get.find();

    return Obx(() {
      if (ingredientController.listIngredients.length == 1) {
        return const GFLoader(
            androidLoaderColor:
                AlwaysStoppedAnimation<Color>(CustomTheme.thirdColor));
      } else if (ingredientController.listIngredients.length > 1) {
        return Column(
          children: [
            KeyboardVisibility(
              onChanged: (bool visible) {
                ingredientController.setKeyboardVisible(visible);
              },
              child: TextField(
                controller: controller,
                onChanged: ingredientController.filterSearch,
                decoration: InputDecoration(
                    suffixIcon: ingredientController.keyboardVisible.value ||
                            controller.text != ""
                        ? IconButton(
                            splashRadius: 20,
                            icon: Icon(Icons.close,
                                color: Colors.black.withOpacity(0.4)),
                            onPressed: () {
                              if (ingredientController.filteredSearch.isEmpty) {
                                FocusScope.of(context).unfocus();
                              }
                              controller.clear();
                              ingredientController.filteredSearch.value = [];
                            },
                          )
                        : Icon(
                            Icons.search,
                            color: Colors.black.withOpacity(0.4),
                          ),
                    hintText: 'Buscar Ingredientes...',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.4), width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.black))),
              ),
            ),
            ingredientController.filteredSearch.isNotEmpty
                ? BasketWidget(
                    listIngredients: ingredientController.filteredSearch.value,
                    isSearch: true)
                : ingredientController.isSearching.value
                    ? const Expanded(
                        child: GFLoader(
                            androidLoaderColor: AlwaysStoppedAnimation<Color>(
                                CustomTheme.thirdColor)),
                      )
                    : controller.text != "" &&
                            ingredientController.filteredSearch.isEmpty
                        ? const Expanded(
                            child: CustomErrorWidget(
                                "Não há registros para sua busca"))
                        : BasketWidget(
                            listIngredients:
                                ingredientController.listIngredients.value,
                            isSearch: false),
          ],
        );
      } else {
        //RETORNA ERRO
        return Container();
      }
    });
  }
}
