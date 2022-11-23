import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/crud_recipe_controller.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_item.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';

class AppBarWithOptions extends StatelessWidget with PreferredSizeWidget {
  final String text;
  AppBarWithOptions({super.key, required this.text});
  final CrudRecipeController crudRecipeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (crudRecipeController.listIngredientsSelected.isNotEmpty) {
        return AppBar(
          leading: IconButton(
              splashColor: Colors.transparent,
              onPressed: () {
                crudRecipeController.clearIngredientItemSelected();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).dialogBackgroundColor,
              )),
          actions: [
            crudRecipeController.listIngredientsSelected
                    .any((e) => (e is! IngredientItem))
                ? TextButton(
                    onPressed: () {
                      crudRecipeController.ungroupIngredientItens();
                    },
                    child: Text("Desagrupar",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                  )
                : Container(),
            crudRecipeController.listIngredientsSelected.length >= 2
                ? TextButton(
                    onPressed: () {
                      var result = crudRecipeController.joinIngredientItens();
                      if (result is String) {
                        GFToast.showToast(
                            backgroundColor:
                                Theme.of(context).textTheme.titleMedium!.color!,
                            textStyle: TextStyle(
                              color: context
                                  .theme.bottomSheetTheme.backgroundColor,
                            ),
                            toastDuration: 3,
                            toastPosition: GFToastPosition.BOTTOM,
                            result,
                            context);
                      }
                    },
                    child: Text("Unir",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                  )
                : Container(),
          ],
        );
      }
      return AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          leading: IconButton(
              splashColor: Colors.transparent,
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).dialogBackgroundColor,
              )),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonHideUnderline(
                child: Builder(builder: (context) {
                  return DropdownButton2(
                    isExpanded: true,
                    customButton: Icon(
                      FontAwesomeIcons.ellipsisVertical,
                      size: 24,
                      color: Theme.of(context).dialogBackgroundColor,
                    ),
                    onChanged: (value) {
                      Get.toNamed(
                        Routes.REPORT,
                      );
                    },
                    items: const [
                      DropdownMenuItem(
                          value: "Reportar problema",
                          child: Text(
                            "Reportar problema",
                          )),
                    ],
                    itemHeight: 48,
                    itemPadding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    dropdownWidth: 160,
                    dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Theme.of(context).bottomSheetTheme.backgroundColor,
                    ),
                    style: TextStyle(
                        fontFamily: 'CostaneraAltBook',
                        fontSize: 15,
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                    dropdownElevation: 8,
                    offset: const Offset(0, 8),
                  );
                }),
              ),
            )
          ],
          title: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontFamily: 'CosanteraAltMedium', fontSize: 19),
          ));
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
