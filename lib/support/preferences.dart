import 'package:shared_preferences/shared_preferences.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/model/tag_model.dart';
import 'package:tudo_em_casa_receitas/model/user_model.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';

class Preferences {
  // ignore: constant_identifier_names
  static const String FAVORITE_KEY = "FAVORITE_KEY";
  // ignore: constant_identifier_names
  static const String TAG_KEY = "TAG_KEY";
  // ignore: constant_identifier_names
  static const String INGREDIENT_KEY = "INGREDIENT_KEY";
  // ignore: constant_identifier_names
  static const String USER_KEY = "USER_KEY";
  // ignore: constant_identifier_names
  static const String INGREDIENT_HOME_KEY = "INGREDIENT_HOME_KEY";
  static addFavorite(Recipe rec) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rec.isFavorite = true;
    String? value = prefs.getString(FAVORITE_KEY);
    var dataEncoded = "";
    if (value == null) {
      dataEncoded = Recipe.encode([rec]);

      LocalVariables.idsListRecipes = [rec.id];
    } else {
      List<Recipe> recipes = Recipe.decode(value);
      recipes.add(rec);
      LocalVariables.idsListRecipes = recipes.map((e) => e.id).toList();

      dataEncoded = Recipe.encode(recipes);
    }
    await prefs.setString(FAVORITE_KEY, dataEncoded);
  }

  static removeFavorite(Recipe rec) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(FAVORITE_KEY);
    List<Recipe> recipes = Recipe.decode(value!);

    recipes.removeWhere((recipe) => recipe.id == rec.id);
    LocalVariables.idsListRecipes = recipes.map((e) => e.id).toList();
    var dataEncoded = Recipe.encode(recipes);
    await prefs.setString(FAVORITE_KEY, dataEncoded);
  }

  static Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(FAVORITE_KEY);
    if (value == null) {
      LocalVariables.idsListRecipes = [];
    } else {
      LocalVariables.idsListRecipes =
          Recipe.decode(value).map((e) => e.id).toList();
    }
  }

  static updateTag(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? value = prefs.getString(TAG_KEY);

    if (value != null) {
      List<Tag> tags = Tag.decode(value);
      int index = tags.indexWhere((e) => e.name == name);
      if (index != -1) {
        tags[index].count += 1;
      } else {
        tags.add(Tag(name: name, count: 1));
      }
      prefs.setString(TAG_KEY, Tag.encode(tags));
    } else {
      Tag t = Tag(name: name, count: 1);
      prefs.setString(TAG_KEY, Tag.encode([t]));
    }
  }

  static Future<List<dynamic>> getTags() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? value = prefs.getString(TAG_KEY);
    if (value != null) {
      return Tag.decode(value);
    } else {
      return [];
    }
  }

  static addIngredientPantry(Ingredient ingredient) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(INGREDIENT_KEY);
    var dataEncoded = "";
    if (value == null) {
      dataEncoded = Ingredient.encode([ingredient]);
      LocalVariables.ingredientsPantry = [ingredient];
    } else {
      List<Ingredient> ingredients = Ingredient.decode(value);
      ingredients.add(ingredient);
      LocalVariables.ingredientsPantry = ingredients;
      dataEncoded = Ingredient.encode(ingredients);
    }
    await prefs.setString(INGREDIENT_KEY, dataEncoded);
  }

  static removeIngredientPantry(Ingredient ingredient) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(INGREDIENT_KEY);
    List<Ingredient> ingredients = Ingredient.decode(value!);

    ingredients.removeWhere((ing) => ing.id == ingredient.id);
    LocalVariables.ingredientsPantry = ingredients;
    var dataEncoded = Ingredient.encode(ingredients);
    await prefs.setString(INGREDIENT_KEY, dataEncoded);
  }

  static Future<void> loadIngredientPantry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(INGREDIENT_KEY);
    if (value == null) {
      LocalVariables.ingredientsPantry = [];
    } else {
      LocalVariables.ingredientsPantry = Ingredient.decode(value);
    }
  }

  static addIngredientHomePantry(Ingredient ingredient) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(INGREDIENT_HOME_KEY);
    var dataEncoded = "";
    if (value == null) {
      dataEncoded = Ingredient.encode([ingredient]);
      LocalVariables.ingredientsHomePantry = [ingredient];
    } else {
      List<Ingredient> ingredients = Ingredient.decode(value);
      ingredients.add(ingredient);
      LocalVariables.ingredientsHomePantry = ingredients;
      dataEncoded = Ingredient.encode(ingredients);
    }
    prefs.setString(INGREDIENT_HOME_KEY, dataEncoded);
  }

  static removeIngredientHomePantry(Ingredient ingredient) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(INGREDIENT_HOME_KEY);
    List<Ingredient> ingredients = Ingredient.decode(value!);
    ingredients.removeWhere((ing) => ing.id == ingredient.id);
    LocalVariables.ingredientsHomePantry = ingredients;
    var dataEncoded = Ingredient.encode(ingredients);
    await prefs.setString(INGREDIENT_HOME_KEY, dataEncoded);
  }

  static Future<void> loadIngredientHomePantry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(INGREDIENT_HOME_KEY);
    if (value == null) {
      LocalVariables.ingredientsHomePantry = [];
    } else {
      LocalVariables.ingredientsHomePantry = Ingredient.decode(value);
    }
  }

  static saveUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var encoded = UserModel.encode([user]);
    prefs.setString(USER_KEY, encoded);
  }

  static Future<dynamic> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    String? value = prefs.getString(USER_KEY);
    UserModel user;
    if (value == null) {
      return null;
    } else {
      user = UserModel.decode(value)[0];
      LocalVariables.currentUser = user;
    }
  }

  static removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(USER_KEY);
  }
}
