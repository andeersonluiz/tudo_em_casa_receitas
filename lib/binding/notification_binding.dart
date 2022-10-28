import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/my_recipe_controller.dart';
import 'package:tudo_em_casa_receitas/controller/notification_controller.dart';
import 'package:tudo_em_casa_receitas/controller/profile_controller.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_infos_controller.dart';

class NotificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<NotificationController>(NotificationController());
  }
}
