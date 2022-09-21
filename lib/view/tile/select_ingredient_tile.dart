import 'package:extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:tudo_em_casa_receitas/controller/crud_recipe_controller.dart';

class SelectIngredientTile extends StatelessWidget {
  final List<dynamic> list;
  final String hintText;
  final bool isIngredient;
  SelectIngredientTile(
      {Key? key,
      required this.list,
      required this.hintText,
      this.isIngredient = false})
      : super(key: key);
  final CrudRecipeController crudRecipeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SearchableList<dynamic>(
      initialList: list,
      builder: (item) => InkWell(
        onTap: () {
          isIngredient
              ? crudRecipeController.updateIngredientSelected(item.name)
              : crudRecipeController.updateMeasureValue(item);
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            item.name.toString().capitalizeFirstLetter(),
            style:
                const TextStyle(fontFamily: "CostaneraAltBook", fontSize: 17),
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
      emptyWidget: const Expanded(
          child: Text("Ingrediente não encontrado, sugerir o ingrediente?")),
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
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
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
