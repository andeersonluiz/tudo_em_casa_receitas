import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// ignore_for_file: constant_identifier_names
enum Status { None, Loading, Finished }

class HomeViewController extends GetxController {
  var toggleValue = true.obs;
  var toggleValueStatus = Status.Finished.obs;

  var bottomNavIndex = 0.obs;

  updateToogleValue(bool value) {
    if (toggleValue.value != value) {
      toggleValue.value = value;
    }
    updateToggleStatus(Status.Loading);
    if (toggleValue.value) {
      //carrega lista normal
    }
    //carrega lista depensa
  }

  updateToggleStatus(Status status) {
    toggleValueStatus.value = status;
  }

  updateBottomNavIndex(int index) {
    bottomNavIndex.value = index;
  }
}
