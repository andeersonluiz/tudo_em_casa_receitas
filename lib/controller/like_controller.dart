import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';

class LikeController extends GetxController {
  setLike(Recipe recipe) async {
    refactorLists(recipe);
  }

  static refactorLists(Recipe myrecipe) {
    //fazer try catch nos outros controller que tiverem favoritos
    try {
      RecipeResultController recipeResultController = Get.find();
      List<dynamic> recipes =
          recipeResultController.listRecipesHomePage.map((tuple) {
        List<Recipe> rec = tuple[1] as List<Recipe>;
        List<Recipe> recipeList = rec.map<Recipe>((recipe) {
          if (myrecipe.id == recipe.id) {
            recipe.isLiked = myrecipe.isLiked;
            recipe.likes = myrecipe.likes;
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
          if (myrecipe.id == recipe.id) {
            recipe.isLiked = myrecipe.isLiked;
            recipe.likes = myrecipe.likes;
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
        if (myrecipe.id == recipe.id) {
          recipe.isLiked = myrecipe.isLiked;
          recipe.likes = myrecipe.likes;
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
        if (myrecipe.id == recipe.id) {
          recipe.isLiked = myrecipe.isLiked;
          recipe.likes = myrecipe.likes;
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
          if (myrecipe.id == recipe.id) {
            recipe.isLiked = myrecipe.isLiked;
            recipe.likes = myrecipe.likes;
          }
          return recipe;
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
        if (myrecipe.id == recipe.id) {
          recipe.isLiked = myrecipe.isLiked;
          recipe.likes = myrecipe.likes;
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
        if (myrecipe.id == recipe.id) {
          recipe.isLiked = myrecipe.isLiked;
          recipe.likes = myrecipe.likes;
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
