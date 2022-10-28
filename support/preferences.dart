// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/categorie_list_model.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/model/notification_model.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/model/tag_model.dart';
import 'package:tudo_em_casa_receitas/model/user_model.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';

class Preferences {
  static String FAVORITE_KEY = "FAVORITE_KEY_";
  static const String TAG_KEY = "TAG_KEY";
  static String INGREDIENT_KEY = "INGREDIENT_KEY_";
  static const String USER_KEY = "USER_KEY";
  static String INGREDIENT_HOME_KEY = "INGREDIENT_HOME_KEY_";
  static String DARK_MODE_KEY = "DARK_MODE_KEY";
  static String NOTIFICATION_KEY = "NOTIFICATION_KEY";
  static String CATEGORIES_KEY = "CATEGORIES_KEY";
  static String NOTIFICATION_USER_KEY = "NOTIFICATION__USER_KEY";

  static addFavorite(Recipe rec) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("key is $FAVORITE_KEY");
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
      print("vazio");
      LocalVariables.idsListRecipes = [];
    } else {
      LocalVariables.idsListRecipes =
          Recipe.decode(value).map((e) => e.id).toList();
      print("${LocalVariables.idsListRecipes}");
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
    print(INGREDIENT_KEY);
    String? value = prefs.getString(INGREDIENT_KEY);
    print(value);
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
    //prefs.clear();
    String? value = prefs.getString(INGREDIENT_HOME_KEY);
    if (value == null) {
      LocalVariables.ingredientsHomePantry = [];
    } else {
      LocalVariables.ingredientsHomePantry = Ingredient.decode(value);
    }
  }

  static Future<void> saveUser(UserModel user,
      {bool addRecipe = false,
      bool updateRecipe = false,
      bool deleteRecipe = false,
      bool refreshRecipe = false,
      Recipe? recipe}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserController userController = Get.find();
    userController.setCurrentUser(user);
    FAVORITE_KEY = "FAVORITE_KEY_${user.id}";
    INGREDIENT_KEY = "INGREDIENT_KEY_${user.id}";
    INGREDIENT_HOME_KEY = "INGREDIENT_HOME_KEY_${user.id}";
    if (addRecipe && recipe != null) {
      userController.addMyRecipe(
        recipe,
      );
    } else if (updateRecipe && recipe != null) {
      UserController userController = Get.find();
      userController.updateMyRecipe(recipe);
    } else if (deleteRecipe && recipe != null) {
      UserController userController = Get.find();

      userController.deleteMyRecipe(recipe);
    }
    var encoded = UserModel.encode([user]);
    prefs.setString(USER_KEY, encoded);
  }

  static Future<dynamic> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? value = prefs.getString(USER_KEY);
    UserModel user;
    if (value == null) {
      print("nao tem user logado");
      FAVORITE_KEY = "FAVORITE_KEY_";
      INGREDIENT_KEY = "INGREDIENT_KEY_";
      INGREDIENT_HOME_KEY = "INGREDIENT_HOME_KEY_";
      return null;
    } else {
      user = UserModel.decode(value)[0];
      FAVORITE_KEY = "FAVORITE_KEY_${user.id}";
      INGREDIENT_KEY = "INGREDIENT_KEY_${user.id}";
      INGREDIENT_HOME_KEY = "INGREDIENT_HOME_KEY_${user.id}";
      var userUpdated = await FirebaseBaseHelper.getUserData(user.id);
      LocalVariables.currentUser = userUpdated;
    }
  }

  static Future<void> removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FAVORITE_KEY = "FAVORITE_KEY_";
    INGREDIENT_KEY = "INGREDIENT_KEY_";
    INGREDIENT_HOME_KEY = "INGREDIENT_HOME_KEY_";
    await prefs.remove(USER_KEY);
  }

  static updateDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LocalVariables.isDartkMode = value;
    await prefs.setBool(DARK_MODE_KEY, value);
  }

  static Future<void> getDartkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getBool(DARK_MODE_KEY);
    if (data != null) {
      LocalVariables.isDartkMode = data;
    }
  }

  static Future<void> updateNotifications(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LocalVariables.showNotifcations = value;
    if (value) {
      await FirebaseMessaging.instance.subscribeToTopic("notifiers");
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic("notifiers");
    }
    await prefs.setBool(NOTIFICATION_KEY, value);
  }

  static Future<void> getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getBool(NOTIFICATION_KEY);
    if (data != null) {
      LocalVariables.showNotifcations = data;
      if (data) {
        await FirebaseMessaging.instance.subscribeToTopic("notifiers");
      } else {
        await FirebaseMessaging.instance.unsubscribeFromTopic("notifiers");
      }
    }
  }

  static Future<void> getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(CATEGORIES_KEY);

    if (data != null) {
      print(data);
      LocalVariables.listCategories = CategorieList.decode(data);
    } else {
      LocalVariables.listCategories =
          await FirebaseBaseHelper.initalizeCategoriesList();
      var encoded = CategorieList.encode(LocalVariables.listCategories);
      await prefs.setString(CATEGORIES_KEY, encoded);
    }
    print(LocalVariables.listCategories);
  }

  static Future<void> addCategories(List<String> categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(CATEGORIES_KEY);

    if (data != null) {
      List<String> catNames =
          LocalVariables.listCategories.map((e) => e.name).toList();
      for (var cat in categories) {
        if (catNames.contains(cat)) {
          var index = LocalVariables.listCategories
              .indexWhere((element) => element.name == cat);
          LocalVariables.listCategories[index].count += 1;
        } else {
          LocalVariables.listCategories.add(CategorieList(name: cat, count: 1));
        }
      }
      LocalVariables.listCategories.sort((a, b) => b.count.compareTo(a.count));
      var encoded = CategorieList.encode(LocalVariables.listCategories);
      await prefs.setString(CATEGORIES_KEY, encoded);
    }
  }

  static Future<void> getNotificationsUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var data = prefs.getString(NOTIFICATION_USER_KEY);

    if (data != null) {
      print(NotificationModel.decode(data).last);
      LocalVariables.listNotifications = NotificationModel.decode(data);
    }
  }

  static addNotificationUsers(NotificationModel notification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var data = prefs.getString(NOTIFICATION_USER_KEY);
    var dataEncoded = "";
    if (data == null) {
      dataEncoded = NotificationModel.encode([notification]);
      LocalVariables.listNotifications = [notification];
    } else {
      List<NotificationModel> notifications = NotificationModel.decode(data);
      LocalVariables.listNotifications = notifications;
      notifications.add(notification);
      dataEncoded = NotificationModel.encode(notifications);
    }
    print("add a ${notification.title}");
    await prefs.setString(NOTIFICATION_USER_KEY, dataEncoded);
  }

  static updateNoticiationUsers(List<NotificationModel> notifications) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var dataEncoded = NotificationModel.encode(notifications);
    LocalVariables.listNotifications = notifications;

    await prefs.setString(NOTIFICATION_USER_KEY, dataEncoded);
  }
}
