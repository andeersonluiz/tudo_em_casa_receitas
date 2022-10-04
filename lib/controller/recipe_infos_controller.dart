import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_item.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/model/preparation_item.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';

class RecipeInfosController extends FullLifeCycleController
    with FullLifeCycleMixin {
  var listIngredients = [].obs;
  var listPreparations = [].obs;
  Rx<Recipe?> recipeSelected = Rxn<Recipe>();
  Recipe initalRecipe = Recipe.empty();
  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  Function eq = const ListEquality().equals;
  var isLiked = false.obs;
  UserController userController = Get.find();

  @override
  void onInit() {
    print("reiniciei");
    super.onInit();
  }

  loadData(Recipe recipe) {
    if (userController.currentUser.value.recipeLikes.contains(recipe.id)) {
      isLiked.value = true;
    }
    recipeSelected.value = Recipe.copyWith(recipe);
    initalRecipe = Recipe.copyWith(recipe);

    print("a ${recipeSelected.value}");
    for (var e in recipe.ingredients) {
      if (e is IngredientItem) {
        e.id = getRandomString(15);
      } else {
        for (var rec in e) {
          rec.id = getRandomString(15);
        }
      }
    }
    for (var e in recipe.preparation) {
      e.id = getRandomString(15);
    }
    var ingredientsFinal = [];
    var preparationsFinal = [];

    var result = recipe.ingredients.map((e) {
      if (e is IngredientItem && e.isSubtopic) {
        return recipe.ingredients.indexWhere((element) => element == e);
      }
    }).toList();

    var resultPrep = recipe.preparation.map((e) {
      if (e is PreparationItem && e.isSubtopic) {
        return recipe.preparation.indexWhere((element) => element == e);
      }
    }).toList();

    var values = [];
    var valuesPrep = [];

    final List<int> listIdsSubTopic = result.whereType<int>().toList();
    final List<int> listIdsSubTopicPrep = resultPrep.whereType<int>().toList();

    if (listIdsSubTopic.isEmpty) {
      ingredientsFinal = recipe.ingredients;
    } else {
      for (int i = 0; i < listIdsSubTopic.length; i++) {
        var item = listIdsSubTopic[i];
        if (i == listIdsSubTopic.length - 1) {
          values.add([
            recipe.ingredients[item],
            recipe.ingredients
                .sublist(listIdsSubTopic[i] + 1, recipe.ingredients.length),
          ]);
        } else {
          values.add([
            recipe.ingredients[item],
            recipe.ingredients.sublist(
              listIdsSubTopic[i] + 1,
              listIdsSubTopic[i + 1],
            ),
          ]);
        }
      }

      if (listIdsSubTopic[0] != 0) {
        var listFirst = recipe.ingredients.sublist(0, listIdsSubTopic[0]);
        for (var item in listFirst.reversed) {
          values.insert(
            0,
            item,
          );
        }
      }
      ingredientsFinal = values;
    }

    if (listIdsSubTopicPrep.isEmpty) {
      preparationsFinal = recipe.preparation;
    } else {
      for (int i = 0; i < listIdsSubTopicPrep.length; i++) {
        var item = listIdsSubTopicPrep[i];
        if (i == listIdsSubTopicPrep.length - 1) {
          valuesPrep.add([
            recipe.preparation[item],
            recipe.preparation.sublist(item + 1, recipe.preparation.length),
          ]);
        } else {
          valuesPrep.add([
            recipe.preparation[item],
            recipe.preparation.sublist(
              item + 1,
              listIdsSubTopicPrep[i + 1],
            ),
          ]);
        }
      }

      if (listIdsSubTopicPrep[0] != 0) {
        var listFirst = recipe.preparation.sublist(0, listIdsSubTopicPrep[0]);
        for (var item in listFirst.reversed) {
          valuesPrep.insert(
            0,
            item,
          );
        }
      }
      preparationsFinal = valuesPrep;
    }
    print("finall $preparationsFinal");
    listIngredients.assignAll(ingredientsFinal);
    listPreparations.assignAll(preparationsFinal);
  }

  refreshList() {
    listIngredients.refresh();
  }

  refreshListPreparation() {
    listPreparations.refresh();
  }

  likeRecipe() {
    if (isLiked.value) {
      recipeSelected.value!.likes -= 1;
    } else {
      recipeSelected.value!.likes += 1;
    }
    recipeSelected.refresh();
    isLiked.value = !isLiked.value;
  }

  updateRecipeLike() async {
    if (initalRecipe.toJson().toString() ==
        recipeSelected.value!.toJson().toString()) {
      print("é igual");
      return;
    }
    var result = await FirebaseBaseHelper.updateRecipeLike(
        recipeSelected.value!, userController.currentUser.value);

    if (result == "") {
      print(recipeSelected.value);
      initalRecipe = Recipe.copyWith(recipeSelected.value!);
      return "";
    } else {
      return result;
    }

    // for (var x in recipe.ingredients) {}
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  void onDetached() {
    print("onDetached");
  }

  @override
  void onInactive() {
    print("onInactive");
  }

  @override
  void onPaused() {
    updateRecipeLike();
    print("onPaused");
  }

  @override
  void onResumed() {
    print("onResumed");
  }
}
