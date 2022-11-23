import 'dart:io';

import 'package:extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:tudo_em_casa_receitas/controller/crud_recipe_controller.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_item.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/custom_text_form_field_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/custom_text_recipe_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/error_text_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/select_multiples_itens.dart';
import 'package:tudo_em_casa_receitas/view/widgets/app_bar_with_options_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/bottom_navigator_recipe_widget.dart';

import 'tile/select_ingredient_tile.dart';

class AddRecipeView extends StatelessWidget {
  AddRecipeView({super.key});
  final CrudRecipeController crudRecipeController = Get.find();
  final IngredientController ingredientController = Get.find();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return Scaffold(
        appBar: AppBarWithOptions(text: "Adicionar Receita"),
        body: SafeArea(
          child: SingleChildScrollView(physics: const BouncingScrollPhysics(),
              child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: CustomTextRecipeTile(
                        text: "Nome da Receita",
                      )),
                  CustomTextFormFieldTile(
                      hintText: "Digite o nome da Receita...",
                      labelText: "",
                      autovalidateMode: null,
                      padding: EdgeInsets.zero,
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                      validator: (string) {
                        if (string == "") {
                          return "Nome da receita não pode ser vazio";
                        } else if (string!.length > 50) {
                          return "Nome da receita deve ter menos que 50 caracteres";
                        }
                        return null;
                      },
                      onChanged: crudRecipeController.updateRecipeTitle),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Align(
                        alignment: Alignment.center,
                        child: CustomTextRecipeTile(
                          text: "Foto",
                        )),
                  ),
                  Obx(() {
                    return crudRecipeController.errorimageText.value != ""
                        ? ErrorTextTile(
                            text: crudRecipeController.errorimageText.value)
                        : Container();
                  }),
                  Obx(() {
                    if (crudRecipeController.photoSelected.value != "") {
                      return SizedBox(
                          height: 150,
                          width: 300, //MUDAR DPS COM BASE NO PERFIL
                          child: Image.file(
                              File(crudRecipeController.photoSelected.value),
                              fit: BoxFit.cover));
                    }
                    return Container();
                  }),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Obx(() {
                      return Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GFButton(
                                size: GFSize.MEDIUM,
                                color: Theme.of(context).secondaryHeaderColor,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? image = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (image == null) return;

                                  crudRecipeController
                                      .updatePhotoSelected(image.path);
                                },
                                shape: GFButtonShape.pills,
                                child: Text(
                                  crudRecipeController.photoSelected.value == ""
                                      ? "Carregar imagem"
                                      : "Carregar nova imagem",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ),
                          crudRecipeController.photoSelected.value != ""
                              ? Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GFButton(
                                      size: GFSize.MEDIUM,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();

                                        crudRecipeController
                                            .updatePhotoSelected("");
                                      },
                                      shape: GFButtonShape.pills,
                                      child: const Text(
                                        "Remover Imagem",
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      );
                    }),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CustomTextRecipeTile(
                                text: "Tempo de preparo",
                                fontSize: 16,
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(25.0),
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  crudRecipeController
                                      .updateHourPreparationTimeTemp(
                                          crudRecipeController
                                              .hourPreparationTime.value);
                                  crudRecipeController
                                      .updateMinutesPreparationTimeTemp(
                                          crudRecipeController
                                              .minutesPreparationTime.value);
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Theme.of(context)
                                          .bottomSheetTheme
                                          .backgroundColor,
                                      builder: (context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Selecione o tempo de preparo",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    fontFamily:
                                                        "CostaneraAltBook",
                                                    color: context.theme
                                                        .dialogBackgroundColor),
                                              ),
                                            ),
                                            Obx(() {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  NumberPicker(
                                                      value: crudRecipeController
                                                          .hourPreparationTimeTemp
                                                          .value,
                                                      minValue: 0,
                                                      maxValue: 23,
                                                      infiniteLoop: true,
                                                      textMapper: (value) {
                                                        return "${value}h";
                                                      },
                                                      selectedTextStyle:
                                                          const TextStyle(
                                                              fontSize: 25,
                                                              color: CustomTheme
                                                                  .thirdColor),
                                                      onChanged:
                                                          crudRecipeController
                                                              .updateHourPreparationTimeTemp),
                                                  NumberPicker(
                                                      value: crudRecipeController
                                                          .minutesPreparationTimeTemp
                                                          .value,
                                                      minValue: 0,
                                                      maxValue: 59,
                                                      textMapper: (value) {
                                                        return "${value}m";
                                                      },
                                                      selectedTextStyle:
                                                          const TextStyle(
                                                              fontSize: 25,
                                                              color: CustomTheme
                                                                  .thirdColor),
                                                      infiniteLoop: true,
                                                      onChanged:
                                                          crudRecipeController
                                                              .updateMinutesPreparationTimeTemp),
                                                ],
                                              );
                                            }),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: GFButton(
                                                  size: GFSize.LARGE,
                                                  color: context.theme
                                                      .secondaryHeaderColor,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 32),
                                                  onPressed: () {
                                                    crudRecipeController
                                                        .updateHourPreparationTime();
                                                    crudRecipeController
                                                        .updateMinutesPreparationTime();
                                                    Navigator.of(context).pop();
                                                  },
                                                  text: "Confirmar",
                                                  shape: GFButtonShape.pills,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Obx(() {
                                  int hourPrep = crudRecipeController
                                      .hourPreparationTime.value;
                                  int minPrep = crudRecipeController
                                      .minutesPreparationTime.value;

                                  return Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        border: Border.all(
                                            color: CustomTheme.greyColor)),
                                    child: Center(
                                        child: minPrep == 0 && hourPrep == 0
                                            ? const Text("")
                                            : hourPrep == 0
                                                ? Text(
                                                    "$minPrep min",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            "CostaneraAltBook",
                                                        fontSize: 18),
                                                  )
                                                : Text(
                                                    "${hourPrep}h ${minPrep}min",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            "CostaneraAltBook",
                                                        fontSize: 18),
                                                  )),
                                  );
                                }),
                              ),
                              Obx(() {
                                return crudRecipeController
                                            .errorTimePreparationText.value !=
                                        ""
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ErrorTextTile(
                                            text: crudRecipeController
                                                .errorTimePreparationText
                                                .value),
                                      )
                                    : Container();
                              }),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CustomTextRecipeTile(
                                text: "Número de porções",
                                fontSize: 16,
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(25.0),
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  crudRecipeController.updateYieldValueTemp(
                                      crudRecipeController.yieldValue.value);
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Theme.of(context)
                                          .bottomSheetTheme
                                          .backgroundColor,
                                      builder: (context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Selecione o número de porções",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    fontFamily:
                                                        "CostaneraAltBook",
                                                    color: context.theme
                                                        .dialogBackgroundColor),
                                              ),
                                            ),
                                            Obx(() {
                                              return NumberPicker(
                                                value: crudRecipeController
                                                    .yieldValueTemp.value,
                                                minValue: 0,
                                                maxValue: 100,
                                                itemWidth: 200,
                                                textMapper: (value) {
                                                  if (int.parse(value) <= 1) {
                                                    return "$value porção";
                                                  }
                                                  return "$value porções";
                                                },
                                                selectedTextStyle:
                                                    const TextStyle(
                                                        fontSize: 25,
                                                        color: CustomTheme
                                                            .thirdColor),
                                                onChanged: crudRecipeController
                                                    .updateYieldValueTemp,
                                              );
                                            }),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: GFButton(
                                                  size: GFSize.LARGE,
                                                  color: context.theme
                                                      .secondaryHeaderColor,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 32),
                                                  onPressed: () {
                                                    crudRecipeController
                                                        .updateYieldValue();
                                                    Navigator.of(context).pop();
                                                  },
                                                  text: "Confirmar",
                                                  shape: GFButtonShape.pills,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Obx(() {
                                  int yieldValue =
                                      crudRecipeController.yieldValue.value;
                                  return Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          border: Border.all(
                                              color: CustomTheme.greyColor)),
                                      child: Center(
                                        child: yieldValue == 0
                                            ? const Text("")
                                            : yieldValue == 1
                                                ? Text("$yieldValue porção",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            "CostaneraAltBook",
                                                        fontSize: 18))
                                                : Text("$yieldValue porções",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            "CostaneraAltBook",
                                                        fontSize: 18)),
                                      ));
                                }),
                              ),
                              Obx(() {
                                return crudRecipeController
                                            .errorYieldText.value !=
                                        ""
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ErrorTextTile(
                                            text: crudRecipeController
                                                .errorYieldText.value),
                                      )
                                    : Container();
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const CustomTextRecipeTile(
                    text: "Ingredientes",
                  ),
                  Obx(() {
                    return crudRecipeController.errorIngredientsText.value != ""
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ErrorTextTile(
                                text: crudRecipeController
                                    .errorIngredientsText.value),
                          )
                        : Container();
                  }),
                  Obx(() {
                    return ReorderableListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      buildDefaultDragHandles: true,
                      onReorder: crudRecipeController.reorderListItems,
                      children: [
                        for (int index = 0;
                            index < crudRecipeController.listItems.length;
                            index += 1)
                          Card(
                            key: Key('$index'),
                            child: InkWell(
                              onTap: () {
                                if (crudRecipeController.listItems[index]
                                    is IngredientItem) {
                                  if (!crudRecipeController
                                          .listItems[index].isSelected &&
                                      crudRecipeController
                                          .listIngredientsSelected.isNotEmpty &&
                                      !crudRecipeController
                                          .listItems[index].isSubtopic) {
                                    crudRecipeController
                                        .addIngredientItemSelected(
                                            crudRecipeController
                                                .listItems[index]);
                                  } else if (crudRecipeController
                                      .listItems[index].isSelected) {
                                    crudRecipeController
                                        .removeIngredientItemSelected(
                                            crudRecipeController
                                                .listItems[index]);
                                  } else if (crudRecipeController
                                          .listItems[index].isSubtopic &&
                                      crudRecipeController
                                          .listIngredientsSelected.isNotEmpty) {
                                    GFToast.showToast(
                                        backgroundColor: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .color!,
                                        textStyle: TextStyle(
                                          color: Theme.of(context)
                                              .bottomSheetTheme
                                              .backgroundColor,
                                        ),
                                        toastDuration: 3,
                                        toastPosition: GFToastPosition.BOTTOM,
                                        "Não é possivel selecionar subtópico",
                                        context);
                                  } else if (crudRecipeController
                                      .listItems[index].isSubtopic) {
                                    crudRecipeController.initializeSubTopic(
                                        crudRecipeController.listItems[index]);
                                    _showDialogSubTopic(context);
                                  } else {
                                    crudRecipeController.initializeData(
                                        crudRecipeController.listItems[index]);
                                    _showDialog(context);
                                  }
                                } else {
                                  if (crudRecipeController
                                      .listIngredientsSelected.isEmpty) {
                                    GFToast.showToast(
                                        backgroundColor: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .color!,
                                        textStyle: TextStyle(
                                          color: Theme.of(context)
                                              .bottomSheetTheme
                                              .backgroundColor,
                                        ),
                                        toastDuration: 3,
                                        toastPosition: GFToastPosition.BOTTOM,
                                        "Não é possivel visualizar ingredientes compostos, desagrupe primeiro",
                                        context);
                                  } else if (!crudRecipeController
                                      .listItems[index]
                                      .every((e) => e.isSelected as bool)) {
                                    crudRecipeController
                                        .addIngredientListItemSelected(
                                            crudRecipeController
                                                .listItems[index]);
                                  } else {
                                    crudRecipeController
                                        .removeIngredientListItemSelected(
                                            crudRecipeController
                                                .listItems[index]);
                                  }
                                }
                              },
                              onLongPress: (() {
                                if (crudRecipeController.listItems[index]
                                    is IngredientItem) {
                                  if (!crudRecipeController
                                          .listItems[index].isSubtopic &&
                                      !crudRecipeController
                                          .listItems[index].isSelected) {
                                    crudRecipeController
                                        .addIngredientItemSelected(
                                            crudRecipeController
                                                .listItems[index]);
                                  } else if (!crudRecipeController
                                          .listItems[index].isSubtopic &&
                                      crudRecipeController
                                          .listItems[index].isSelected) {
                                    crudRecipeController
                                        .removeIngredientItemSelected(
                                            crudRecipeController
                                                .listItems[index]);
                                  }
                                } else {
                                  if (!crudRecipeController.listItems[index]
                                      .every((e) => e.isSelected as bool)) {
                                    crudRecipeController
                                        .addIngredientListItemSelected(
                                            crudRecipeController
                                                .listItems[index]);
                                  } else {
                                    crudRecipeController
                                        .removeIngredientListItemSelected(
                                            crudRecipeController
                                                .listItems[index]);
                                  }
                                }
                              }),
                              child: crudRecipeController.listItems[index]
                                      is IngredientItem
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: crudRecipeController
                                                  .listItems[index].isSelected
                                              ? Colors.blueAccent
                                                  .withOpacity(0.2)
                                              : Colors.transparent,
                                          border: Border.all(
                                              color: crudRecipeController
                                                      .listItems[index].hasError
                                                  ? Colors.red
                                                  : crudRecipeController
                                                          .listItems[index]
                                                          .isRevision
                                                      ? Colors.yellow
                                                      : Colors.transparent)),
                                      child: ListTile(
                                          trailing: ReorderableDragStartListener(
                                              index: index,
                                              child: const Icon(Icons
                                                  .drag_indicator_outlined)),
                                          title: crudRecipeController
                                                  .listItems[index].isSubtopic
                                              ? Text(
                                                  crudRecipeController
                                                      .listItems[index].name,
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          "CostaneraAltBold"),
                                                )
                                              : Text(crudRecipeController
                                                  .listItems[index]
                                                  .toString())),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: crudRecipeController
                                                  .listItems[index]
                                                  .every((e) {
                                            return e.isSelected as bool;
                                          })
                                              ? Colors.blueAccent
                                                  .withOpacity(0.2)
                                              : Colors.transparent,
                                          border: Border.all(
                                              color: crudRecipeController
                                                      .listItems[index]
                                                      .any((element) =>
                                                          element.hasError ==
                                                          true)
                                                  ? Colors.red
                                                  : crudRecipeController
                                                          .listItems[index]
                                                          .any((element) =>
                                                              element
                                                                  .isRevision ==
                                                              true)
                                                      ? Colors.yellow
                                                      : Colors.transparent)),
                                      child: ListTile(
                                          trailing: ReorderableDragStartListener(
                                              index: index,
                                              child: const Icon(Icons
                                                  .drag_indicator_outlined)),
                                          title: Text(crudRecipeController
                                              .listItems[index]
                                              .map<String>(
                                                (e) {
                                                  return e.toString();
                                                },
                                              )
                                              .toList()
                                              .join(" ou "))),
                                    ),
                            ),
                          )
                      ],
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: GFButton(
                            size: GFSize.MEDIUM,
                            color: Theme.of(context).secondaryHeaderColor,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            onPressed: () {
                              _showDialog(context);
                            },
                            text: "Adicionar ingrediente",
                            shape: GFButtonShape.pills,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            "ou",
                            style: TextStyle(
                                fontFamily: "CostaneraAltMedium", fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: GFButton(
                            size: GFSize.MEDIUM,
                            color: Theme.of(context).secondaryHeaderColor,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            onPressed: () {
                              _showDialogSubTopic(context);
                            },
                            text: "Criar subtópico",
                            shape: GFButtonShape.pills,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CustomTextRecipeTile(
                    text: "Preparação",
                  ),
                  Obx(() {
                    return crudRecipeController.errorPreparationText.value != ""
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ErrorTextTile(
                                text: crudRecipeController
                                    .errorPreparationText.value),
                          )
                        : Container();
                  }),
                  Obx(() {
                    return ReorderableListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      buildDefaultDragHandles: false,
                      onReorder: crudRecipeController.reorderListPreparations,
                      children: [
                        for (int index = 0;
                            index <
                                crudRecipeController.listPreparations.length;
                            index += 1)
                          Card(
                            key: Key('$index prep'),
                            child: InkWell(
                                onTap: () {
                                  if (crudRecipeController
                                      .listPreparations[index].isSubtopic) {
                                    crudRecipeController
                                        .initializeSubTopicPreparation(
                                            crudRecipeController
                                                .listPreparations[index]);
                                    _showDialogSubTopic(context,
                                        isPreparation: true);
                                  } else {
                                    crudRecipeController
                                        .initializeDataPreparation(
                                            crudRecipeController
                                                .listPreparations[index]);
                                    _showDialogPreparation(context);
                                  }
                                },
                                child: ListTile(
                                    trailing: ReorderableDragStartListener(
                                        index: index,
                                        child: const Icon(
                                            Icons.drag_indicator_outlined)),
                                    title: crudRecipeController
                                            .listPreparations[index].isSubtopic
                                        ? Text(
                                            crudRecipeController
                                                .listPreparations[index]
                                                .description,
                                            style: const TextStyle(
                                                fontFamily: "CostaneraAltBold"),
                                          )
                                        : Text(crudRecipeController
                                            .listPreparations[index]
                                            .description))),
                          )
                      ],
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: GFButton(
                            size: GFSize.MEDIUM,
                            color: Theme.of(context).secondaryHeaderColor,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            onPressed: () {
                              _showDialogPreparation(context);
                            },
                            text: "Adicionar descrição",
                            shape: GFButtonShape.pills,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            "ou",
                            style: TextStyle(
                                fontFamily: "CostaneraAltMedium", fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: GFButton(
                            size: GFSize.MEDIUM,
                            color: Theme.of(context).secondaryHeaderColor,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            onPressed: () {
                              _showDialogSubTopic(context, isPreparation: true);
                            },
                            text: "Criar subtópico",
                            shape: GFButtonShape.pills,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CustomTextRecipeTile(
                    text: "Categorias Relacionadas (Min. 3)",
                  ),
                  Obx(() {
                    return crudRecipeController.errorCategoriesText.value != ""
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ErrorTextTile(
                                text: crudRecipeController
                                    .errorCategoriesText.value),
                          )
                        : Container();
                  }),
                  Obx(() {
                    bool hasError = crudRecipeController.listCategoriesSelected
                        .any((element) => element.hasError == true);
                    bool hasRevision = crudRecipeController
                        .listCategoriesSelected
                        .any((element) => element.isRevision == true);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: hasError || hasRevision ? 2 : 1,
                              color: hasError
                                  ? Colors.red
                                  : hasRevision
                                      ? Colors.yellow.shade700
                                      : Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .color!
                                          .withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: crudRecipeController
                                .listCategoriesSelected.isEmpty
                            ? const Center(
                                child: Text("Não há categorias selecionadas",
                                    style: TextStyle(
                                        fontFamily: "CostaneraAltBook",
                                        fontSize: 15)))
                            : Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: crudRecipeController
                                    .listCategoriesSelected
                                    .map((element) => Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 8),
                                          decoration: BoxDecoration(
                                              color: context
                                                  .theme.secondaryHeaderColor,
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Text(
                                              element.name
                                                  .toString()
                                                  .toLowerCase()
                                                  .capitalizeFirstLetter(),
                                              style: const TextStyle(
                                                  fontFamily:
                                                      "CostaneraAltBook",
                                                  color: Colors.white)),
                                        ))
                                    .toList(),
                              ),
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GFButton(
                      size: GFSize.MEDIUM,
                      color: Theme.of(context).secondaryHeaderColor,
                      blockButton: true,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                backgroundColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Theme.of(context).colorScheme.background
                                    : Colors.white,
                                title: Row(children: [
                                  Obx(() {
                                    return CustomTextRecipeTile(
                                      text:
                                          "Selecione a(s) categoria(s) (${crudRecipeController.listCategoriesSelected.length})",
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontSize: 15,
                                      required: false,
                                    );
                                  }),
                                  const Spacer(),
                                  IconButton(
                                    splashColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    icon: Icon(Icons.close,
                                        color: Theme.of(context)
                                            .dialogBackgroundColor),
                                  )
                                ]),
                                content: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: SelectMultipleItens(
                                        list: ingredientController
                                            .listCategories)),
                                actions: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: GFButton(
                                        size: GFSize.MEDIUM,
                                        color: Theme.of(context)
                                            .dialogBackgroundColor,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                        },
                                        textColor: Theme.of(context)
                                            .dialogBackgroundColor,
                                        type: GFButtonType.outline,
                                        shape: GFButtonShape.pills,
                                        child: const Text(
                                          "Fechar",
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      shape: GFButtonShape.pills,
                      child: const Text(
                        "Adicionar/Remover categoria",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
        bottomNavigationBar: Obx(() {
          return BottomNavigatorRecipeWidget(
            onPressedPreview: () {
              Get.toNamed("${Routes.RECIPE_VIEW}/-1", arguments: {
                "recipe": crudRecipeController.generateRecipe()!.toJson(),
                "isMyRecipe": true,
                "isPreview": true,
              });
            },
            isLoading: crudRecipeController.isLoading.value,
            onPressedSend: () async {
              crudRecipeController.clearErrors();
              if (formKey.currentState!.validate() &&
                  crudRecipeController.validateRecipe()) {
                var result = await crudRecipeController.sendRecipe();
                if (result == "confirm") {
                  showDialog(
                      context: context,
                      builder: ((ctx) {
                        return AlertDialog(
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Theme.of(context).colorScheme.background
                                  : Colors.white,
                          title: const CustomTextRecipeTile(
                            text: "Confirmar envio",
                            required: false,
                          ),
                          content: const Text(
                              "A receita possui itens em revisão, para receita estar disponivel para outras pessoas verem é necessario aguarder 3 dias para validarmos os itens que estão em revisão, nesse meio tempo sua receita estara salva e você será notificado se a receita for aceita ou rejeitada. Deseja enviar a receita?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: GFButton(
                                    size: GFSize.MEDIUM,
                                    color:
                                        Theme.of(context).dialogBackgroundColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                    textColor:
                                        Theme.of(context).dialogBackgroundColor,
                                    type: GFButtonType.outline,
                                    shape: GFButtonShape.pills,
                                    child: const Text(
                                      "Revisar itens",
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Obx(() {
                                    return GFButton(
                                      size: GFSize.MEDIUM,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      onPressed: crudRecipeController
                                              .isLoadingConfirm.value
                                          ? null
                                          : () async {
                                              if (!mounted) return;
                                              Navigator.of(context).pop();
                                              var result =
                                                  await crudRecipeController
                                                      .sendRecipe(
                                                          confirmed: true);

                                              if (result == "") {
                                                Get.back();
                                                // ignore: use_build_context_synchronously
                                                GFToast.showToast(
                                                    backgroundColor: context
                                                        .theme
                                                        .textTheme
                                                        .titleMedium!
                                                        .color!,
                                                    textStyle: TextStyle(
                                                      color: context
                                                          .theme
                                                          .bottomSheetTheme
                                                          .backgroundColor,
                                                    ),
                                                    toastDuration: 3,
                                                    toastPosition:
                                                        GFToastPosition.BOTTOM,
                                                    "Receita enviada com sucesso",
                                                    context);
                                              } else {
                                                // ignore: use_build_context_synchronously
                                                GFToast.showToast(
                                                    backgroundColor: context
                                                        .theme
                                                        .textTheme
                                                        .titleMedium!
                                                        .color!,
                                                    textStyle: TextStyle(
                                                      color: context
                                                          .theme
                                                          .bottomSheetTheme
                                                          .backgroundColor,
                                                    ),
                                                    toastDuration: 3,
                                                    toastPosition:
                                                        GFToastPosition.BOTTOM,
                                                    result,
                                                    context);
                                              }
                                            },
                                      shape: GFButtonShape.pills,
                                      child: Text(
                                        "Enviar receita",
                                        textAlign: TextAlign.center,
                                        style: crudRecipeController
                                                .isLoadingConfirm.value
                                            ? const TextStyle(
                                                color: Colors.white60)
                                            : null,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            )
                          ],
                        );
                      }));
                } else if (result == "") {
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  GFToast.showToast(
                      backgroundColor:
                          Theme.of(context).textTheme.titleMedium!.color!,
                      textStyle: TextStyle(
                        color:
                            Theme.of(context).bottomSheetTheme.backgroundColor,
                      ),
                      toastDuration: 3,
                      toastPosition: GFToastPosition.BOTTOM,
                      "Receita enviada com sucesso",
                      context);
                } else {
                  if (!mounted) return;
                  GFToast.showToast(
                      backgroundColor:
                          Theme.of(context).textTheme.titleMedium!.color!,
                      textStyle: TextStyle(
                        color:
                            Theme.of(context).bottomSheetTheme.backgroundColor,
                      ),
                      toastDuration: 3,
                      toastPosition: GFToastPosition.BOTTOM,
                      result,
                      context);
                }
              } else {
                GFToast.showToast(
                    backgroundColor:
                        Theme.of(context).textTheme.titleMedium!.color!,
                    textStyle: TextStyle(
                      color: Theme.of(context).bottomSheetTheme.backgroundColor,
                    ),
                    toastDuration: 3,
                    toastPosition: GFToastPosition.BOTTOM,
                    "Há erros no preenchimento dos campos",
                    context);
              }
            },
            textSend: "Enviar Receita",
          );
        }));
  }

  void _showDialogSubTopic(BuildContext context, {bool isPreparation = false}) {
    final formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: formKey,
            child: AlertDialog(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.background
                  : Colors.white,
              title: Stack(
                children: [
                  const Center(
                      child: CustomTextRecipeTile(
                    text: "Digite o subtópico",
                    required: false,
                  )),
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          splashColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await Future.delayed(
                                const Duration(milliseconds: 100));
                            crudRecipeController.wipeSubtopicData();
                          },
                          icon: Icon(Icons.close,
                              color: Theme.of(context).dialogBackgroundColor))),
                ],
              ),
              content: CustomTextFormFieldTile(
                hintText: "Massa, Cobertura, Molho, etc...",
                labelText: "",
                initialValue: crudRecipeController.subtopicValue.value,
                keyboardType: TextInputType.name,
                validator: (string) {
                  if (string == "") {
                    return "Subtópico não pode ser vazio";
                  } else if (string!.length > 20) {
                    return "Tamanho deve ser menor que 20 caracteres";
                  }
                  return null;
                },
                onChanged: crudRecipeController.updateSubtopicValue,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GFButton(
                        size: GFSize.MEDIUM,
                        color: Theme.of(context).dialogBackgroundColor,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await Future.delayed(
                              const Duration(milliseconds: 100));
                          isPreparation
                              ? crudRecipeController.deletePreparationItem()
                              : crudRecipeController.deleteIngredientItem();
                        },
                        textColor: Theme.of(context).dialogBackgroundColor,
                        type: GFButtonType.outline,
                        shape: GFButtonShape.pills,
                        child: const Text(
                          "Excluir",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Center(
                      child: GFButton(
                        size: GFSize.MEDIUM,
                        color: Theme.of(context).secondaryHeaderColor,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            Navigator.of(context).pop();
                            isPreparation
                                ? crudRecipeController
                                    .addSubtopicToListPreparation()
                                : crudRecipeController.addSubtopicToList();
                            await Future.delayed(
                                const Duration(milliseconds: 100));
                            crudRecipeController.wipeSubtopicData();
                          }
                        },
                        shape: GFButtonShape.pills,
                        child: const Text(
                          "Confirmar",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  void _showDialogPreparation(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: formKey,
            child: AlertDialog(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.background
                  : Colors.white,
              title: Stack(
                children: [
                  const Center(
                      child: CustomTextRecipeTile(
                    text: "Digite a descrição",
                    required: false,
                  )),
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          splashColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await Future.delayed(
                                const Duration(milliseconds: 100));
                            crudRecipeController.wipeData();
                          },
                          icon: Icon(Icons.close,
                              color: Theme.of(context).dialogBackgroundColor))),
                ],
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomTextFormFieldTile(
                  hintText: "Digite a descrição da receita",
                  labelText: "",
                  initialValue: crudRecipeController.descriptionValue.value,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  contentPadding: const EdgeInsets.all(12),
                  padding: EdgeInsets.zero,
                  validator: (string) {
                    if (string == "") {
                      return "Descrição não pode ser vazio";
                    } else if (string!.length > 100) {
                      return "Tamanho deve ser menor que 100 caracteres";
                    }
                    return null;
                  },
                  onChanged: crudRecipeController.updateDescriptionValue,
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GFButton(
                        size: GFSize.MEDIUM,
                        color: Theme.of(context).dialogBackgroundColor,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await Future.delayed(
                              const Duration(milliseconds: 100));
                          crudRecipeController.deletePreparationItem();
                        },
                        textColor: Theme.of(context).dialogBackgroundColor,
                        type: GFButtonType.outline,
                        shape: GFButtonShape.pills,
                        child: const Text(
                          "Excluir",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Center(
                      child: GFButton(
                        size: GFSize.MEDIUM,
                        color: Theme.of(context).secondaryHeaderColor,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (crudRecipeController.validatePreparation()) {
                              Navigator.of(context).pop();
                              await Future.delayed(
                                  const Duration(milliseconds: 100));
                              crudRecipeController.wipeData();
                            }
                          }
                        },
                        shape: GFButtonShape.pills,
                        child: const Text(
                          "Confirmar",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  void _showDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: AlertDialog(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).colorScheme.background
                          : Colors.white,
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            const Align(
                                alignment: Alignment.center,
                                child: CustomTextRecipeTile(
                                  text: "Nome",
                                  required: false,
                                )),
                            Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    splashColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await Future.delayed(
                                          const Duration(milliseconds: 100));
                                      crudRecipeController.wipeData();
                                    },
                                    icon: Icon(Icons.close,
                                        color: context
                                            .theme.dialogBackgroundColor))),
                          ],
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(25.0),
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    backgroundColor:
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Theme.of(context)
                                                .colorScheme
                                                .background
                                            : Colors.white,
                                    title: Row(children: [
                                      CustomTextRecipeTile(
                                        text: "Selecione o Ingrediente",
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        required: false,
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        splashColor: Colors.transparent,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        icon: Icon(Icons.close,
                                            color: context
                                                .theme.dialogBackgroundColor),
                                      )
                                    ]),
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: SelectIngredientTile(
                                        hintText: "Buscar ingredientes...",
                                        isIngredient: true,
                                        list: ingredientController
                                            .listIngredients,
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Obx(() {
                            return Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(
                                    color: crudRecipeController
                                            .ingredientSelected.value.hasError
                                        ? Colors.red
                                        : crudRecipeController
                                                .ingredientSelected
                                                .value
                                                .isRevision
                                            ? Colors.yellow[700]!
                                            : Colors.grey.shade500),
                              ),
                              child: Center(
                                child: Text(
                                  crudRecipeController
                                      .ingredientSelected.value.name
                                      .toString()
                                      .capitalizeFirstLetter(),
                                  style: TextStyle(
                                      fontFamily: crudRecipeController
                                              .isIngredientRevision
                                          ? "CostaneraAltBold"
                                          : "CostaneraAltBook",
                                      color: crudRecipeController
                                              .isIngredientRevision
                                          ? Colors.yellow[700]
                                          : Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .color,
                                      fontSize: 17),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(() {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 55,
                                child: Column(
                                  children: [
                                    const Align(
                                        alignment: Alignment.center,
                                        child: CustomTextRecipeTile(
                                          text: "Formato",
                                          required: false,
                                        )),
                                    crudRecipeController.ingOptional.value
                                        ? Container(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                color: CustomTheme.greyColor,
                                                border: Border.all(
                                                    color:
                                                        CustomTheme.greyColor)),
                                            child: const Center(
                                                child: Text(
                                              "a gosto",
                                              style: TextStyle(
                                                fontFamily: "CostaneraAltBook",
                                              ),
                                            )),
                                          )
                                        : CustomTextFormFieldTile(
                                            hintText:
                                                "Em pedaços/ cortado(a) / esfarelado(a)...",
                                            labelText: "",
                                            initialValue: crudRecipeController
                                                .formartValue
                                                .toString(),
                                            autovalidateMode: null,
                                            padding: EdgeInsets.zero,
                                            keyboardType: TextInputType.name,
                                            textAlign: TextAlign.center,
                                            validator: (string) {
                                              if (string!.length > 20) {
                                                return "Deve ser menor que 20 caracteres";
                                              }
                                              return null;
                                            },
                                            onChanged: crudRecipeController
                                                .updateFormatValue),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 45,
                                child: Column(
                                  children: [
                                    const Align(
                                        alignment: Alignment.center,
                                        child: CustomTextRecipeTile(
                                          text: "Ing. opcional?",
                                          required: false,
                                          fontSize: 18,
                                        )),
                                    GFButton(
                                      size: GFSize.MEDIUM,
                                      color:
                                          crudRecipeController.ingOptional.value
                                              ? Colors.green
                                              : Theme.of(context)
                                                  .secondaryHeaderColor,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      onPressed: crudRecipeController
                                          .updateIngOptional,
                                      shape: GFButtonShape.pills,
                                      child: Text(
                                        crudRecipeController.ingOptional.value
                                            ? "Sim"
                                            : "Não",
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 55,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  children: [
                                    const Align(
                                        alignment: Alignment.center,
                                        child: CustomTextRecipeTile(
                                          text: "Quantidade",
                                          required: false,
                                        )),
                                    CustomTextFormFieldTile(
                                        hintText: null,
                                        labelText: "",
                                        initialValue: crudRecipeController
                                                    .qtdValue.value ==
                                                0
                                            ? ""
                                            : crudRecipeController.qtdValue
                                                .toString(),
                                        autovalidateMode: null,
                                        textAlign: TextAlign.center,
                                        padding: EdgeInsets.zero,
                                        keyboardType: TextInputType.number,
                                        validator: (string) {
                                          if (int.tryParse(string!) == null) {
                                            return "Deve ser numero inteiro";
                                          }
                                          return null;
                                        },
                                        onChanged: crudRecipeController
                                            .updateQtdValue),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 45,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  children: [
                                    const Align(
                                        alignment: Alignment.center,
                                        child: CustomTextRecipeTile(
                                          text: "Medida",
                                          required: false,
                                        )),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(25.0),
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .background
                                                        : Colors.white,
                                                title: Row(children: [
                                                  CustomTextRecipeTile(
                                                    text: "Selecione a medida",
                                                    color: context.theme
                                                        .secondaryHeaderColor,
                                                    required: false,
                                                  ),
                                                  const Spacer(),
                                                  IconButton(
                                                    splashColor:
                                                        Colors.transparent,
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        const BoxConstraints(),
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    icon: Icon(Icons.close,
                                                        color: Theme.of(context)
                                                            .dialogBackgroundColor),
                                                  )
                                                ]),
                                                content: SizedBox(
                                                  width: MediaQuery.of(ctx)
                                                      .size
                                                      .width,
                                                  child: SelectIngredientTile(
                                                    hintText:
                                                        "Buscar medida...",
                                                    list: ingredientController
                                                        .listMeasures,
                                                    isIngredient: false,
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Obx(() {
                                        return Container(
                                          height: 50,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            border: Border.all(
                                                color: crudRecipeController
                                                        .measureSelected
                                                        .value
                                                        .hasError
                                                    ? Colors.red
                                                    : crudRecipeController
                                                            .measureSelected
                                                            .value
                                                            .isRevision
                                                        ? Colors.yellow[700]!
                                                        : Colors.grey.shade500),
                                          ),
                                          child: Center(
                                            child: Text(
                                              crudRecipeController
                                                  .measureSelected.value.name
                                                  .capitalizeFirstLetter(),
                                              style: TextStyle(
                                                  fontFamily:
                                                      crudRecipeController
                                                              .measureSelected
                                                              .value
                                                              .isRevision
                                                          ? "CostaneraAltBold"
                                                          : "CostaneraAltBook",
                                                  color: crudRecipeController
                                                          .measureSelected
                                                          .value
                                                          .isRevision
                                                      ? Colors.yellow[700]
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .color,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Obx(() {
                          if (crudRecipeController.errorText.value != "") {
                            return Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: Text(
                                crudRecipeController.errorText.value,
                                style: TextStyle(
                                    fontFamily: "CostaneraAltBook",
                                    fontSize: 11,
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                              ),
                            );
                          }
                          return Container();
                        })
                      ],
                    ),
                  ),
                  actionsPadding: const EdgeInsets.only(bottom: 16.0),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GFButton(
                            size: GFSize.MEDIUM,
                            color: Theme.of(context).dialogBackgroundColor,
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await Future.delayed(
                                  const Duration(milliseconds: 100));
                              crudRecipeController.deleteIngredientItem();
                            },
                            textColor: Theme.of(context).dialogBackgroundColor,
                            type: GFButtonType.outline,
                            shape: GFButtonShape.pills,
                            child: const Text(
                              "Excluir",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GFButton(
                            size: GFSize.MEDIUM,
                            color: Theme.of(context).secondaryHeaderColor,
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                if (crudRecipeController.validate()) {
                                  Navigator.of(context).pop();
                                  await Future.delayed(
                                      const Duration(milliseconds: 100));

                                  crudRecipeController.wipeData();
                                }
                              }
                            },
                            shape: GFButtonShape.pills,
                            child: const Text(
                              "Confirmar",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
