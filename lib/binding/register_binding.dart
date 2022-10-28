import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/register_controller.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RegisterController>(RegisterController());
  }
}
