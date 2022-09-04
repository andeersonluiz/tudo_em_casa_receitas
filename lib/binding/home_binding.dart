import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/favorite_controller.dart';
import 'package:tudo_em_casa_receitas/controller/home_view_controller.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/controller/page_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<FavoriteController>(FavoriteController());
    Get.put<PageControl>(PageControl());
    Get.put<HomeViewController>(HomeViewController());
    Get.lazyPut<IngredientController>(() => IngredientController());
  }
}
