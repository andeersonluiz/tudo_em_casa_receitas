import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/page_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<PageControl>(PageControl());
  }
}
