import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/categorie_model.dart';
import 'package:tudo_em_casa_receitas/model/infos_model.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_item.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/model/measure_model.dart';
import 'package:tudo_em_casa_receitas/model/preparation_item.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/model/user_info_model.dart';
import 'package:tudo_em_casa_receitas/support/permutation_algorithm_strings.dart';

class CrudRecipeController extends GetxController {
  var recipeTitle = "".obs;
  var photoSelected = "".obs;
  var ingredientSelected = Ingredient.emptyClass().obs;
  bool isIngredientRevision = false;
  var formartValue = "".obs;
  Rx<Measure> measureSelected = Measure.emptyClass().obs;

  var errorText = "".obs;

  var hourPreparationTime = 0.obs;
  var minutesPreparationTime = 0.obs;

  var hourPreparationTimeTemp = 0.obs;
  var minutesPreparationTimeTemp = 0.obs;

  var yieldValue = 0.obs;
  var yieldValueTemp = 0.obs;
  var qtdValue = 0.obs;
  var ingOptional = false.obs;
  IngredientItem? ingredientItemSelected;

  var listItems = [].obs;

  var subtopicValue = "".obs;

  var isSelectedIngredientItem = false.obs;
  var listIngredientsSelected = [].obs;

  var listPreparations = [].obs;
  PreparationItem? preparationItemSelected;
  var descriptionValue = "".obs;

  var listCategoriesSelected = [].obs;
  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  Function eq = const ListEquality().equals;
  UserController userController = Get.find();

  var errorimageText = "".obs;
  var errorTimePreparationText = "".obs;
  var errorYieldText = "".obs;
  var errorIngredientsText = "".obs;
  var errorPreparationText = "".obs;
  var errorCategoriesText = "".obs;

  var isLoading = false.obs;
  var isLoadingConfirm = false.obs;
  Recipe? recipeSelected;

  bool changedIngredientSelected = false;

  updateRecipeTitle(String newValue) {
    recipeTitle.value = newValue;
  }

  updatePhotoSelected(String newValue) {
    photoSelected.value = newValue;
    errorimageText.value = "";
  }

  updateFormatValue(String newValue) {
    formartValue.value = newValue;
  }

  updateHourPreparationTime() {
    if (hourPreparationTime.value != hourPreparationTimeTemp.value) {
      hourPreparationTime.value = hourPreparationTimeTemp.value;
      errorTimePreparationText.value = "";
    }
  }

  updateMinutesPreparationTime() {
    if (minutesPreparationTime.value != minutesPreparationTimeTemp.value) {
      minutesPreparationTime.value = minutesPreparationTimeTemp.value;
      errorTimePreparationText.value = "";
    }
  }

  updateHourPreparationTimeTemp(int newValue) {
    if (newValue != hourPreparationTimeTemp.value) {
      hourPreparationTimeTemp.value = newValue;
    }
  }

  updateMinutesPreparationTimeTemp(int newValue) {
    if (newValue != minutesPreparationTimeTemp.value) {
      minutesPreparationTimeTemp.value = newValue;
    }
  }

  updateYieldValueTemp(int newValue) {
    if (newValue != yieldValueTemp.value) {
      yieldValueTemp.value = newValue;
    }
  }

  updateYieldValue() {
    if (yieldValueTemp.value != yieldValue.value) {
      yieldValue.value = yieldValueTemp.value;
      errorYieldText.value = "";
    }
  }

  updateIngOptional() {
    ingOptional.value = !ingOptional.value;
    if (!ingOptional.value) {}
  }

  updateQtdValue(String newValue) {
    int? result = int.tryParse(newValue);

    if (result != null) {
      qtdValue.value = result;
    }
  }

  updateIngredientSelected(Ingredient item) {
    if (ingredientSelected.value.name.toLowerCase().toTitleCase().trim() +
            ingredientSelected.value.plurals
                .toLowerCase()
                .toTitleCase()
                .trim() ==
        item.name.toLowerCase().toTitleCase().trim() +
            item.plurals.toLowerCase().toTitleCase().trim()) return;
    changedIngredientSelected = true;
    if (recipeSelected != null) {
      if (recipeSelected!.ingredientsRevisionError.any((element) =>
          element.name.toLowerCase().toTitleCase().trim() +
              element.plurals.toLowerCase().toTitleCase().trim() ==
          item.name.toLowerCase().toTitleCase().trim() +
              item.plurals.toLowerCase().toTitleCase().trim())) {
        item.hasError = true;
        item.isRevision = false;
      }
      if (recipeSelected!.ingredientsRevision.any((element) =>
          element.name.toLowerCase().toTitleCase().trim() +
              element.plurals.toLowerCase().toTitleCase().trim() ==
          item.name.toLowerCase().toTitleCase().trim() +
              item.plurals.toLowerCase().toTitleCase().trim())) {
        item.isRevision = true;
        item.hasError = false;
      }
    }

    if (item.isRevision) {
      isIngredientRevision = true;
    } else {
      isIngredientRevision = false;
    }
    ingredientSelected.value = item;
  }

  updateMeasureValue(Measure newValue) {
    if (measureSelected.value.name == newValue.name &&
        measureSelected.value.plural == newValue.plural) return;
    if (recipeSelected != null) {
      if (recipeSelected!.measuresRevisionError.any((element) =>
          element.name == newValue.name && element.plural == newValue.plural)) {
        newValue.hasError = true;
      }
    }
    measureSelected.value = newValue;
  }

  updateSubtopicValue(String newText) {
    subtopicValue.value = newText;
  }

  updateSelectedItem(bool value) {
    isSelectedIngredientItem.value = value;
  }

