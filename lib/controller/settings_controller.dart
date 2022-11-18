import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';
import 'package:tudo_em_casa_receitas/support/preferences.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

class SettingsController extends GetxController {
  var isDarkMode = false.obs;
  var showNotifications = false.obs;
  var feedbackText = "";
  var isDarkModePlace = false.obs;
  @override
  void onInit() async {
    super.onInit();
    isDarkMode.value = LocalVariables.isDartkMode;
    isDarkModePlace.value = LocalVariables.isDartkMode;
    showNotifications.value = LocalVariables.showNotifcations;
  }

  updateDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(
        isDarkMode.value ? CustomTheme.dataDark : CustomTheme.dataLight);

    Preferences.updateDarkMode(isDarkMode.value);
  }

  updateNotifications() {
    showNotifications.value = !showNotifications.value;
    Preferences.updateNotifications(showNotifications.value);
  }

  updateFeedbackText(String value) {
    feedbackText = value;
  }

  sendFeedback() async {
    UserController userController = Get.find();
    await FirebaseBaseHelper.sendFeedback(
        userController.currentUser.value, feedbackText);
  }
}
