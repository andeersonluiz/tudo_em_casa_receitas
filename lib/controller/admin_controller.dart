import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';

import '../model/categorie_model.dart';
import '../model/measure_model.dart';

class AdminController extends GetxController {
  var listCategoriesRevision = [].obs;
  var listIngredientsRevision = [].obs;
  var listMeasuresRevision = [].obs;
  var isLoadingCategoriesRevision = false.obs;
  var isLoadingIngredientsRevision = false.obs;
  var isLoadingMeasuresRevision = false.obs;

  var isLoadingSimilarCategories = false.obs;
  var isLoadingSimilarIngredients = false.obs;
  var isLoadingSimilarMeasures = false.obs;

  Rx<Ingredient> similarIngredient = Ingredient.emptyClass().obs;
  Rx<Categorie> similarCategorie = Categorie.emptyClass().obs;
  Rx<Measure> similarMeasure = Measure.emptyClass().obs;

  var isLoadingActionCategories = false.obs;
  var isLoadingActionIngredients = false.obs;
  var isLoadingActionMeasures = false.obs;

  @override
  void onInit() async {
    await getListCategoriesRevision();
    await getListIngredientsRevision();
    await getListMeasuresRevision();
    super.onInit();
  }

  getListCategoriesRevision() async {
    isLoadingCategoriesRevision.value = true;
    try {
      listCategoriesRevision
          .assignAll(await FirebaseBaseHelper.getCategoriesRevision());
      isLoadingCategoriesRevision.value = false;
    } catch (e) {
      isLoadingCategoriesRevision.value = false;
    }
  }

  getListIngredientsRevision() async {
    isLoadingIngredientsRevision.value = true;
    try {
      listIngredientsRevision
          .assignAll(await FirebaseBaseHelper.getIngredientsRevision());
      isLoadingIngredientsRevision.value = false;
    } catch (e) {
      isLoadingIngredientsRevision.value = false;
    }
  }

  getListMeasuresRevision() async {
    isLoadingMeasuresRevision.value = true;
    try {
      listMeasuresRevision
          .assignAll(await FirebaseBaseHelper.getMeasuresRevision());

      isLoadingMeasuresRevision.value = false;
    } catch (e) {
      print(e);
      isLoadingMeasuresRevision.value = false;
    }
  }

  verifySimilarIngredient(Ingredient ingredient) async {
    isLoadingSimilarIngredients.value = true;
    try {
      var result = await FirebaseBaseHelper.verifySimilarIngredient(ingredient);
      if (result != null) {
        similarIngredient.value = result;
      } else {
        similarIngredient.value = Ingredient.emptyClass();
      }
      isLoadingSimilarIngredients.value = false;
    } catch (e) {
      print(e);
      isLoadingSimilarIngredients.value = false;
    }
  }

  rejectIngredient(Ingredient ingredient) async {
    isLoadingActionIngredients.value = true;
    try {
      var result = await FirebaseBaseHelper.updateIngredient(ingredient,
          rejectIngredient: true);

      isLoadingActionIngredients.value = false;
      if (result) {
        getListIngredientsRevision();
      }
      return result;
    } catch (e) {
      print(e);
      isLoadingActionIngredients.value = false;
    }
  }

  acceptIngredient(Ingredient ingredient) async {
    isLoadingActionIngredients.value = true;
    try {
      var result = await FirebaseBaseHelper.updateIngredient(ingredient,
          rejectIngredient: false);

      isLoadingActionIngredients.value = false;
      if (result) {
        getListIngredientsRevision();
      }
      return result;
    } catch (e) {
      print(e);
      isLoadingActionIngredients.value = false;
    }
  }

  verifySimilarMeasure(Measure measure) async {
    isLoadingSimilarMeasures.value = true;
    try {
      var result = await FirebaseBaseHelper.verifySimilarMeasure(measure);
      if (result != null) {
        similarMeasure.value = result;
      } else {
        similarMeasure.value = Measure.emptyClass();
      }
      isLoadingSimilarMeasures.value = false;
    } catch (e) {
      print(e);
      isLoadingSimilarMeasures.value = false;
    }
  }

  rejectMeasure(Measure measure) async {
    isLoadingActionMeasures.value = true;
    try {
      var result =
          await FirebaseBaseHelper.updateMeasure(measure, rejectMeasure: true);

      isLoadingActionMeasures.value = false;
      if (result) {
        getListMeasuresRevision();
      }
      return result;
    } catch (e) {
      print(e);
      isLoadingActionMeasures.value = false;
    }
  }

  acceptMeasure(Measure measure) async {
    isLoadingActionMeasures.value = true;
    try {
      var result =
          await FirebaseBaseHelper.updateMeasure(measure, rejectMeasure: false);

      isLoadingActionMeasures.value = false;
      if (result) {
        getListMeasuresRevision();
      }
      return result;
    } catch (e) {
      print(e);
      isLoadingActionMeasures.value = false;
    }
  }

  verifySimilarCategorie(Categorie categorie) async {
    isLoadingSimilarCategories.value = true;
    try {
      var result = await FirebaseBaseHelper.verifySimilarCategorie(categorie);
      if (result != null) {
        similarCategorie.value = result;
      } else {
        similarCategorie.value = Categorie.emptyClass();
      }
      isLoadingSimilarCategories.value = false;
    } catch (e) {
      print(e);
      isLoadingSimilarCategories.value = false;
    }
  }

  rejectCategorie(Categorie categorie) async {
    isLoadingActionCategories.value = true;
    try {
      var result = await FirebaseBaseHelper.updateCategorie(categorie,
          rejectCategorie: true);

      isLoadingActionCategories.value = false;
      if (result) {
        getListCategoriesRevision();
      }
      return result;
    } catch (e) {
      print(e);
      isLoadingActionCategories.value = false;
    }
  }

  acceptCategorie(Categorie categorie) async {
    isLoadingActionCategories.value = true;
    try {
      var result = await FirebaseBaseHelper.updateCategorie(categorie,
          rejectCategorie: false);

      isLoadingActionCategories.value = false;
      if (result) {
        getListCategoriesRevision();
      }
      return result;
    } catch (e) {
      print(e);
      isLoadingActionCategories.value = false;
    }
  }
}