  updateDescriptionValue(String newText) {
    descriptionValue.value = newText;
  }

  addItemListPreparation(PreparationItem item) {
    listPreparations.add(item);
  }

  deletePreparationItem() {
    if (preparationItemSelected != null) {
      var index = listPreparations
          .indexWhere((item) => item.id == preparationItemSelected!.id);
      listPreparations.removeAt(index);
    }
    wipeData();
    wipeSubtopicData();
  }

  initializeDataPreparation(PreparationItem item) {
    updateDescriptionValue(item.description);
    preparationItemSelected = item;
  }

  reorderListPreparations(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final dynamic item = listPreparations.removeAt(oldIndex);
    listPreparations.insert(newIndex, item);
  }

  addIngredientItemSelected(IngredientItem item) {
    item.isSelected = true;

    listItems[listItems.indexWhere((element) {
      if (element is! IngredientItem) {
        return false;
      }
      return element.id == item.id;
    })]
        .isSelected = true;
    listItems.refresh();

    listIngredientsSelected.add(item);
  }

  addIngredientListItemSelected(List<dynamic> itens) {
    var result = [];
    var listFiltred = listItems[listItems.indexWhere((element) {
      if (element is! IngredientItem) {
        return eq(element, itens);
      }
      return false;
    })];
    for (var ingItem in listFiltred) {
      ingItem.isSelected = true;
      result.add(ingItem);
    }
    listIngredientsSelected.add(result);
    listItems.refresh();
  }

  addItemListCategoriesSelected(Categorie item) {
    if (recipeSelected != null) {
      if (recipeSelected!.categoriesRevisionError
          .any((element) => item.name == element.name)) {
        item.hasError = true;
      } else {
        item.hasError = false;
      }
    }
    listCategoriesSelected.add(item);
    errorCategoriesText.value = "";
    listCategoriesSelected.refresh();
  }

  removeItemlistCategoriesSelected(Categorie item) {
    listCategoriesSelected.removeWhere((element) => element.name == item.name);
    listCategoriesSelected.refresh();
  }

  removeIngredientListItemSelected(List<dynamic> itens) {
    var result = [];
    int index = listItems.indexWhere((element) {
      if (element is! IngredientItem) {
        return eq(element, itens);
      }
      return false;
    });
    var listFiltred = listItems[index];
    for (var ingItem in listFiltred) {
      result.add(ingItem);
      ingItem.isSelected = false;
    }
    listIngredientsSelected.removeWhere((item) {
      if (item is! IngredientItem) {
        return eq(item, result);
      }
      return false;
    });

    listItems.refresh();
  }

  removeIngredientItemSelected(IngredientItem item) {
    item.isSelected = false;
    listItems[listItems.indexWhere((element) {
      if (element is! IngredientItem) {
        return false;
      }
      return element.id == item.id;
    })]
        .isSelected = false;
    listItems.refresh();
    listIngredientsSelected.remove(item);
  }

  clearIngredientItemSelected({bool clearListIngredient = true}) {
    for (var item in listIngredientsSelected) {
      if (item is IngredientItem) {
        listItems[listItems.indexWhere((element) {
          if (element is! IngredientItem) {
            return false;
          }
          return element.id == item.id;
        })]
            .isSelected = false;
      } else {
        for (var ingItem in listItems[listItems.indexWhere((element) {
          if (element is! IngredientItem) {
            return eq(element, item);
          }
          return false;
        })]) {
          ingItem.isSelected = false;
        }
      }
    }

    if (clearListIngredient) {
      listIngredientsSelected.clear();
      listItems.refresh();
    }
  }

  ungroupIngredientItens() {
    clearIngredientItemSelected(clearListIngredient: false);
    var listIndexs = [];
    for (var item in listIngredientsSelected) {
      if (item is IngredientItem) {
        var index = listItems.indexWhere((element) {
          if (element is IngredientItem) {
            return element.id == item.id;
          }
          return false;
        });
        listItems.removeAt(index);
        listIndexs.add(index);
      } else {
        var index = listItems.indexWhere((element) {
          if (element is! IngredientItem) {
            return eq(element, item);
          }
          return false;
        });
        listItems.removeAt(index);
        listIndexs.add(index);
      }
    }

    var list = listIngredientsSelected.expand((element) {
      if (element is IngredientItem) {
        return [element];
      }
      return element;
    }).toList();
    var i = 0;
    listIndexs =
        listIndexs.where((element) => element <= listItems.length).toList();
    for (var item in list) {
      if (listIndexs.isEmpty) {
        listItems.add(item);
      } else {
        listItems.insert(listIndexs[0] + i, item);
      }

      i++;
    }
    listIngredientsSelected.clear();
    listItems.refresh();
  }

  joinIngredientItens() {
    var listAux = listIngredientsSelected.expand((element) {
      if (element is IngredientItem) {
        return [element];
      }
      return element;
    }).toList();
    int sizeTrue =
        listAux.where((element) => element.isOptional == true).toList().length;
    int sizeFalse =
        listAux.where((element) => element.isOptional == false).toList().length;
    if ((sizeTrue != listAux.length && sizeFalse != listAux.length)) {
      return "A união entre ingrediente opcionais e não opcionais não pode ser feita";
    }

    if (listAux.length > 3) {
      return "A união só pode ser feita com, no maximo, 3 ingredientes";
    }
    clearIngredientItemSelected(clearListIngredient: false);
    var listIndexs = [];
    for (var item in listIngredientsSelected) {
      if (item is IngredientItem) {
        var index = listItems.indexWhere((element) {
          if (element is IngredientItem) {
            return element.id == item.id;
          }
          return false;
        });
        listItems.removeAt(index);
        listIndexs.add(index);
      } else {
        var index = listItems.indexWhere((element) {
          if (element is! IngredientItem) {
            return eq(element, item);
          }
          return false;
        });
        listItems.removeAt(index);
        listIndexs.add(index);
      }
    }
    var list = listIngredientsSelected.expand((element) {
      if (element is IngredientItem) {
        return [element];
      }
      return element;
    }).toList();
    listIndexs =
        listIndexs.where((element) => element <= listItems.length).toList();
    if (listIndexs.isEmpty) {
      listItems.add(List.from(list));
    } else {
      listItems.insert(listIndexs[0], List.from(list));
    }

    listIngredientsSelected.clear();
  }

