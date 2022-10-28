import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/register_controller.dart';
import 'package:tudo_em_casa_receitas/controller/settings_controller.dart';

class SettingsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SettingsController>(SettingsController());
  }
}
