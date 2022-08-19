// ignore_for_file: file_names
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';

enum Status {
  // ignore: constant_identifier_names
  Finished,
  // ignore: constant_identifier_names
  Loading,
  // ignore: constant_identifier_names
  Nothing,
  // ignore: constant_identifier_names
  Error,
}

class RecipeResultController extends GetxController {
  var listRecipes = [].obs;
  var status = Status.Nothing.obs;
  final _firebaseBaseHelper = FirebaseBaseHelper();

  static List<dynamic> getRecipesFiltred(var data) {
    try {
      List<dynamic> listRecipesFiltred = [];

      int referenceID = 0;
      for (List<String> recipe in data[1]) {
        int counter = 0;
        int whiteList = 0;
        List<String> notMissingDescriptionRecipe = [];
        List<String> missingIngredients = [];
        for (String descriptionIngredients in recipe) {
          for (String ingredientName in data[0]) {
            if (descriptionIngredients.contains(ingredientName)) {
              counter += 1;
              notMissingDescriptionRecipe.add(descriptionIngredients);
              break;
            } else if ((descriptionIngredients.startsWith("*") &&
                descriptionIngredients.endsWith("*"))) {
              whiteList += 1;
              notMissingDescriptionRecipe.add(descriptionIngredients);
              break;
            }
          }
        }
        var missingDescriptionRecipe = recipe
            .where((element) => !notMissingDescriptionRecipe.contains(element))
            .toList();
        if (missingDescriptionRecipe.length < 2) {
          for (String ingName in data[2]) {
            for (String description in missingDescriptionRecipe) {
              if (description.toLowerCase().contains(ingName.toLowerCase())) {
                missingIngredients.add(ingName);
                missingDescriptionRecipe.remove(description);
                break;
              }
            }
            if (missingDescriptionRecipe.isEmpty) {
              break;
            }
          }
        }
        if (counter + whiteList == recipe.length && counter > 0) {
          listRecipesFiltred.add([referenceID, []]);
        }
        if (counter + whiteList == recipe.length - 1 && counter > 0) {
          listRecipesFiltred.add([referenceID, missingIngredients]);
        }
        referenceID += 1;
      }

      return listRecipesFiltred;
      //status.value = Status.Finished;
      //listRecipes.assignAll(listRecipesFiltred);
    } catch (e) {
      return [-1];
      //status.value = Status.Error;
    }
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

  @override
  Future<void> onInit() async {
    super.onInit();
    IngredientController ingredientController = Get.find();

    var listIngredients = ingredientController.getListIngredientsFiltred();
    var listIngredientsName =
        listIngredients.map((item) => item.searchValue).toList();
    var allIngredients = ingredientController.listIngredients;
    var allIngredientsName =
        allIngredients.map((item) => item.searchValue).toList();
    var listRecipesResult = await _firebaseBaseHelper.getRecipes();
    var listRecipesIngredients =
        listRecipesResult.map((Recipe item) => item.ingredients).toList();
    status.value = Status.Loading;
    compute(RecipeResultController.getRecipesFiltred, [
      listIngredientsName,
      listRecipesIngredients,
      allIngredientsName
    ]).then((value) {
      var result = [];
      for (List item in value) {
        Recipe recipe = listRecipesResult[item[0]];

        recipe.missingIngredients = item[1].isEmpty ? [] : item[1];
        result.add(recipe);
      }
      result.sort((a, b) =>
          a.missingIngredients.length.compareTo(b.missingIngredients.length));
      if (result.isNotEmpty) {
        if (result[0] == -1) {
          status.value = Status.Error;
        }
      }
      status.value = Status.Finished;
      listRecipes.assignAll(result);
    });
  }
}