  clearErrorText() {
    errorText.value = "";
  }

  reorderListItems(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final dynamic item = listItems.removeAt(oldIndex);
    listItems.insert(newIndex, item);
  }

  validate() {
    if (ingredientSelected.value.name == "") {
      errorText.value = "Selecione um ingrediente";
      return false;
    } else if (qtdValue.value == 0) {
      errorText.value = "Digite um valor para quantidade";
      return false;
    } else if (measureSelected.value.name == "") {
      errorText.value = "Selecione uma medida";
      return false;
    }
    ingredientSelected.value.isRevision = isIngredientRevision;
    if (ingredientItemSelected == null) {
      listItems.add(IngredientItem(
          id: getRandomString(15),
          name: ingredientSelected.value.name,
          format: ingOptional.value ? "a gosto" : formartValue.value,
          isOptional: ingOptional.value,
          measure: Measure.copyWith(measureSelected.value),
          isSubtopic: false,
          isRevision: isIngredientRevision || measureSelected.value.isRevision,
          hasError: ingredientSelected.value.hasError ||
              measureSelected.value.hasError,
          ingredientSelected: ingredientSelected.value,
          isIngredientRevision: isIngredientRevision,
          qtd: qtdValue.value));
    } else {
      var index = listItems
          .indexWhere((element) => element.id == ingredientItemSelected!.id);
      listItems[index] = IngredientItem(
          id: listItems[index].id,
          name: ingredientSelected.value.name,
          format: ingOptional.value ? "a gosto" : formartValue.value,
          isOptional: ingOptional.value,
          measure: Measure.copyWith(measureSelected.value),
          isSubtopic: false,
          ingredientSelected: ingredientSelected.value.plurals == ""
              ? listItems[index].ingredientSelected
              : ingredientSelected.value,
          isRevision: isIngredientRevision || measureSelected.value.isRevision,
          hasError: ingredientSelected.value.hasError ||
              measureSelected.value.hasError,
          isIngredientRevision: isIngredientRevision,
          qtd: qtdValue.value);
    }
    errorIngredientsText.value = "";
    return true;
  }

  validatePreparation() {
    if (preparationItemSelected == null) {
      listPreparations.add(PreparationItem(
          id: getRandomString(15),
          description: descriptionValue.value,
          isSubtopic: false));
    } else {
      listPreparations[listPreparations.indexWhere(
              (element) => element.id == preparationItemSelected!.id)] =
          PreparationItem(
        id: getRandomString(15),
        description: descriptionValue.value,
        isSubtopic: false,
      );
    }
    errorPreparationText.value = "";

    return true;
  }

  addSubtopicToList() {
    if (ingredientItemSelected == null) {
      listItems.add(IngredientItem(
          id: getRandomString(15),
          name: subtopicValue.value,
          format: "",
          isOptional: false,
          ingredientSelected: null,
          measure: Measure.emptyClass(),
          isSubtopic: true,
          qtd: -1));
    } else {
      var index = listItems
          .indexWhere((element) => element.id == ingredientItemSelected!.id);
      listItems[index] = IngredientItem(
          id: listItems[index].id,
          name: subtopicValue.value,
          format: "",
          ingredientSelected: null,
          isOptional: false,
          measure: Measure.emptyClass(),
          isSubtopic: true,
          qtd: -1);
    }
  }

  addSubtopicToListPreparation() {
    if (preparationItemSelected == null) {
      listPreparations.add(PreparationItem(
          id: getRandomString(15),
          description: subtopicValue.value,
          isSubtopic: true));
    } else {
      var index = listPreparations
          .indexWhere((element) => element.id == preparationItemSelected!.id);
      listPreparations[index] = PreparationItem(
          id: listPreparations[index].id,
          description: subtopicValue.value,
          isSubtopic: true);
    }
  }

  initializeData(IngredientItem ingredientItem) {
    updateIngredientSelected(ingredientItem.ingredientSelected!);
    changedIngredientSelected = false;
    updateFormatValue(ingredientItem.format);
    ingOptional.value = ingredientItem.isOptional;
    updateQtdValue(ingredientItem.qtd.toString());
    updateMeasureValue(ingredientItem.measure);
    clearErrorText();
    ingredientItemSelected = ingredientItem;
  }

  initializeSubTopic(IngredientItem ingredientItem) {
    updateSubtopicValue(ingredientItem.name);
    ingredientItemSelected = ingredientItem;
  }

  initializeSubTopicPreparation(PreparationItem preparationItem) {
    updateSubtopicValue(preparationItem.description);
    preparationItemSelected = preparationItem;
  }

  deleteIngredientItem() {
    if (ingredientItemSelected != null) {
      var index =
          listItems.indexWhere((item) => item.id == ingredientItemSelected!.id);
      listItems.removeAt(index);
    }
    wipeData();
    wipeSubtopicData();
  }

