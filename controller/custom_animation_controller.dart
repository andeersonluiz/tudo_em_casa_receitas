import 'package:get/get.dart';

class CustomAnimationController extends GetxController {
  var isShaking = false.obs;

  shake() async {
    isShaking.value = true;
    await Future.delayed(const Duration(milliseconds: 400));
    isShaking.value = false;
  }
}
