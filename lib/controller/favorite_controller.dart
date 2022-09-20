import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';
import 'package:tudo_em_casa_receitas/support/preferences.dart';

import '../model/recipe_model.dart';

class FavoriteController extends GetxController {
  setFavorite(Recipe recipe) async {
    if (recipe.isFavorite) {
      await Preferences.removeFavorite(recipe);
    } else {
      await Preferences.addFavorite(recipe);
    }
    refactorLists();
  }

  static refactorLists() {
    //fazer try catch nos outros controller que tiverem favoritos
    try {
      RecipeResultController recipeResultController = Get.find();
      List<dynamic> recipes =
          recipeResultController.listRecipesHomePage.map((tuple) {
        List<Recipe> rec = tuple[1] as List<Recipe>;
        List<Recipe> recipeList = rec.map<Recipe>((recipe) {
          if (LocalVariables.idsListRecipes.contains(recipe.id)) {
            recipe.isFavorite = true;
          } else {
            recipe.isFavorite = false;
          }
          return recipe;
        }).toList();
        return [tuple[0], recipeList];
      }).toList();

      recipeResultController.listRecipesHomePage.assignAll(recipes);
    } catch (e) {
      if (kDebugMode) {
        print(e);
        print("recipeResultController.listRecipesHomePage null");
      }
    }

    try {
      RecipeResultController recipeResultController = Get.find();
      List<dynamic> recipes =
          recipeResultController.listRecipesPantryPage.map((tuple) {
        List<Recipe> rec = List<Recipe>.from(tuple[1]);
        List<Recipe> recipeList = rec.map<Recipe>((recipe) {
          if (LocalVariables.idsListRecipes.contains(recipe.id)) {
            recipe.isFavorite = true;
          } else {
            recipe.isFavorite = false;
          }
          return recipe;
        }).toList();
        return [tuple[0], recipeList];
      }).toList();

      recipeResultController.listRecipesPantryPage.assignAll(recipes);
    } catch (e) {
      if (kDebugMode) {
        print(e);
        print("recipeResultController.listRecipesPantryPage null");
      }
    }

    try {
      RecipeResultController recipeResultController = Get.find();
      List<dynamic> recipes = recipeResultController.listRecipes.map((recipe) {
        if (LocalVariables.idsListRecipes.contains(recipe.id)) {
          recipe.isFavorite = true;
        } else {
          recipe.isFavorite = false;
        }
        return recipe;
      }).toList();

      recipeResultController.listRecipes.assignAll(recipes);
    } catch (e) {
      if (kDebugMode) {
        print(e);
        print("recipeResultController.listRecipes null");
      }
    }
    try {
      RecipeResultController recipeResultController = Get.find();
      List<dynamic> recipes =
          recipeResultController.listRecipesCategory.map((recipe) {
        if (LocalVariables.idsListRecipes.contains(recipe.id)) {
          recipe.isFavorite = true;
        } else {
          recipe.isFavorite = false;
        }
        return recipe;
      }).toList();

      recipeResultController.listRecipesCategory.assignAll(recipes);
    } catch (e) {
      if (kDebugMode) {
        print(e);
        print("recipeResultController.listRecipesCategory null");
      }
    }
    try {
      RecipeResultController recipeResultController = Get.find();
      List<dynamic> recipes =
          recipeResultController.listRecipesResult.map((recipe) {
        return recipe.map((rec) {
          if (LocalVariables.idsListRecipes.contains(rec.id)) {
            rec.isFavorite = true;
          } else {
            rec.isFavorite = false;
          }
          return rec;
        }).toList();
      }).toList();
      recipeResultController.listRecipesResult.assignAll(recipes);
    } catch (e) {
      if (kDebugMode) {
        print(e);
        print("recipeResultController.listRecipesResult null");
      }
    }
    try {
      RecipeResultController recipeResultController = Get.find();
      List<dynamic> recipes =
          recipeResultController.listRecipesResultMatched.map((recipe) {
        if (LocalVariables.idsListRecipes.contains(recipe.id)) {
          recipe.isFavorite = true;
        } else {
          recipe.isFavorite = false;
        }
        return recipe;
      }).toList();

      recipeResultController.listRecipesResultMatched.assignAll(recipes);
    } catch (e) {
      if (kDebugMode) {
        print(e);
        print("recipeResultController.listRecipesResultMatched null");
      }
    }
    try {
      RecipeResultController recipeResultController = Get.find();
      List<dynamic> recipes =
          recipeResultController.listRecipesResultMissingOne.map((recipe) {
        if (LocalVariables.idsListRecipes.contains(recipe.id)) {
          recipe.isFavorite = true;
        } else {
          recipe.isFavorite = false;
        }
        return recipe;
      }).toList();

      recipeResultController.listRecipesResultMissingOne.assignAll(recipes);
    } catch (e) {
      if (kDebugMode) {
        print(e);
        print("recipeResultController.listRecipesResultMissingOne null");
      }
    }
  }
}