  wipeData() {
    updateIngredientSelected(Ingredient.emptyClass());
    updateDescriptionValue("");
    updateFormatValue("");
    ingOptional.value = false;
    updateQtdValue("0");
    updateMeasureValue(Measure.emptyClass());
    clearErrorText();
    ingredientItemSelected = null;
    preparationItemSelected = null;
  }

  wipeSubtopicData() {
    updateSubtopicValue("");
    preparationItemSelected = null;
    ingredientItemSelected = null;
  }

  loadRecipe(Map<String, dynamic> json) {
    Recipe recipe = Recipe.fromJson(json, json["id"]);
    final IngredientController ingredientController = Get.find();
    recipeSelected = Recipe.copyWith(recipe);
    updateRecipeTitle(recipe.title);
    updatePhotoSelected(recipe.imageUrl);
    var d = Duration(minutes: recipe.infos.preparationTime);
    List<String> parts = d.toString().split(':');
    hourPreparationTime.value = int.parse(parts[0]);
    minutesPreparationTime.value = int.parse(parts[1]);
    yieldValue.value = recipe.infos.yieldRecipe;
    var listIngredientsValues = recipe.ingredients;
    var listIngsConverted = [];
    bool isBaseData = false;
    if (recipe.statusRecipe == StatusRevisionRecipe.Checked) {
      recipe.categoriesRevisionError = [];
      recipe.ingredientsRevisionError = [];
      recipe.measuresRevisionError = [];
      recipe.categoriesRevision = [];
      recipe.ingredientsRevision = [];
      recipe.measuresRevision = [];
    }
    if (recipe.ingredients is List<String>) {
      isBaseData = true;
      for (var item in listIngredientsValues) {
        if (item.startsWith("*") && item.endsWith("*")) {
          listIngsConverted.add(IngredientItem(
              name: item.replaceAll("*", ""),
              format: "",
              isOptional: false,
              measure: Measure.emptyClass(),
              isSubtopic: true,
              ingredientSelected: null,
              qtd: -1));
        } else {
          listIngsConverted.add(IngredientItem(
              name: item, //ver isso aqui dps
              format: "",
              isOptional: false,
              ingredientSelected: null,
              measure: Measure.emptyClass(),
              isSubtopic: false,
              qtd: -1));
        }
      }
      listIngredientsValues = listIngsConverted;
    }
    if (recipe.ingredientsRevisionError.isNotEmpty ||
        recipe.measuresRevisionError.isNotEmpty && !isBaseData) {
      List measuresError = recipe.measuresRevisionError;
      List ingsError = recipe.ingredientsRevisionError;

      for (var e in listIngredientsValues) {
        if (e is IngredientItem) {
          var res = measuresError
              .where((p0) =>
                  p0.name == e.measure.name && p0.plural == e.measure.plural)
              .toList();
          var resIng = ingsError
              .where((p0) =>
                  p0.name == e.ingredientSelected!.name &&
                  p0.plurals == e.ingredientSelected!.plurals)
              .toList();
          e.measure.isRevision = false;
          e.measure.hasError = res.isEmpty ? false : true;
          e.hasErrorIngredient = resIng.isEmpty ? false : true;
          e.hasError = e.measure.hasError || e.hasErrorIngredient;
          e.ingredientSelected!.isRevision = false;
          e.ingredientSelected!.hasError = resIng.isEmpty ? false : true;
          e.isRevision = false;
          e.id = getRandomString(15);
        } else {
          for (var rec in e) {
            var res = measuresError
                .where((p0) =>
                    p0.name == rec.measure.name &&
                    p0.plural == rec.measure.plural)
                .toList();
            var resIng = ingsError
                .where((p0) =>
                    p0.name == rec.ingredientSelected!.name &&
                    p0.plurals == rec.ingredientSelected!.plurals)
                .toList();
            rec.isRevision = false;
            rec.measure.hasError = res.isEmpty ? false : true;
            rec.hasErrorIngredient = resIng.isEmpty ? false : true;
            rec.hasError = rec.measure.hasError || rec.hasErrorIngredient;
            rec.measure.isRevision = false;
            rec.ingredientSelected!.isRevision = false;
            rec.ingredientSelected!.hasError = resIng.isEmpty ? false : true;
            rec.id = getRandomString(15);
          }
        }
      }
    }

    if (!isBaseData) {
      var measures = ingredientController.listMeasures;
      var ings = ingredientController.listIngredients;
      for (var e in listIngredientsValues) {
        if (e is IngredientItem) {
          var res = measures
              .where((p0) =>
                  p0.name == e.measure.name && p0.plural == e.measure.plural)
              .toList();
          var resIng = ings
              .where((p0) =>
                  p0.name == e.ingredientSelected!.name &&
                  p0.plurals == e.ingredientSelected!.plurals)
              .toList();
          e.measure.isRevision = res.isNotEmpty ? res.first.isRevision : false;
          e.measure.hasError = e.measure.hasError;
          e.hasErrorIngredient = e.hasErrorIngredient;
          e.hasError = e.hasError;
          e.ingredientSelected!.isRevision =
              resIng.isNotEmpty ? resIng.first.isRevision : true;
          e.ingredientSelected!.hasError = e.ingredientSelected!.hasError;

          e.isIngredientRevision =
              resIng.isNotEmpty ? resIng.first.isRevision : true;

          e.isRevision = e.measure.isRevision || e.isIngredientRevision;
          e.id = getRandomString(15);
        } else {
          for (var rec in e) {
            var res = measures
                .where((p0) =>
                    p0.name == rec.measure.name &&
                    p0.plural == rec.measure.plural)
                .toList();
            var resIng = ings
                .where((p0) =>
                    p0.name == rec.ingredientSelected!.name &&
                    p0.plurals == rec.ingredientSelected!.plurals)
                .toList();

            rec.measure.isRevision =
                res.isNotEmpty ? res.first.isRevision : false;
            rec.measure.hasError = rec.measure.hasError;
            rec.hasErrorIngredient = rec.hasErrorIngredient;
            rec.hasError = rec.hasError;
            rec.ingredientSelected!.isRevision =
                resIng.isNotEmpty ? resIng.first.isRevision : true;
            rec.ingredientSelected!.hasError = rec.ingredientSelected!.hasError;
            rec.isIngredientRevision =
                resIng.isNotEmpty ? resIng.first.isRevision : true;
            rec.isRevision = rec.measure.isRevision || rec.isIngredientRevision;
            rec.id = getRandomString(15);
          }
        }
      }
    }
    listItems.assignAll(listIngredientsValues);
    var listPreparationsValues = recipe.preparation;
    var listPreparationConverted = [];
    if (recipe.preparation[0] is String) {
      for (var item in listPreparationsValues) {
        if (item.toString().startsWith("*") && item.toString().endsWith("*")) {
          listPreparationConverted.add(PreparationItem(
              description: item.replaceAll("*", ""), isSubtopic: true));
        } else {
          listPreparationConverted.add(PreparationItem(
            description: item,
            isSubtopic: false,
          ));
        }
      }
      listPreparationsValues = listPreparationConverted;
    }
    for (var e in listPreparationsValues) {
      e.id = getRandomString(15);
    }

    listPreparations.assignAll(listPreparationsValues);

    var categories = ingredientController.listCategories;

    if (recipe.categoriesRevisionError.isNotEmpty) {
      var categoriesError = recipe.categoriesRevisionError;
      listCategoriesSelected.assignAll(recipe.categories.map<Categorie>((e) {
        var cat = categories.where((p0) => p0.name == e.toString()).toList();
        if (cat.isEmpty) {
          var res = categoriesError
              .where((element) => e.toString() == element.name)
              .first;

          res.hasError = true;
          res.isRevision = false;
          return res;
        } else {
          return cat.first;
        }
      }));
    } else {
      var x = recipe.categories.map<Categorie>((e) {
        var cats = categories.where((p0) => p0.name == e.toString());
        if (cats.isNotEmpty) {
          return categories.where((p0) => p0.name == e.toString()).first;
        }
        return Categorie(
            id: e.toString().toLowerCase().toTitleCase().replaceAll(" ", ""),
            name: e.toString(),
            hasError: true);
      }).toList();
      listCategoriesSelected.assignAll(x);
    }
  }

