import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';

// ignore_for_file: constant_identifier_names
enum Status { None, Loading, Finished }

class HomeViewController extends GetxController {
  var toggleValue = true.obs;
  var toggleValueStatus = Status.Finished.obs;
  var listRecipesHomePage = [].obs;
  var statusRecipes = Status.None.obs;
  var bottomNavIndex = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    statusRecipes.value = Status.Loading;
    List<String> tags = ["", "CUPCAKE", "PIZZA", "BRIGADEIRO"];
    var customList = [];
    for (String t in tags) {
      customList.add(
          [t.toUpperCase(), await FirebaseBaseHelper.getRecipesByTag(tag: t)]);
    }
    listRecipesHomePage.assignAll(customList);
    statusRecipes.value = Status.Finished;
  }

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
