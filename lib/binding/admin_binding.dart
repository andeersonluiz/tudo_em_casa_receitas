import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/admin_controller.dart';

class AdminBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AdminController>(AdminController());
  }
}
