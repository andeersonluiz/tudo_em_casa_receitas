import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/crud_recipe_controller.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/categorie_model.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/model/measure_model.dart';

class SuggestionController extends GetxController {
  var ingredientSingularText = "".obs;
  var ingredientPluralText = "".obs;
  var measureSingularText = "".obs;
  var measurePluralText = "".obs;

  var categorieText = "".obs;

  var isSynonyms = false.obs;
  var itemSelected = "".obs;
  Ingredient? ingredientSelected;
  UserController userController = Get.find();
  IngredientController ingredientController = Get.find();

  updateIngredientSingularText(String newValue) {
    ingredientSingularText.value = newValue;
  }

  updateIngredientPluralText(String newValue) {
    ingredientPluralText.value = newValue;
  }

  updateMeasureSingularText(String newValue) {
    measureSingularText.value = newValue;
  }

  updateMeasurePluralText(String newValue) {
    measurePluralText.value = newValue;
  }

  updateIsSynonyms() {
    isSynonyms.value = !isSynonyms.value;
    if (!isSynonyms.value) {
      updateItemSelected(null);
    }
  }

  updateItemSelected(Ingredient? ingredient) {
    ingredientSelected = ingredient;
    if (ingredient == null) {
      itemSelected.value = "";
    } else {
      itemSelected.value = ingredient.name;
    }
  }

  updateCategorieText(String newValue) {
    categorieText.value = newValue;
  }

  sendIngredientToRevision() async {
    try {
      print(ingredientSingularText.value
          .toLowerCase()
          .toTitleCase()
          .replaceAll(" ", ""));
      var id = ingredientSingularText.value
          .toLowerCase()
          .toTitleCase()
          .replaceAll(" ", "");
      for (var item in ingredientController.listIngredients) {
        if (item.isRevision) {
          print("rev");
          print(item.id);
        }
        if (item.id.startsWith("X")) {
          print("entrei");
          print(item.id);
          print(id);
          print(item.id == id);
        }
      }
      var listResult = ingredientController.listIngredients
          .where((p0) => p0.id == id)
          .toList();
      print("oi $listResult");
      if (listResult.isNotEmpty) {
        return "Ingrediente já existente na lista original";
      }
      Ingredient ingredient = Ingredient(
          id: ingredientSingularText.value
              .toLowerCase()
              .toTitleCase()
              .replaceAll(" ", ""),
          name: ingredientSingularText.value,
          isSelected: false,
          plurals: ingredientPluralText.value,
          synonyms: ingredientSelected,
          recipesCount: 0,
          order: 5000,
          isRevision: true,
          isPantry: false,
          isHome: false);
      var result = await FirebaseBaseHelper.sendIngredientToRevision(
          ingredient, userController.currentUser.value);
      if (result != "") {
        return result;
      }
      ingredientController.addIngredient(ingredient);
      print("fooi");
      return "";
    } catch (e) {
      print(e);
      return "Não foi possivel enviar seu ingrediente para revisão, tente novamente mais tarde";
    }
  }

  sendMeasureToRevision() async {
    try {
      print(measureSingularText.value
          .toLowerCase()
          .toTitleCase()
          .replaceAll(" ", ""));
      var name = measureSingularText.value
          .toLowerCase()
          .toTitleCase()
          .replaceAll(" ", "");
      var listResult = ingredientController.listMeasures
          .where((p0) =>
              p0.name
                  .toString()
                  .toLowerCase()
                  .toTitleCase()
                  .replaceAll(" ", "") ==
              name)
          .toList();
      if (listResult.isNotEmpty) {
        return "Medida já existente na lista original";
      }
      Measure measure = Measure(
          name: measureSingularText.value,
          plural: measurePluralText.value,
          isRevision: true,
          order: 5000);
      var result = await FirebaseBaseHelper.sendMeasureToRevision(
          measure, userController.currentUser.value);
      if (result != "") {
        return result;
      }
      ingredientController.addtMeasure(measure);

      return "";
    } catch (e) {
      print(e);
      return "Não foi possivel enviar sua medida para revisão, tente novamente mais tarde";
    }
  }

  sendCategorieToRevision() async {
    try {
      var name =
          categorieText.value.toLowerCase().toTitleCase().replaceAll(" ", "");
      var listResult = ingredientController.listCategories
          .where((p0) =>
              p0.name
                  .toString()
                  .toLowerCase()
                  .toTitleCase()
                  .replaceAll(" ", "") ==
              name)
          .toList();
      if (listResult.isNotEmpty) {
        return "Categoria já existente na lista original";
      }
      Categorie categorie =
          Categorie(name: categorieText.value, isRevision: true, order: 5000);
      var result = await FirebaseBaseHelper.sendCategorieToRevision(
          categorie, userController.currentUser.value);
      if (result != "") {
        return result;
      }
      ingredientController.addtCategorie(categorie);

      return "";
    } catch (e) {
      print(e);
      return "Não foi possivel enviar sua medida para revisão, tente novamente mais tarde";
    }
  }

  wipeData() {
    isSynonyms.value = false;
    updateItemSelected(null);
  }
}
