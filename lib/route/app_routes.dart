part of 'app_pages.dart';

abstract class Routes {
  // ignore: constant_identifier_names
  static const MAIN_PAGE = _Paths.MAIN_PAGE;
  // ignore: constant_identifier_names
  static const HOME = _Paths.HOME;
  // ignore: constant_identifier_names
  static const SEARCH_INGREDIENT = _Paths.SEARCH_INGREDIENT;
  // ignore: constant_identifier_names
  static const RECIPE_LIST = _Paths.RECIPE_LIST;
  // ignore: constant_identifier_names
  static const RECIPE_RESULT = _Paths.RECIPE_RESULT;
  // ignore: constant_identifier_names
  static const SETTINGS = _Paths.SETTINGS;
  //static const IMAGES_DETAILS = _Paths.IMAGES_DETAILS;
  //static const VIDEOS_DETAILS = _Paths.VIDEOS_DETAILS;
}

abstract class _Paths {
  // ignore: constant_identifier_names
  static const MAIN_PAGE = '/mainPage';
  // ignore: constant_identifier_names
  static const HOME = '/home';
  // ignore: constant_identifier_names
  static const SEARCH_INGREDIENT = '/searchIngredient';
  // ignore: constant_identifier_names
  static const RECIPE_LIST = '/recipelist';
  // ignore: constant_identifier_names
  static const RECIPE_RESULT = '/recipeResult';
  // ignore: constant_identifier_names
  static const SETTINGS = '/settings';
  //static const IMAGES_DETAILS = '/images_details';
  //static const VIDEOS_DETAILS = '/video_details';
}
