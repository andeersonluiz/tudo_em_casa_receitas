import 'package:get/get.dart';

class ButtonController extends GetxController {
  var pressed = false.obs;

  setPressed(value) {
    pressed.value = value;
  }
}
