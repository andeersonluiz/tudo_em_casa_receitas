import 'package:extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:tudo_em_casa_receitas/controller/crud_recipe_controller.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

class SelectMultipleItens extends StatelessWidget {
  final List<dynamic> list;
  SelectMultipleItens({Key? key, required this.list}) : super(key: key);
  final CrudRecipeController crudRecipeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return ObxValue((v) {
      // ignore: avoid_print
      print(crudRecipeController.listCategoriesSelected); //print para rodar
      return SearchableList<dynamic>(
        initialList: list,
        builder: (item) {
          var result = crudRecipeController.listCategoriesSelected
              .where((element) => item.name == element.name)
              .toList()
              .isNotEmpty;

          if (result) {
            return InkWell(
              onTap: () {
                crudRecipeController.removeItemlistCategoriesSelected(item);
              },
              child: Container(
                color: item.hasError
                    ? Colors.red.shade300
                    : item.isRevision
                        ? Colors.yellow[200]
                        : CustomTheme.greyAccent.withOpacity(0.4),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          item.isRevision
                              ? "${item.name.toString().toLowerCase().capitalizeFirstLetter()} (em revisão)"
                              : item.name
                                  .toString()
                                  .toLowerCase()
                                  .capitalizeFirstLetter(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontFamily: "CostaneraAltBook",
                              fontSize: 17,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.check,
                        color: item.hasError
                            ? Theme.of(context).secondaryHeaderColor
                            : item.isRevision
                                ? Colors.yellow[800]
                                : Theme.of(context).bottomAppBarTheme.color,
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return InkWell(
              onTap: () {
                crudRecipeController.addItemListCategoriesSelected(item);
              },
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        item.isRevision
                            ? "${item.name.toString().toLowerCase().capitalizeFirstLetter()} (em revisão)"
                            : item.name
                                .toString()
                                .toLowerCase()
                                .capitalizeFirstLetter(),
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: "CostaneraAltBook",
                          fontSize: 17,
                          color: item.hasError
                              ? Colors.red[500]
                              : item.isRevision
                                  ? Colors.yellow[700]
                                  : Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .color,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(),
                  )
                ],
              ),
            );
          }
        },
        filter: (value) => list
            .where(
              (element) => removeDiacritics(element.name)
                  .toLowerCase()
                  .contains(removeDiacritics(value).toLowerCase()),
            )
            .toList(),
        searchTextController: TextEditingController(),
        emptyWidget: Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Categoria não encontrada"),
              GFButton(
                size: GFSize.MEDIUM,
                color: Theme.of(context).secondaryHeaderColor,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                  Get.toNamed(Routes.SUGGESTION_CATEGORIE);
                },
                shape: GFButtonShape.pills,
                child: const Text(
                  "Sugerir categoria",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              )
            ],
          ),
        )),
        displayClearIcon: false,
        cursorColor: Theme.of(context).dialogBackgroundColor,
        inputDecoration: InputDecoration(
          hintText: "Digite a categoria",
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).dialogBackgroundColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    }, crudRecipeController.listCategoriesSelected);
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
