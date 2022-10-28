import 'package:extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:tudo_em_casa_receitas/controller/crud_recipe_controller.dart';
import 'package:tudo_em_casa_receitas/controller/suggestion_controller.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

class SelectIngredientTile extends StatelessWidget {
  final List<dynamic> list;
  final String hintText;
  final bool isIngredient;
  final bool isSuggestionIngredient;
  final bool isRevision;
  SelectIngredientTile(
      {Key? key,
      required this.list,
      required this.hintText,
      this.isIngredient = true,
      this.isRevision = false,
      this.isSuggestionIngredient = false})
      : super(key: key);
  final CrudRecipeController crudRecipeController = Get.find();
  final SuggestionController suggestionController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SearchableList<dynamic>(
        initialList: list,
        builder: (item) => InkWell(
          onTap: () {
            if (isSuggestionIngredient) {
              suggestionController.updateItemSelected(item);
            } else {
              isIngredient
                  ? crudRecipeController.updateIngredientSelected(item)
                  : crudRecipeController.updateMeasureValue(item);
            }
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              item.isRevision
                  ? "${item.name.toString().capitalizeFirstLetter()} (Em revisão)"
                  : item.name.toString().capitalizeFirstLetter(),
              style: TextStyle(
                  fontFamily: "CostaneraAltBook",
                  fontSize: 17,
                  color: item.isRevision
                      ? Colors.yellow[700]
                      : context.theme.textTheme.titleMedium!.color),
            ),
          ),
        ),
        filter: (value) => list
            .where(
              (element) => removeDiacritics(element.name)
                  .toLowerCase()
                  .contains(removeDiacritics(value).toLowerCase()),
            )
            .toList(),
        emptyWidget: Expanded(
            child: Column(
          children: [
            isIngredient
                ? const Text("Ingrediente não encontrado")
                : const Text("Medida não encontrada"),
            isSuggestionIngredient
                ? Container()
                : GFButton(
                    size: GFSize.MEDIUM,
                    color: context.theme.secondaryHeaderColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).pop();
                      isIngredient
                          ? await Get.toNamed(Routes.SUGGESTION_INGREDIENT,
                              preventDuplicates: false)
                          : await Get.toNamed(Routes.SUGGESTION_MEASURE,
                              preventDuplicates: false);
                    },
                    shape: GFButtonShape.pills,
                    child: Text(
                      isIngredient ? "Sugerir ingrediente" : "Sugerir Medida",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  )
          ],
        )),
        displayClearIcon: false,
        inputDecoration: InputDecoration(
          labelText: null,
          hintText: hintText,
          fillColor: Colors.white,
          suffixIcon: null,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.theme.secondaryHeaderColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  String removeDiacritics(String str) {
    var withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }
}