  validateRecipe() {
    var res = true;
    if (photoSelected.value == "") {
      errorimageText.value = "Selecione uma foto.";
      res = false;
    }
    if (yieldValue.value == 0) {
      errorYieldText.value = "Selecione a porção.";
      res = false;
    }
    if (hourPreparationTime.value == 0 && minutesPreparationTime.value == 0) {
      errorTimePreparationText.value = "Selecione tempo de preparo.";
      res = false;
    }
    if (listItems
        .where((p0) {
          if (p0 is IngredientItem) {
            return p0.isSubtopic == false;
          }
          return true;
        })
        .toList()
        .isEmpty) {
      errorIngredientsText.value = "Adicione pelo menos um ingrediente.";
      res = false;
    }
    if (listPreparations
        .where((p0) => p0.isSubtopic == false)
        .toList()
        .isEmpty) {
      errorPreparationText.value = "Adicione pelo menos uma preparação.";
      res = false;
    }
    if (listCategoriesSelected.length < 3) {
      errorCategoriesText.value = "Adicione pelo menos 3 categorias.";
      res = false;
    }

    return res;
  }

  clearErrors() {
    errorimageText.value = "";
    errorYieldText.value = "";
    errorTimePreparationText.value = "";
    errorIngredientsText.value = "";
    errorPreparationText.value = "";
    errorPreparationText.value = "";
  }

