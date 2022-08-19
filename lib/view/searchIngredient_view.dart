// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/widgets/search_widget.dart';

class SearchIngredientView extends StatelessWidget {
  const SearchIngredientView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IngredientController ingredientController = Get.find();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: GFAppBar(
          title: const Text(
            "LOGO_APP",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: CustomTheme.primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (ingredientController.filteredSearch.isEmpty) {
                Navigator.of(context).pop();
              } else {
                CustomTheme.controller.clear();
                ingredientController.clearSearch();
              }
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchWidget(controller: CustomTheme.controller),
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Obx(() {
                  //NAO SERIA FALSO?
                  if (ingredientController.filteredSearch.isEmpty ||
                      ingredientController.isSearching.value == true) {
                    return GFButton(
                        onPressed: () async {
                          //BLQUEAR CASO NAO TENHA NENHUM INGREDIENTE NA LISTA FILTRADA
                          FocusScope.of(context).unfocus();
                          Get.toNamed(Routes.RECIPE_RESULT);
                        },
                        color: CustomTheme.thirdColor,
                        blockButton: true,
                        shape: GFButtonShape.pills,
                        size: GFSize.LARGE,
                        child: Text('Buscar Receitas',
                            style: Theme.of(context)
                                .textTheme
                                .button!
                                .copyWith(color: Colors.white, fontSize: 16)));
                  } else {
                    return Container();
                  }
                })),
          ],
        ),
      ),
    );
  }
}
