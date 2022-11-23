import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/binding/add_recipe_binding.dart';
import 'package:tudo_em_casa_receitas/binding/admin_binding.dart';
import 'package:tudo_em_casa_receitas/binding/home_binding.dart';
import 'package:tudo_em_casa_receitas/binding/register_binding.dart';
import 'package:tudo_em_casa_receitas/binding/my_recipes_binding.dart';
import 'package:tudo_em_casa_receitas/binding/report_bug_binding.dart';
import 'package:tudo_em_casa_receitas/binding/settings_binding.dart';
import 'package:tudo_em_casa_receitas/view/admin_view.dart';
import 'package:tudo_em_casa_receitas/view/edit_profile_view.dart';
import 'package:tudo_em_casa_receitas/view/favorite_view.dart';
import 'package:tudo_em_casa_receitas/view/notification_info_view.dart';
import 'package:tudo_em_casa_receitas/view/notification_view.dart';
import 'package:tudo_em_casa_receitas/view/profile_page.dart';
import 'package:tudo_em_casa_receitas/view/recipe_infos_view.dart';
import 'package:tudo_em_casa_receitas/view/add_recipe_view.dart';
import 'package:tudo_em_casa_receitas/view/home_view.dart';
import 'package:tudo_em_casa_receitas/view/login_view.dart';
import 'package:tudo_em_casa_receitas/view/mainPage_view.dart';
import 'package:tudo_em_casa_receitas/view/my_recipes_view.dart';
import 'package:tudo_em_casa_receitas/view/recipe_list_all_results.view.dart';
import 'package:tudo_em_casa_receitas/view/recipe_list_category_view.dart';
import 'package:tudo_em_casa_receitas/view/recipe_result_view.dart';
import 'package:tudo_em_casa_receitas/view/recipe_user_list_view.dart';
import 'package:tudo_em_casa_receitas/view/register_view.dart';
import 'package:tudo_em_casa_receitas/view/report_bug.view.dart';
import 'package:tudo_em_casa_receitas/view/searchIngredient_view.dart';
import 'package:tudo_em_casa_receitas/view/settings_view.dart';
import 'package:tudo_em_casa_receitas/view/suggesion_ingredient_view.dart';
import 'package:tudo_em_casa_receitas/view/suggesion_measure_view.dart';
import 'package:tudo_em_casa_receitas/view/suggestion_categorie_view.dart';
import 'package:tudo_em_casa_receitas/view/update_recipe_view.dart';

import '../binding/recipe_info_binding.dart';

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
        name: _Paths.SETTINGS,
        page: () => SettingsView(),
        binding: SettingsBinding()),
    GetPage(
      name: _Paths.SEARCH_INGREDIENT,
      page: () => const SearchIngredientView(),
    ),
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
    ),
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
        binding: MyRecipesBinding()),
    GetPage(
        name: _Paths.ADD_RECIPE,
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        page: () => AddRecipeView(),
        binding: AddRecipeBinding()),
    GetPage(
        name: _Paths.UPDATE_RECIPE,
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        page: () => const UpdateRecipeView(),
        binding: AddRecipeBinding()),
    GetPage(
        name: _Paths.SUGGESTION_INGREDIENT,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        page: () => SuggestionIngredientView()),
    GetPage(
        name: _Paths.SUGGESTION_MEASURE,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        page: () => SuggestionMeasureView()),
    GetPage(
        name: _Paths.SUGGESTION_CATEGORIE,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        page: () => SuggestionCategorieView()),
    GetPage(
        name: "${_Paths.RECIPE_VIEW}/:data",
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        page: () => const RecipeInfosView(),
        binding: RecipeInfoBinding()),
    GetPage(
        name: _Paths.PROFILE,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        page: () => const ProfilePage(),
        binding: MyRecipesBinding()),
    GetPage(
        name: _Paths.EDIT_PROFILE,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        page: () => EditProfileView(),
        binding: MyRecipesBinding()),
    GetPage(
      name: _Paths.RECIPE_LIST_USER,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => const RecipeUserListView(),
    ),
    GetPage(
      name: _Paths.FAVORITE_LIST,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => FavoriteView(),
    ),
    GetPage(
      name: _Paths.REPORT,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => ReportBugView(),
      binding: ReportBugBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => const NotificationView(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS_INFO,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => const NotificationInfoView(),
    ),
    GetPage(
        name: _Paths.ADMIN,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        page: () => AdminView(),
        binding: AdminBinding()),
  ];
}
