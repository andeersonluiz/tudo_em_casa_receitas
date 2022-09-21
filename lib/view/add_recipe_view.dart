import 'dart:io';

import 'package:extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:tudo_em_casa_receitas/controller/crud_recipe_controller.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/custom_text_form_field_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/custom_text_recipe_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/app_bar_with_options_widget.dart';

import 'tile/select_ingredient_tile.dart';

class AddRecipeView extends StatelessWidget {
  AddRecipeView({super.key});
  final CrudRecipeController crudRecipeController = Get.find();
  final IngredientController ingredientController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWithOptions(text: "Adicionar Receita"),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(24.0),
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
                              color: CustomTheme.thirdColor,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (image == null) return;

                                crudRecipeController
                                    .updatePhotoName(image.name);
                                crudRecipeController
                                    .updatePhotoSelected(image.path);
                              },
                              shape: GFButtonShape.pills,
                              child: Text(
                                crudRecipeController.photoName.value == ""
                                    ? "Carregar imagem"
                                    : "Carregar nova imagem",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ),
                        crudRecipeController.photoName.value != ""
                            ? Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GFButton(
                                    size: GFSize.MEDIUM,
                                    color: CustomTheme.thirdColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    onPressed: () async {
                                      crudRecipeController.updatePhotoName("");
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
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Selecione o tempo de preparo",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  fontFamily:
                                                      "CostaneraAltBook",
                                                  color:
                                                      CustomTheme.thirdColor),
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
                                                    onChanged: crudRecipeController
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
                                                    infiniteLoop: true,
                                                    onChanged: crudRecipeController
                                                        .updateMinutesPreparationTimeTemp),
                                              ],
                                            );
                                          }),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: GFButton(
                                                size: GFSize.LARGE,
                                                color: CustomTheme.thirdColor,
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                      borderRadius: BorderRadius.circular(25.0),
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
                                crudRecipeController.updateYieldValueTemp(
                                    crudRecipeController.yieldValue.value);
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Selecione o número de porções",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  fontFamily:
                                                      "CostaneraAltBook",
                                                  color:
                                                      CustomTheme.thirdColor),
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
                                              onChanged: crudRecipeController
                                                  .updateYieldValueTemp,
                                            );
                                          }),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: GFButton(
                                                size: GFSize.LARGE,
                                                color: CustomTheme.thirdColor,
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                  return ReorderableListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    buildDefaultDragHandles: false,
                    onReorder: crudRecipeController.reorderListItems,
                    children: [
                      for (int index = 0;
                          index < crudRecipeController.listItems.length;
                          index += 1)
                        Card(
                          key: Key('$index'),
                          child: InkWell(
                            onTap: () {
                              if (crudRecipeController.listItems[index].qtd ==
                                  -1) {
                                crudRecipeController.initializeSubTopic(
                                    crudRecipeController.listItems[index]);
                                _showDialogSubTopic(context);
                              } else {
                                crudRecipeController.initializeData(
                                    crudRecipeController.listItems[index]);
                                _showDialog(context);
                              }
                            },
                            child: ListTile(
                                trailing: ReorderableDragStartListener(
                                    index: index,
                                    child: const Icon(
                                        Icons.drag_indicator_outlined)),
                                title: crudRecipeController
                                            .listItems[index].qtd ==
                                        -1
                                    ? Text(
                                        crudRecipeController
                                            .listItems[index].name,
                                        style: const TextStyle(
                                            fontFamily: "CostaneraAltBold"),
                                      )
                                    : Text(
                                        crudRecipeController.listItems[index]
                                            .toString(),
                                      )),
                          ),
                        )
                    ],
                  );
                }),
                Row(
                  children: [
                    Expanded(
                      child: GFButton(
                        size: GFSize.MEDIUM,
                        color: CustomTheme.thirdColor,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        onPressed: () {
                          _showDialog(context);
                        },
                        text: "Adicionar ingrediente",
                        shape: GFButtonShape.pills,
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        "ou",
                        style: TextStyle(
                            fontFamily: "CostaneraAltMedium", fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: GFButton(
                        size: GFSize.MEDIUM,
                        color: CustomTheme.thirdColor,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        onPressed: () {
                          _showDialogSubTopic(context);
                        },
                        text: "Criar subtópico",
                        shape: GFButtonShape.pills,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
        ));
  }

  void _showDialogSubTopic(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: formKey,
            child: AlertDialog(
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
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await Future.delayed(
                                const Duration(milliseconds: 100));
                            crudRecipeController.wipeSubtopicData();
                          },
                          icon: const Icon(Icons.close,
                              color: CustomTheme.thirdColor))),
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
                        color: CustomTheme.thirdColor,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await Future.delayed(
                              const Duration(milliseconds: 100));
                          crudRecipeController.deleteIngredientItem();
                        },
                        textColor: CustomTheme.thirdColor,
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
                        color: CustomTheme.thirdColor,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            Navigator.of(context).pop();
                            crudRecipeController.addSubtopicToList();
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
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await Future.delayed(
                                          const Duration(milliseconds: 100));
                                      crudRecipeController.wipeData();
                                    },
                                    icon: const Icon(Icons.close,
                                        color: CustomTheme.thirdColor))),
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
                                    title: Row(children: [
                                      const CustomTextRecipeTile(
                                        text: "Selecione o Ingrediente",
                                        color: Colors.red,
                                        required: false,
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(Icons.clear,
                                            color: CustomTheme.thirdColor),
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
                                border:
                                    Border.all(color: CustomTheme.greyColor),
                              ),
                              child: Center(
                                child: Text(
                                  crudRecipeController.ingredientSelected.value
                                      .capitalizeFirstLetter(),
                                  style: const TextStyle(
                                      fontFamily: "CostaneraAltBook",
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
                                              : CustomTheme.thirdColor,
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
                                            .qtdValue
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
                                                title: Row(children: [
                                                  const CustomTextRecipeTile(
                                                    text: "Selecione a medida",
                                                    color: Colors.red,
                                                    required: false,
                                                  ),
                                                  const Spacer(),
                                                  IconButton(
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        const BoxConstraints(),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: const Icon(
                                                        Icons.clear,
                                                        color: CustomTheme
                                                            .thirdColor),
                                                  )
                                                ]),
                                                content: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: SelectIngredientTile(
                                                    hintText:
                                                        "Buscar medida...",
                                                    list: ingredientController
                                                        .listMeasures,
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
                                                color: CustomTheme.greyColor),
                                          ),
                                          child: Center(
                                            child: Text(
                                              crudRecipeController
                                                  .measureSelected.value.name
                                                  .capitalizeFirstLetter(),
                                              style: const TextStyle(
                                                  fontFamily:
                                                      "CostaneraAltBook",
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
                                style: const TextStyle(
                                    fontFamily: "CostaneraAltBook",
                                    fontSize: 11,
                                    color: CustomTheme.thirdColor),
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
                            color: CustomTheme.thirdColor,
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await Future.delayed(
                                  const Duration(milliseconds: 100));
                              crudRecipeController.deleteIngredientItem();
                            },
                            textColor: CustomTheme.thirdColor,
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
                            color: CustomTheme.thirdColor,
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
