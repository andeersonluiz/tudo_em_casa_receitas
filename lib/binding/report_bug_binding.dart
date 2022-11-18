import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/report_bug_controller.dart';

class ReportBugBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ReportBugController>(ReportBugController());
  }
}
