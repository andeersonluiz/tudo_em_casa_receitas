import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/binding/home_binding.dart';
import 'package:tudo_em_casa_receitas/binding/recipeResult_binding.dart';
import 'package:tudo_em_casa_receitas/binding/search_binding.dart';
import 'package:tudo_em_casa_receitas/view/home_view.dart';
import 'package:tudo_em_casa_receitas/view/mainPage_view.dart';
import 'package:tudo_em_casa_receitas/view/recipeResult_view.dart';
import 'package:tudo_em_casa_receitas/view/searchIngredient_view.dart';

part 'app_routes.dart';

class AppPage {
  // ignore: constant_identifier_names
  static const INITIAL = Routes.MAIN_PAGE;

  static final routes = [
    GetPage(
        name: _Paths.MAIN_PAGE,
        page: () => const MainPageView(),
        binding: HomeBinding()),
    GetPage(name: _Paths.HOME, page: () => const HomeView()),
    GetPage(
        name: _Paths.SEARCH_INGREDIENT,
        page: () => const SearchIngredientView(),
        binding: SearchBinding()),
    GetPage(
        name: _Paths.RECIPE_RESULT,
        page: () => const RecipeResultView(),
        binding: RecipeResultBinding()),
  ];
}
