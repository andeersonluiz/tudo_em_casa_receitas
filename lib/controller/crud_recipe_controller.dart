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
  Rx<Measure> measureSelected = Measure(name: "", plural: "").obs;

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

  updateIngredientSelected(Ingredient item) {
    changedIngredientSelected = true;
    print("ab");
    if (item.isRevision) {
      isIngredientRevision = true;
    } else {
      isIngredientRevision = false;
    }
    ingredientSelected.value = item;
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

  updateMeasureValue(Measure newValue) {
    print(" antes ${measureSelected.value} update measure $newValue");
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

  initalizeDataPreparation(PreparationItem item) {
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
    print("ooooi");
    print(item.name);
    print(item.isRevision);
    listCategoriesSelected.add(item);
    errorCategoriesText.value = "";
    listCategoriesSelected.refresh();
  }

  removeItemlistCategoriesSelected(Categorie item) {
    print("ooooi2");
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
          isRevision: isIngredientRevision || measureSelected.value.isRevision
              ? true
              : false,
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
          isRevision: isIngredientRevision || measureSelected.value.isRevision
              ? true
              : false,
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
          measure: Measure(name: "", plural: ""),
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
          measure: Measure(name: "", plural: ""),
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
    print("cucucu ${ingredientItem.measure}");
    //print()
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
    updateMeasureValue(Measure(name: "", plural: ""));
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

    print("aaxxx");
    updateRecipeTitle(recipe.title);
    updatePhotoSelected(recipe.imageUrl);
    print("loading recipes ${recipeSelected!.statusRecipe}");
    var d = Duration(minutes: recipe.infos.preparationTime);
    List<String> parts = d.toString().split(':');
    hourPreparationTime.value = int.parse(parts[0]);
    minutesPreparationTime.value = int.parse(parts[1]);
    yieldValue.value = recipe.infos.yieldRecipe;
    var listIngredientsValues = recipe.ingredients;
    var listPreparationsValues = recipe.preparation;
    var listIngsConverted = [];
    var listPreparationConverted = [];
    if (recipe.ingredients is List<String>) {
      for (var item in listIngredientsValues) {
        if (item.startsWith("*") && item.endsWith("*")) {
          listIngsConverted.add(IngredientItem(
              name: item.replaceAll("*", ""),
              format: "",
              isOptional: false,
              measure: Measure(name: "", plural: ""),
              isSubtopic: true,
              ingredientSelected: null,
              qtd: -1));
        } else {
          listIngsConverted.add(IngredientItem(
              name: item, //ver isso aqui dps
              format: "",
              isOptional: false,
              ingredientSelected: null,
              measure: Measure(name: "", plural: ""),
              isSubtopic: false,
              qtd: -1));
        }
      }
      listIngredientsValues = listIngsConverted;
    }

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
        e.measure.isRevision = res.first.isRevision;
        e.ingredientSelected!.isRevision = resIng.first.isRevision;
        e.isRevision = e.isIngredientRevision || e.measure.isRevision;
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
          rec.isRevision = rec.isIngredientRevision || rec.measure.isRevision;
          rec.measure.isRevision = res.first.isRevision;
          rec.ingredientSelected!.isRevision = resIng.first.isRevision;
          rec.id = getRandomString(15);
        }
      }
    }
    print("Popop");

    listItems.assignAll(listIngredientsValues);
    print("Popop2");
    print(listItems);
    print(recipe.preparation[0].runtimeType);
    if (recipe.preparation[0] is String) {
      for (var item in listPreparationsValues) {
        print(item);
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
    listCategoriesSelected.assignAll(recipe.categories.map<Categorie>(
        (e) => categories.firstWhere((p0) => p0.name == e.toString())));
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
    print("ooooi4");
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

  updateRecipe({bool confimed = false}) async {
    isLoading.value = true;
    print(ingredientSelected.value.plurals);
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
    print("coco");
    print(listCategoriesSelected);
    print(List<Categorie>.from(
        listCategoriesSelected.where((element) => element.isRevision == true)));
    print(combinations);
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
    ingredientsRevision = ingredientsRevision.distinctBy((d) => d.id).toList();
    measuresRevision =
        measuresRevision.distinctBy((d) => d.toString()).toList();
    //ADICIONAR USERINFO PARA EXIBIR IMAGEM NA RECEITA
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
        categoriesRevisionError: [],
        categoriesRevisionSuccessfully: [],
        ingredientsRevisionError: [],
        ingredientsRevisionSuccessfully: [],
        measuresRevisionError: [],
        statusRecipe: recipeSelected!.statusRecipe,
        measuresRevisionSuccessfully: []);
    var isRevision = listItems.any((element) {
              if (element is IngredientItem) {
                print("element $element");
                return element.isRevision == true;
              } else {
                return element.any((e) => e.isRevision == true);
              }
            }) ||
            listCategoriesSelected.any((element) => element.isRevision == true)
        ? StatusRevisionRecipe.Revision
        : StatusRevisionRecipe.Checked;

    print(recipe.statusRecipe);
    if (isRevision == StatusRevisionRecipe.Revision && !confimed) {
      isLoading.value = false;
      return "confirm";
    }

    var result = await FirebaseBaseHelper.updateRecipe(
        recipe, userController.currentUser.value,
        isRevisionChange:
            recipeSelected!.statusRecipe == isRevision ? false : true,
        isRevision: recipe.statusRecipe == StatusRevisionRecipe.Revision
            ? true
            : false);
    isLoading.value = false;
    if (result == "") {
      return "";
    } else {
      return result;
    }

    // for (var x in recipe.ingredients) {}
  }

  sendRecipe({bool confimed = false}) async {
    isLoading.value = true;
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
    print("coco");
    print(List<Categorie>.from(
        listCategoriesSelected.where((element) => element.isRevision == true)));
    var isRevision = listItems.any((element) {
              if (element is IngredientItem) {
                print("element $element");
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
      categoriesRevisionError: [],
      categoriesRevisionSuccessfully: [],
      ingredientsRevisionError: [],
      measuresRevisionError: [],
      ingredientsRevisionSuccessfully: [],
      measuresRevisionSuccessfully: [],
      statusRecipe: isRevision,
    );

    if (isRevision == StatusRevisionRecipe.Revision && !confimed) {
      isLoading.value = false;
      return "confirm";
    }
    var result = await FirebaseBaseHelper.addRecipe(
        recipe, userController.currentUser.value,
        isRevision: isRevision == StatusRevisionRecipe.Revision ? true : false);
    isLoading.value = false;
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
      sizes: [],
      values: [],
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
      categoriesRevision: [],
      ingredientsRevision: [],
      measuresRevision: [],
      categoriesRevisionError: [],
      categoriesRevisionSuccessfully: [],
      ingredientsRevisionError: [],
      measuresRevisionError: [],
      ingredientsRevisionSuccessfully: [],
      measuresRevisionSuccessfully: [],
    );
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<T> distinctBy(Object getCompareValue(T e)) {
    var result = <T>[];
    this.forEach((element) {
      if (!result.any((x) => getCompareValue(x) == getCompareValue(element)))
        result.add(element);
    });

    return result;
  }
}