  updateRecipe({bool confirmed = false}) async {
    isLoading.value = true;
    isLoadingConfirm.value = confirmed;
    List<Ingredient> ingredientsRevision = [];
    List<Ingredient> ingredientsError = [];
    List<Measure> measuresRevision = [];
    List<Measure> measuresError = [];
    for (var element in listItems) {
      if (element is IngredientItem) {
        if (element.ingredientSelected!.isRevision) {
          ingredientsRevision.add(element.ingredientSelected!);
        }
        if (element.ingredientSelected!.hasError) {
          ingredientsError.add(element.ingredientSelected!);
        }

        if (element.measure.isRevision) {
          measuresRevision.add(element.measure);
        }
        if (element.measure.hasError) {
          measuresError.add(element.measure);
        }
      } else {
        element.forEach((element) {
          if (element is IngredientItem) {
            if (element.ingredientSelected!.isRevision) {
              ingredientsRevision.add(element.ingredientSelected!);
            }
            if (element.ingredientSelected!.hasError) {
              ingredientsError.add(element.ingredientSelected!);
            }
            if (element.measure.isRevision) {
              measuresRevision.add(element.measure);
            }
            if (element.measure.hasError) {
              measuresError.add(element.measure);
            }
          }
        });
      }
    }
    List<Ingredient> ingredientsRevisionUpdated =
        await FirebaseBaseHelper.loadIngredientsRevisionByUser(
            userController.currentUser.value);
    List<Measure> measureRevisionUpdated =
        await FirebaseBaseHelper.loadMeasureRevisionByUser(
            userController.currentUser.value);
    List<Categorie> categorieRevisionUpdated =
        await FirebaseBaseHelper.loadCategorieRevisionByUser(
            userController.currentUser.value);
    var ingredientsCheckedUpdated = await FirebaseBaseHelper.getIngredients();
    var measuresCheckedUpdated = await FirebaseBaseHelper.getMeasures();
    var categoriesCheckedUpdated = await FirebaseBaseHelper.getCategories();

    bool hasChanges = false;

    for (var ingRevision in List.from(ingredientsRevision)) {
      if (ingredientsRevisionUpdated
          .where((element) =>
              element.name == ingRevision.name &&
              element.plurals == ingRevision.plurals)
          .toList()
          .isEmpty) {
        ingredientsRevision.remove(ingRevision);
        hasChanges = true;
        if (ingredientsCheckedUpdated
            .where((element) =>
                element.name == ingRevision.name &&
                element.plurals == ingRevision.plurals)
            .toList()
            .isNotEmpty) {
          ingRevision.hasError = false;
          ingRevision.isRevision = false;
        } else {
          ingRevision.isRevision = false;
          ingRevision.hasError = true;
          ingredientsError.add(ingRevision);
        }
      }
    }
    for (var measureRevision in List.from(measuresRevision)) {
      if (measureRevisionUpdated
          .where((element) =>
              element.name == measureRevision.name &&
              element.plural == measureRevision.plural)
          .toList()
          .isEmpty) {
        measuresRevision.remove(measureRevision);
        hasChanges = true;
        if (measuresCheckedUpdated
            .where((element) =>
                element.name == measureRevision.name &&
                element.plural == measureRevision.plural)
            .toList()
            .isNotEmpty) {
          measureRevision.hasError = false;
          measureRevision.isRevision = false;
        } else {
          measureRevision.isRevision = false;
          measureRevision.hasError = true;
          measuresError.add(measureRevision);
        }
      }
    }
    for (var categorieRevision
        in listCategoriesSelected.where((p0) => p0.isRevision == true)) {
      if (categorieRevisionUpdated
          .where((element) => element.name == categorieRevision.name)
          .toList()
          .isEmpty) {
        //measuresRevision.remove(measureRevision);
        hasChanges = true;
        if (categoriesCheckedUpdated
            .where((element) => element.name == categorieRevision.name)
            .toList()
            .isNotEmpty) {
          categorieRevision.hasError = false;
          categorieRevision.isRevision = false;
        } else {
          categorieRevision.isRevision = false;
          categorieRevision.hasError = true;
          // measuresError.add(measureRevision);
        }
      }
    }
    if (hasChanges) {
      for (int i = 0; i < listItems.length; i++) {
        var element = listItems[i];
        if (element is IngredientItem) {
          var ingName = element.ingredientSelected!.name;
          var ingPlural = element.ingredientSelected!.plurals;
          var measureName = element.measure.name;
          var measurePlural = element.measure.plural;
          bool hasIngError = ingredientsError
              .where((element) =>
                  element.name == ingName && element.plurals == ingPlural)
              .toList()
              .isNotEmpty;
          bool hasIngRevision = ingredientsRevision
              .where((element) =>
                  element.name == ingName && element.plurals == ingPlural)
              .toList()
              .isNotEmpty;
          bool hasMeasureError = measuresError
              .where((element) =>
                  element.name == measureName &&
                  element.plural == measurePlural)
              .toList()
              .isNotEmpty;
          bool hasMeasureRevision = measuresRevision
              .where((element) =>
                  element.name == measureName &&
                  element.plural == measurePlural)
              .toList()
              .isNotEmpty;
          element.isRevision = hasIngRevision || hasMeasureRevision;
          element.hasError = hasIngError || hasMeasureError;
          element.isIngredientRevision = hasIngRevision;
          element.hasErrorIngredient = hasIngError;
          element.measure.isRevision = hasMeasureRevision;
          element.measure.hasError = hasMeasureError;
          element.ingredientSelected!.isRevision = hasIngRevision;
          element.ingredientSelected!.hasError = hasIngError;
        } else {
          element.forEach((element) {
            if (element is IngredientItem) {
              var ingName = element.ingredientSelected!.name;
              var ingPlural = element.ingredientSelected!.plurals;
              var measureName = element.measure.name;
              var measurePlural = element.measure.plural;
              bool hasIngError = ingredientsError
                  .where((element) =>
                      element.name == ingName && element.plurals == ingPlural)
                  .toList()
                  .isNotEmpty;
              bool hasIngRevision = ingredientsRevision
                  .where((element) =>
                      element.name == ingName && element.plurals == ingPlural)
                  .toList()
                  .isNotEmpty;
              bool hasMeasureError = measuresError
                  .where((element) =>
                      element.name == measureName &&
                      element.plural == measurePlural)
                  .toList()
                  .isNotEmpty;
              bool hasMeasureRevision = measuresRevision
                  .where((element) =>
                      element.name == measureName &&
                      element.plural == measurePlural)
                  .toList()
                  .isNotEmpty;
              element.isRevision = hasIngRevision || hasMeasureRevision;
              element.hasError = hasIngError || hasMeasureError;
              element.isIngredientRevision = hasIngRevision;
              element.hasErrorIngredient = hasIngError;
              element.measure.isRevision = hasMeasureRevision;
              element.measure.hasError = hasMeasureError;
              element.ingredientSelected!.isRevision = hasIngRevision;
              element.ingredientSelected!.hasError = hasIngError;
            }
          });
        }
      }
      listItems.refresh();
      listCategoriesSelected.refresh();

      recipeSelected!.statusRecipe = listItems.any((element) {
                if (element is IngredientItem) {
                  return element.hasError == true;
                } else {
                  return element.any((e) => e.hasError == true);
                }
              }) ||
              listCategoriesSelected.any((element) => element.hasError == true)
          ? StatusRevisionRecipe.Error
          : listItems.any((element) {
                    if (element is IngredientItem) {
                      return element.isRevision == true;
                    } else {
                      return element.any((e) => e.isRevision == true);
                    }
                  }) ||
                  listCategoriesSelected
                      .any((element) => element.isRevision == true)
              ? StatusRevisionRecipe.Revision
              : StatusRevisionRecipe.Checked;
      isLoading.value = false;
      isLoadingConfirm.value = false;

      return "Houve atualizações na sua receita, verifique e atualize sua receita novamente";
    }
    List<Categorie> categorieError = List<Categorie>.from(
            listCategoriesSelected.where((element) => element.hasError == true))
        .toList();
    if (measuresError.isNotEmpty ||
        categorieError.isNotEmpty ||
        ingredientsError.isNotEmpty) {
      isLoading.value = false;
      return "Há erros a serem corrigidos, verifique sua receita.";
    }
    var listItemsFiltred = listItems.where((element) {
      if (element is IngredientItem) {
        if (!element.isSubtopic) {
          return true;
        } else {
          return false;
        }
      }
      return true;
    }).toList();
    var valuesIngredientsList = listItemsFiltred.map((element) {
      if (element is IngredientItem) {
        return [element.name.toString()];
      } else {
        List<String> x =
            element.map<String>((e) => e.name.toString()).toSet().toList();
        return x;
      }
    }).toList();

    var combinations =
        PermutationAlgorithmStrings(valuesIngredientsList).permutations();
    combinations = combinations
        .map((e) => LinkedHashSet<String>.from(e).toList())
        .toList();

    Set<int> sizes = {};
    for (var item in combinations) {
      sizes.add(item.length);
    }
    var combinationsString = combinations.map((e) {
      e.sort();
      return e.join(";;");
    }).toList();
    ingredientsRevision = ingredientsRevision.distinctBy((d) => d.id).toList();
    measuresRevision =
        measuresRevision.distinctBy((d) => d.toString()).toList();

    Recipe recipe = Recipe(
        id: recipeSelected!.id,
        title: recipeTitle.value,
        infos: Info(
            yieldRecipe: yieldValue.value,
            preparationTime: Duration(
                    hours: hourPreparationTime.value,
                    minutes: minutesPreparationTime.value)
                .inMinutes),
        ingredients: listItems,
        preparation: listPreparations,
        url: recipeSelected!.url,
        imageUrl: photoSelected.value,
        likes: recipeSelected!.likes,
        sizes: sizes.toList(),
        values: combinationsString,
        views: recipeSelected!.views,
        missingIngredient: recipeSelected!.missingIngredient,
        userInfo: UserInfo(
            idUser: userController.currentUser.value.id,
            name: userController.currentUser.value.name,
            imageUrl: userController.currentUser.value.image,
            followers: userController.currentUser.value.followers),
        favorites: recipeSelected!.favorites,
        categories: listCategoriesSelected
            .map((element) => element.name.toString())
            .toList(),
        createdOn: recipeSelected!.createdOn,
        updatedOn: Timestamp.now(),
        categoriesRevision: List<Categorie>.from(listCategoriesSelected
            .where((element) => element.isRevision == true)
            .toSet()
            .toList()),
        ingredientsRevision: ingredientsRevision,
        measuresRevision: measuresRevision,
        categoriesRevisionError: const [],
        categoriesRevisionSuccessfully: const [],
        ingredientsRevisionError: const [],
        ingredientsRevisionSuccessfully: const [],
        measuresRevisionError: const [],
        statusRecipe: recipeSelected!.statusRecipe,
        measuresRevisionSuccessfully: const []);
    var newStatusRecipe = listItems.any((element) {
              if (element is IngredientItem) {
                return element.hasError == true;
              } else {
                return element.any((e) => e.hasError == true);
              }
            }) ||
            listCategoriesSelected.any((element) => element.hasError == true)
        ? StatusRevisionRecipe.Error
        : listItems.any((element) {
                  if (element is IngredientItem) {
                    return element.isRevision == true;
                  } else {
                    return element.any((e) => e.isRevision == true);
                  }
                }) ||
                listCategoriesSelected
                    .any((element) => element.isRevision == true)
            ? StatusRevisionRecipe.Revision
            : StatusRevisionRecipe.Checked;
    if (newStatusRecipe == StatusRevisionRecipe.Revision && !confirmed) {
      isLoading.value = false;
      return "confirm";
    }
    var isRevisionChange = false;
    if (recipeSelected!.statusRecipe == StatusRevisionRecipe.Error &&
        newStatusRecipe == StatusRevisionRecipe.Revision) {
      isRevisionChange = false;
    } else {
      isRevisionChange =
          recipeSelected!.statusRecipe == newStatusRecipe ? false : true;
    }
    var result = await FirebaseBaseHelper.updateRecipe(
        recipe, userController.currentUser.value,
        isRevisionChange: isRevisionChange,
        isRevision:
            recipe.statusRecipe != StatusRevisionRecipe.Checked ? true : false);
    isLoading.value = false;
    if (result == "") {
      return "";
    } else {
      return result;
    }

    // for (var x in recipe.ingredients) {}
  }

