import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
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
    if (ingredientItemSelected == null) {
      listItems.add(IngredientItem(
          id: getRandomString(15),
          name: ingredientSelected.value.name,
          format: ingOptional.value ? "a gosto" : formartValue.value,
          isOptional: ingOptional.value,
          measure: measureSelected.value,
          isSubtopic: false,
          isRevision: isIngredientRevision || measureSelected.value.isRevision
              ? true
              : false,
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
          measure: measureSelected.value,
          isSubtopic: false,
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
    updateIngredientSelected(Ingredient.emptyClass(
      name: ingredientItem.name,
      isRevision: ingredientItem.isIngredientRevision,
    ));
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
    recipeSelected = recipe;
    updateRecipeTitle(recipe.title);
    updatePhotoSelected(recipe.imageUrl);
    print("loading recipes");
    var d = Duration(minutes: recipe.infos.preparationTime);
    List<String> parts = d.toString().split(':');
    hourPreparationTime.value = int.parse(parts[0]);
    minutesPreparationTime.value = int.parse(parts[1]);
    yieldValue.value = recipe.infos.yieldRecipe;
    for (var e in recipe.ingredients) {
      if (e is IngredientItem) {
        e.id = getRandomString(15);
      } else {
        for (var rec in e) {
          rec.id = getRandomString(15);
        }
      }
    }
    listItems.assignAll(recipe.ingredients);
    for (var e in recipe.preparation) {
      e.id = getRandomString(15);
    }
    listPreparations.assignAll(recipe.preparation);
    listCategoriesSelected
        .assignAll(recipe.categories.map((e) => Categorie(name: e.toString())));
    //for (var x in recipe.ingredients) {}//TERMINAR O RESTO DPS DE ADICIONAR
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

  updateRecipe({bool confimed = false}) async {
    isLoading.value = true;
    var valuesIngredientsList = listItems.map((element) {
      if (element is IngredientItem) {
        return [element.name.toString()];
      } else {
        List<String> x = element.map<String>((e) => e.name.toString()).toList();
        return x;
      }
    }).toList();

    var combinations =
        PermutationAlgorithmStrings(valuesIngredientsList).permutations();
    Set<int> sizes = {};
    for (var item in combinations) {
      sizes.add(item.length);
    }
    var combinationsString = combinations.map((e) {
      e.sort();
      return e.join(";;");
    }).toList();

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
        updatedOn: Timestamp.now());
    var isRevision = listItems.any((element) {
          if (element is IngredientItem) {
            return element.isRevision == true;
          } else {
            return element.any((e) => e.isRevision == true);
          }
        }) ||
        listCategoriesSelected.any((element) => element.isRevision == true);
    if (isRevision && !confimed) {
      return "confirm";
    }
    var result = await FirebaseBaseHelper.updateRecipe(
        recipe, userController.currentUser.value,
        isRevisionChange:
            recipeSelected!.isRevision == isRevision ? false : true,
        isRevision: isRevision);
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
    var valuesIngredientsList = listItems.map((element) {
      if (element is IngredientItem) {
        return [element.name.toString()];
      } else {
        List<String> x = element.map<String>((e) => e.name.toString()).toList();
        return x;
      }
    }).toList();

    var combinations =
        PermutationAlgorithmStrings(valuesIngredientsList).permutations();
    Set<int> sizes = {};
    for (var item in combinations) {
      sizes.add(item.length);
    }
    var combinationsString = combinations.map((e) {
      e.sort();
      return e.join(";;");
    }).toList();

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
        updatedOn: Timestamp.now());
    var isRevision = listItems.any((element) {
          if (element is IngredientItem) {
            return element.isRevision == true;
          } else {
            return element.any((e) => e.isRevision == true);
          }
        }) ||
        listCategoriesSelected.any((element) => element.isRevision == true);
    if (isRevision && !confimed) {
      return "confirm";
    }
    var result = await FirebaseBaseHelper.addRecipe(
        recipe, userController.currentUser.value,
        isRevision: isRevision);
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
        updatedOn: Timestamp.now());
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
