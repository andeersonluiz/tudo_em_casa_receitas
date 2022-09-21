import 'dart:math';

import 'package:get/state_manager.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_item.dart';
import 'package:tudo_em_casa_receitas/model/measure_model.dart';

class CrudRecipeController extends GetxController {
  var recipeTitle = "".obs;
  var photoSelected = "".obs;
  var photoName = "".obs;
  var ingredientSelected = "".obs;
  var formartValue = "".obs;
  Rx<Measure> measureSelected = Measure(name: "", plural: "").obs;

  var errorText = "".obs;
  var hourPreparationTime = 0.obs;
  var minutesPreparationTime = 0.obs;
  var hourPreparationTimeTemp = 0.obs;

  var minutesPreparationTimeTemp = 0.obs;
  var yieldValue = 0.obs;
  var yieldValueTemp = 0.obs;
  var qtdValue = 0.obs;
  var ingOptional = false.obs;
  IngredientItem? ingredientItemSelected;
  var listItems = [].obs;

  var subtopicValue = "".obs;

  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  updateRecipeTitle(String newValue) {
    recipeTitle.value = newValue;
  }

  updatePhotoSelected(String newValue) {
    photoSelected.value = newValue;
  }

  updatePhotoName(String newValue) {
    photoName.value = newValue;
  }

  updateFormatValue(String newValue) {
    formartValue.value = newValue;
  }

  updateIngredientSelected(String newValue) {
    ingredientSelected.value = newValue;
  }

  updateHourPreparationTime() {
    if (hourPreparationTime.value != hourPreparationTimeTemp.value) {
      hourPreparationTime.value = hourPreparationTimeTemp.value;
    }
  }

  updateMinutesPreparationTime() {
    if (minutesPreparationTime.value != minutesPreparationTimeTemp.value) {
      minutesPreparationTime.value = minutesPreparationTimeTemp.value;
    }
  }

  updateHourPreparationTimeTemp(int newValue) {
    if (newValue != hourPreparationTimeTemp.value) {
      hourPreparationTimeTemp.value = newValue;
    }
  }

  updateMinutesPreparationTimeTemp(int newValue) {
    if (newValue != minutesPreparationTimeTemp.value) {
      minutesPreparationTimeTemp.value = newValue;
    }
  }

  updateYieldValueTemp(int newValue) {
    if (newValue != yieldValueTemp.value) {
      yieldValueTemp.value = newValue;
    }
  }

  updateYieldValue() {
    if (yieldValueTemp.value != yieldValue.value) {
      yieldValue.value = yieldValueTemp.value;
    }
  }

  updateIngOptional() {
    ingOptional.value = !ingOptional.value;
  }

  updateQtdValue(String newValue) {
    int? result = int.tryParse(newValue);
    if (result != null) {
      qtdValue.value = result;
    }
  }

  updateMeasureValue(Measure newValue) {
    measureSelected.value = newValue;
  }

  updateSubtopicValue(String newText) {
    subtopicValue.value = newText;
  }

  clearErrorText() {
    errorText.value = "";
  }

  reorderListItems(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final IngredientItem item = listItems.removeAt(oldIndex);
    listItems.insert(newIndex, item);
  }

  validate() {
    if (ingredientSelected.value == "") {
      errorText.value = "Selecione um ingrediente";
      return false;
    } else if (qtdValue.value == 0) {
      errorText.value = "Digite um valor para quantidade";
      return false;
    } else if (measureSelected.value.name == "") {
      errorText.value = "Selecione uma medida";
      return false;
    }
    if (ingredientItemSelected == null) {
      listItems.add(IngredientItem(
          name: ingredientSelected.value,
          format: ingOptional.value ? "a gosto" : formartValue.value,
          isOptional: ingOptional.value,
          measure: measureSelected.value,
          qtd: qtdValue.value));
    }
    return true;
  }

  addSubtopicToList() {
    listItems.add(IngredientItem(
        name: subtopicValue.value,
        format: getRandomString(15),
        isOptional: false,
        measure: Measure(name: "", plural: ""),
        qtd: -1));
  }

  initializeData(IngredientItem ingredientItem) {
    updateIngredientSelected(ingredientItem.name);
    updateFormatValue(ingredientItem.format);
    ingOptional.value = ingredientItem.isOptional;
    updateQtdValue(ingredientItem.qtd.toString());
    updateMeasureValue(ingredientItem.measure);
    clearErrorText();
    ingredientItemSelected = ingredientItem;
  }

  initializeSubTopic(IngredientItem ingredientItem) {
    updateSubtopicValue(ingredientItem.name);
    ingredientItemSelected = ingredientItem;
  }

  deleteIngredientItem() {
    if (ingredientItemSelected != null) {
      var index = listItems.indexWhere(
          (item) => item.toString() == ingredientItemSelected.toString());
      listItems.removeAt(index);
    }
    wipeData();
    wipeSubtopicData();
  }

  wipeData() {
    updateIngredientSelected("");
    updateFormatValue("");
    ingOptional.value = false;
    updateQtdValue("0");
    updateMeasureValue(Measure(name: "", plural: ""));
    clearErrorText();
    ingredientItemSelected = null;
  }

  wipeSubtopicData() {
    updateSubtopicValue("");
    ingredientItemSelected = null;
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