  sendRecipe({bool confirmed = false}) async {
    isLoading.value = true;
    isLoadingConfirm.value = confirmed;
    var listItemsFiltred = listItems.where((element) {
      if (element is IngredientItem) {
        if (!element.isSubtopic) {
          return true;
        } else {
          return false;
        }
      }
      return true;
    }).toList();
    var valuesIngredientsList = listItemsFiltred.map((element) {
      if (element is IngredientItem) {
        return [element.name.toString()];
      } else {
        List<String> x = element.map<String>((e) => e.name.toString()).toList();
        return x;
      }
    }).toList();

    var combinations =
        PermutationAlgorithmStrings(valuesIngredientsList).permutations();
    combinations = combinations
        .map((e) => LinkedHashSet<String>.from(e).toList())
        .toList();
    Set<int> sizes = {};
    for (var item in combinations) {
      sizes.add(item.length);
    }
    var combinationsString = combinations.map((e) {
      e.sort();
      return e.join(";;");
    }).toList();
    List<Measure> measuresRevision = [];
    List<Ingredient> ingredientsRevision = [];
    for (var element in listItems) {
      if (element is IngredientItem) {
        if (element.ingredientSelected!.isRevision) {
          ingredientsRevision.add(element.ingredientSelected!);
        }
        if (element.measure.isRevision) {
          measuresRevision.add(element.measure);
        }
      } else {
        element.forEach((element) {
          if (element is IngredientItem) {
            if (element.ingredientSelected!.isRevision) {
              ingredientsRevision.add(element.ingredientSelected!);
            }
            if (element.measure.isRevision) {
              measuresRevision.add(element.measure);
            }
          }
        });
      }
    }
    var isRevision = listItems.any((element) {
              if (element is IngredientItem) {
                return element.isRevision == true;
              } else {
                return element.any((e) => e.isRevision == true);
              }
            }) ||
            listCategoriesSelected.any((element) => element.isRevision == true)
        ? StatusRevisionRecipe.Revision
        : StatusRevisionRecipe.Checked;
    ingredientsRevision = ingredientsRevision.distinctBy((d) => d.id).toList();
    measuresRevision =
        measuresRevision.distinctBy((d) => d.toString()).toList();
    Recipe recipe = Recipe(
      id: "",
      title: recipeTitle.value,
      infos: Info(
          yieldRecipe: yieldValue.value,
          preparationTime: Duration(
                  hours: hourPreparationTime.value,
                  minutes: minutesPreparationTime.value)
              .inMinutes),
      ingredients: listItems,
      preparation: listPreparations,
      url: "",
      likes: 0,
      imageUrl: photoSelected.value,
      sizes: sizes.toList(),
      values: combinationsString,
      views: 0,
      missingIngredient: "",
      userInfo: UserInfo(
          idUser: userController.currentUser.value.id,
          name: userController.currentUser.value.name,
          imageUrl: userController.currentUser.value.image,
          followers: userController.currentUser.value.followers),
      favorites: 0,
      categories: listCategoriesSelected
          .map((element) => element.name.toString())
          .toList(),
      createdOn: Timestamp.now(),
      updatedOn: Timestamp.now(),
      categoriesRevision: List<Categorie>.from(listCategoriesSelected
          .where((element) => element.isRevision == true)),
      ingredientsRevision: ingredientsRevision,
      measuresRevision: measuresRevision,
      categoriesRevisionError: const [],
      categoriesRevisionSuccessfully: const [],
      ingredientsRevisionError: const [],
      measuresRevisionError: const [],
      ingredientsRevisionSuccessfully: const [],
      measuresRevisionSuccessfully: const [],
      statusRecipe: isRevision,
    );

    if (isRevision == StatusRevisionRecipe.Revision && !confirmed) {
      isLoading.value = false;
      return "confirm";
    }
    var result = await FirebaseBaseHelper.addRecipe(
        recipe, userController.currentUser.value,
        isRevision: isRevision == StatusRevisionRecipe.Revision ? true : false);
    isLoading.value = false;
    isLoadingConfirm.value = false;
    if (result == "") {
      return "";
    } else {
      return result;
    }

    // for (var x in recipe.ingredients) {}
  }

