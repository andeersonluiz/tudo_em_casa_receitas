import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_url_shortener/flutter_url_shortener.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_item.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/model/measure_model.dart';
import 'package:tudo_em_casa_receitas/model/preparation_item.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:http/http.dart' as http;
import 'package:tudo_em_casa_receitas/support/preferences.dart';

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
  var isFavorite = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  loadData(Recipe recipe) {
    if (userController.currentUser.value.recipeLikes.contains(recipe.id)) {
      isLiked.value = true;
    }
    recipeSelected.value = Recipe.copyWith(recipe);
    initalRecipe = Recipe.copyWith(recipe);
    isFavorite.value = recipe.isFavorite;
    var listIngredientsValues = recipe.ingredients;
    var listPreparationsValues = recipe.preparation;
    var listIngsConverted = [];
    var listPreparationConverted = [];
    if (recipe.ingredients is List<String> &&
        recipe.preparation is List<String>) {
      for (var item in listIngredientsValues) {
        if (item.startsWith("*") && item.endsWith("*")) {
          listIngsConverted.add(IngredientItem(
              name: item.replaceAll("*", ""),
              format: "",
              isOptional: false,
              measure: Measure(name: "", plural: ""),
              isSubtopic: true,
              qtd: -1,
              ingredientSelected: null));
        } else {
          listIngsConverted.add(IngredientItem(
              name: item, //VER ESSA PARTE TALVEZ SERIA ITEM.NAME
              format: "",
              isOptional: false,
              measure: Measure(name: "", plural: ""),
              isSubtopic: false,
              qtd: -1,
              ingredientSelected: null));
        }
      }
      print("0001");
      for (var item in listPreparationsValues) {
        print(item);
        if (item.startsWith("*") && item.endsWith("*")) {
          listPreparationConverted.add(PreparationItem(
              description: item.replaceAll("*", ""), isSubtopic: true));
        } else {
          listPreparationConverted.add(PreparationItem(
            description: item,
            isSubtopic: false,
          ));
        }
      }
      listIngredientsValues = listIngsConverted;
      listPreparationsValues = listPreparationConverted;
    }

    for (var e in listIngredientsValues) {
      if (e is IngredientItem) {
        e.id = getRandomString(15);
      } else {
        for (var rec in e) {
          rec.id = getRandomString(15);
        }
      }
    }
    for (var e in listPreparationsValues) {
      e.id = getRandomString(15);
    }
    var ingredientsFinal = [];
    var preparationsFinal = [];

    var result = listIngredientsValues.map((e) {
      if (e is IngredientItem && e.isSubtopic) {
        return listIngredientsValues.indexWhere((element) => element == e);
      }
    }).toList();
    var resultPrep = listPreparationsValues.map((e) {
      if (e is PreparationItem && e.isSubtopic) {
        return listPreparationsValues.indexWhere((element) => element == e);
      }
    }).toList();

    var values = [];
    var valuesPrep = [];

    final List<int> listIdsSubTopic = result.whereType<int>().toList();
    final List<int> listIdsSubTopicPrep = resultPrep.whereType<int>().toList();
    if (listIdsSubTopic.isEmpty) {
      ingredientsFinal = listIngredientsValues;
    } else {
      for (int i = 0; i < listIdsSubTopic.length; i++) {
        var item = listIdsSubTopic[i];
        if (i == listIdsSubTopic.length - 1) {
          values.add([
            listIngredientsValues[item],
            listIngredientsValues.sublist(
                listIdsSubTopic[i] + 1, listIngredientsValues.length),
          ]);
        } else {
          values.add([
            listIngredientsValues[item],
            listIngredientsValues.sublist(
              listIdsSubTopic[i] + 1,
              listIdsSubTopic[i + 1],
            ),
          ]);
        }
      }

      if (listIdsSubTopic[0] != 0) {
        var listFirst = listIngredientsValues.sublist(0, listIdsSubTopic[0]);
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
      preparationsFinal = listPreparationsValues;
    } else {
      for (int i = 0; i < listIdsSubTopicPrep.length; i++) {
        var item = listIdsSubTopicPrep[i];
        if (i == listIdsSubTopicPrep.length - 1) {
          valuesPrep.add([
            listPreparationsValues[item],
            listPreparationsValues.sublist(
                item + 1, listPreparationsValues.length),
          ]);
        } else {
          valuesPrep.add([
            listPreparationsValues[item],
            listPreparationsValues.sublist(
              item + 1,
              listIdsSubTopicPrep[i + 1],
            ),
          ]);
        }
      }

      if (listIdsSubTopicPrep[0] != 0) {
        var listFirst =
            listPreparationsValues.sublist(0, listIdsSubTopicPrep[0]);
        for (var item in listFirst.reversed) {
          valuesPrep.insert(
            0,
            item,
          );
        }
      }
      preparationsFinal = valuesPrep;
    }
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
    if (recipeSelected.value!.isLiked) {
      recipeSelected.value!.likes -= 1;
    } else {
      recipeSelected.value!.likes += 1;
    }
    recipeSelected.value!.isLiked = !recipeSelected.value!.isLiked;
    recipeSelected.refresh();
  }

  updateRecipeLike() async {
    if (initalRecipe.toJson().toString() ==
        recipeSelected.value!.toJson().toString()) {
      return;
    }
    var result = await FirebaseBaseHelper.updateRecipeLike(
        recipeSelected.value!, userController.currentUser.value);

    if (result == "") {
      initalRecipe = Recipe.copyWith(recipeSelected.value!);
      return "";
    } else {
      return result;
    }

    // for (var x in recipe.ingredients) {}
  }

  updateViewsAndCategories() async {
    await Preferences.addCategories(initalRecipe.categories);
    await FirebaseBaseHelper.updateRecipeViews(recipeSelected.value!);
  }

  setFavorite() {
    isFavorite.value = !isFavorite.value;
    recipeSelected.value!.isFavorite = isFavorite.value;
    recipeSelected.refresh();
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  getRecipe(String id) async {
    return await FirebaseBaseHelper.getRecipe(
        id, userController.currentUser.value);
  }

  generateShorUrl() async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          "https://cookiva.page.link${Routes.RECIPE_VIEW}/${initalRecipe.id}"),
      uriPrefix: "https://cookiva.page.link",
      androidParameters: const AndroidParameters(
          packageName: "com.example.tudo_em_casa_receitas"),
      iosParameters:
          const IOSParameters(bundleId: "com.example.tudo_em_casa_receitas"),
    );
    final shorLink = await FirebaseDynamicLinks.instance.buildShortLink(
      dynamicLinkParams,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );
    try {
      print("aaa ${shorLink.shortUrl.toString()}");
      final result = await http.post(
          Uri.parse("https://cleanuri.com/api/v1/shorten"),
          body: {"url": shorLink.shortUrl.toString()});
      if (result.statusCode == 200) {
        final jsonResult = jsonDecode(result.body);
        return jsonResult["result_url"];
      }
      var url = await FShort.instance
          .generateShortenURL(longUrl: shorLink.shortUrl.toString());
      return url;
    } catch (e) {
      print(e);
      return "";
    }
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {
    updateRecipeLike();
  }

  @override
  void onResumed() {}
}
