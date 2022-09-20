import 'package:get/state_manager.dart';

class CrudRecipeController extends GetxController {
  var hourPreparationTime = 0.obs;
  var minutesPreparationTime = 0.obs;

  updateHourPreparationTime(int newValue) {
    hourPreparationTime.value = newValue;
  }

  updateMinutesPreparationTime(int newValue) {
    minutesPreparationTime.value = newValue;
  }
}