  generateRecipe() {
    return Recipe(
      id: "",
      title: recipeTitle.value,
      infos: Info(
          yieldRecipe: yieldValue.value,
          preparationTime: Duration(
                  hours: hourPreparationTime.value,
                  minutes: minutesPreparationTime.value)
              .inMinutes),
      ingredients: listItems,
      preparation: listPreparations,
      url: "",
      likes: 0,
      imageUrl: photoSelected.value,
      sizes: const [],
      values: const [],
      views: 0,
      missingIngredient: "",
      userInfo: UserInfo(
          idUser: userController.currentUser.value.id,
          name: userController.currentUser.value.name,
          imageUrl: userController.currentUser.value.image,
          followers: userController.currentUser.value.followers),
      favorites: 0,
      categories: listCategoriesSelected
          .map((element) => element.name.toString())
          .toList(),
      createdOn: Timestamp.now(),
      updatedOn: Timestamp.now(),
      categoriesRevision: const [],
      ingredientsRevision: const [],
      measuresRevision: const [],
      categoriesRevisionError: const [],
      categoriesRevisionSuccessfully: const [],
      ingredientsRevisionError: const [],
      measuresRevisionError: const [],
      ingredientsRevisionSuccessfully: const [],
      measuresRevisionSuccessfully: const [],
    );
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<T> distinctBy(Object Function(T e) getCompareValue) {
    var result = <T>[];
    for (var element in this) {
      if (!result.any((x) => getCompareValue(x) == getCompareValue(element))) {
        result.add(element);
      }
    }

    return result;
  }
}
