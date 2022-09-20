import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/binding/add_recipe_binding.dart';
import 'package:tudo_em_casa_receitas/binding/home_binding.dart';
import 'package:tudo_em_casa_receitas/binding/register_binding.dart';
import 'package:tudo_em_casa_receitas/binding/search_binding.dart';
import 'package:tudo_em_casa_receitas/view/add_recipe_view.dart';
import 'package:tudo_em_casa_receitas/view/home_view.dart';
import 'package:tudo_em_casa_receitas/view/login_view.dart';
import 'package:tudo_em_casa_receitas/view/mainPage_view.dart';
import 'package:tudo_em_casa_receitas/view/my_recipes_view.dart';
import 'package:tudo_em_casa_receitas/view/recipe_list_all_results.view.dart';
import 'package:tudo_em_casa_receitas/view/recipe_list_category_view.dart';
import 'package:tudo_em_casa_receitas/view/recipe_result_view.dart';
import 'package:tudo_em_casa_receitas/view/register_view.dart';
import 'package:tudo_em_casa_receitas/view/searchIngredient_view.dart';

import '../binding/login_binding.dart';

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
      name: _Paths.RECIPE_CATEGORY,
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => const RecipeListCategoryView(),
    ),
    GetPage(
      name: _Paths.RECIPE_RESULT,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => const RecipeResultView(),
    ),
    GetPage(
      name: _Paths.RECIPE_ALL_RESULTS,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => const RecipeListAllResults(),
    ),
    GetPage(
        name: _Paths.LOGIN,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        page: () => const LoginView(),
        binding: LoginBinding()),
    GetPage(
        name: _Paths.REGISTER,
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        page: () => const RegisterView(),
        binding: RegisterBinding()),
    GetPage(
      name: _Paths.MY_RECIPES,
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => MyRecipesView(),
    ),
    GetPage(
        name: _Paths.ADD_RECIPE,
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        page: () => AddRecipeView(),
        binding: AddRecipeBinding()),
  ];
}
