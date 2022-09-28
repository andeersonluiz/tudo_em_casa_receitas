// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  static const MAIN_PAGE = _Paths.MAIN_PAGE;

  static const HOME = _Paths.HOME;

  static const SEARCH_INGREDIENT = _Paths.SEARCH_INGREDIENT;

  static const RECIPE_LIST = _Paths.RECIPE_LIST;

  static const RECIPE_RESULT = _Paths.RECIPE_RESULT;

  static const RECIPE_ALL_RESULTS = _Paths.RECIPE_ALL_RESULTS;

  static const SETTINGS = _Paths.SETTINGS;

  static const RECIPE_CATEGORY = _Paths.RECIPE_CATEGORY;

  static const LOGIN = _Paths.LOGIN;

  static const REGISTER = _Paths.REGISTER;

  static const MY_RECIPES = _Paths.MY_RECIPES;

  static const ADD_RECIPE = _Paths.ADD_RECIPE;

  static const UPDATE_RECIPE = _Paths.UPDATE_RECIPE;

  static const SUGGESTION_INGREDIENT = _Paths.SUGGESTION_INGREDIENT;

  static const SUGGESTION_MEASURE = _Paths.SUGGESTION_MEASURE;
  static const SUGGESTION_CATEGORIE = _Paths.SUGGESTION_CATEGORIE;
  //static const IMAGES_DETAILS = _Paths.IMAGES_DETAILS;
  //static const VIDEOS_DETAILS = _Paths.VIDEOS_DETAILS;
}

abstract class _Paths {
  static const MAIN_PAGE = '/mainPage';

  static const HOME = '/home';

  static const SEARCH_INGREDIENT = '/searchIngredient';

  static const RECIPE_LIST = '/recipelist';

  static const RECIPE_RESULT = '/recipeResult';

  static const RECIPE_ALL_RESULTS = '/recipeAllResult';

  static const SETTINGS = '/settings';

  static const RECIPE_CATEGORY = '/recipeCategory';

  static const LOGIN = '/login';

  static const REGISTER = '/register';
  static const SUGGESTION_INGREDIENT = '/user/suggestionIngredient';
  static const SUGGESTION_MEASURE = '/user/suggestionMeasure';
  static const SUGGESTION_CATEGORIE = '/user/suggestionCategorie';
  static const MY_RECIPES = '/user/recipes';

  static const ADD_RECIPE = '/user/addRecipe';

  static const UPDATE_RECIPE = '/user/updateRecipe';
  //static const IMAGES_DETAILS = '/images_details';
  //static const VIDEOS_DETAILS = '/video_details';
}
