import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/crud_recipe_controller.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_item.dart';

import '../../theme/textTheme_theme.dart';

class AppBarWithOptions extends StatelessWidget with PreferredSizeWidget {
  final String text;
  AppBarWithOptions({super.key, required this.text});
  final CrudRecipeController crudRecipeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (crudRecipeController.listIngredientsSelected.isNotEmpty) {
        return AppBar(
          backgroundColor: CustomTheme.primaryColor,
          brightness: Brightness.dark,
          leading: IconButton(
              onPressed: () {
                crudRecipeController.clearIngredientItemSelected();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: CustomTheme.thirdColor,
              )),
          actions: [
            crudRecipeController.listIngredientsSelected
                    .any((e) => (e is! IngredientItem))
                ? TextButton(
                    onPressed: () {
                      crudRecipeController.ungroupIngredientItens();
                    },
                    child: const Text("Desagrupar"),
                  )
                : Container(),
            crudRecipeController.listIngredientsSelected.length >= 2
                ? TextButton(
                    onPressed: () {
                      var result = crudRecipeController.joinIngredientItens();
                      if (result is String) {
                        GFToast.showToast(
                            toastDuration: 3,
                            toastPosition: GFToastPosition.BOTTOM,
                            result,
                            context);
                      }
                    },
                    child: const Text("Unir"),
                  )
                : Container(),
          ],
        );
      }
      return AppBar(
          backgroundColor: CustomTheme.primaryColor,
          brightness: Brightness.dark,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: CustomTheme.thirdColor,
              )),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  customButton: const Icon(
                    FontAwesomeIcons.ellipsisVertical,
                    size: 24,
                    color: Colors.red,
                  ),
                  onChanged: (value) {
                    print(value);
                  },
                  items: ["Reportar problema"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  itemHeight: 48,
                  itemPadding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  dropdownWidth: 160,
                  dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  style: const TextStyle(
                      fontFamily: 'CostaneraAltBook',
                      fontSize: 15,
                      color: Colors.red),
                  dropdownElevation: 8,
                  offset: const Offset(0, 8),
                ),
              ),
            )
          ],
          title: Text(
            text,
            style: const TextStyle(
                color: Colors.red, fontFamily: 'CosanteraAltMedium'),
          ));
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
