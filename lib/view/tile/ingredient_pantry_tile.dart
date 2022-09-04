import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';

class IngredientPantryTile extends StatelessWidget {
  final Ingredient ingredient;
  final Function()? onPressDelete;
  const IngredientPantryTile(
      {super.key, required this.ingredient, required this.onPressDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        trailing: IconButton(
            onPressed: onPressDelete,
            icon: const Icon(Icons.close),
            color: Colors.red),
        title: Text(StringUtils.capitalize(ingredient.name)),
      ),
    );
  }
}
/*// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/ingredient_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/error_widget.dart';

class SearchIngredientView extends StatelessWidget {
  const SearchIngredientView({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    IngredientController ingredientController = Get.find();
    print("Oi");
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () {
            print(ingredientController.listIngredients);
            print(ingredientController.isLoadingIngredients);
            if (ingredientController.listIngredients.isNotEmpty &&
                !ingredientController.isLoadingIngredients.value) {
              return SearchAppBarPage(
                  magnifyinGlassColor: Colors.white,
                  searchAppBarcenterTitle: true,
                  listFull: ingredientController.listIngredients,
                  searchAppBarhintText: 'Search for a name',
                  searchAppBartitle: Text(
                    'Search Page',
                    style: TextStyle(fontSize: 20),
                  ),
                  stringFilter: (ingredient) {
                    return (ingredient as Ingredient).name;
                  },
                  obxListBuilder: ((context, list, isModSearch) {
                    print("building...");
                    return ListView(
                      children: list
                          .map((element) =>
                              IngredientTile(ingredient: element as Ingredient))
                          .toList(),
                    );
                  }));
            } else if (ingredientController.hasErrorIngredients.value) {
              return CustomErrorWidget(
                  "Erro ao carregar, verifique sua conexão");
            } else if (ingredientController.isLoadingIngredients.value) {
              return GFLoader();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
*/