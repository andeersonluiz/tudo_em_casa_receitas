import 'package:get/get.dart';
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

  var isLoadingSuggestionIngredient = false.obs;
  var isLoadingSuggestionMeasure = false.obs;
  var isLoadingSuggestionCategorie = false.obs;

  Ingredient? ingredientSelected;
  UserController userController = Get.find();
  IngredientController ingredientController = Get.find();
  final regexValidator = RegExp(r'^([^0-9&._]*)$');
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
      isLoadingSuggestionIngredient.value = true;

      var id = ingredientSingularText.value
          .toLowerCase()
          .toTitleCase()
          .replaceAll(" ", "");

      var listResult = ingredientController.listIngredients
          .where((p0) => p0.id == id)
          .toList();
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
      isLoadingSuggestionIngredient.value = false;
      return "";
    } catch (e) {
      isLoadingSuggestionIngredient.value = false;
      return "Não foi possivel enviar seu ingrediente para revisão, tente novamente mais tarde";
    }
  }

  sendMeasureToRevision() async {
    try {
      isLoadingSuggestionMeasure.value = true;
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
      isLoadingSuggestionMeasure.value = false;

      return "";
    } catch (e) {
      isLoadingSuggestionMeasure.value = false;

      return "Não foi possivel enviar sua medida para revisão, tente novamente mais tarde";
    }
  }

  sendCategorieToRevision() async {
    try {
      isLoadingSuggestionCategorie.value = true;
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
      isLoadingSuggestionCategorie.value = false;

      return "";
    } catch (e) {
      isLoadingSuggestionCategorie.value = false;

      return "Não foi possivel enviar sua medida para revisão, tente novamente mais tarde";
    }
  }

  wipeData() {
    isSynonyms.value = false;
    updateItemSelected(null);
  }
}
