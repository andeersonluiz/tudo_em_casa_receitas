import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:tudo_em_casa_receitas/controller/crud_recipe_controller.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/custom_text_form_field_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/custom_text_recipe_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/app_bar_text_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/app_bar_with_options_widget.dart';

class AddRecipeView extends StatelessWidget {
  AddRecipeView({super.key});
  final CrudRecipeController crudRecipeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithOptions(text: "Adicionar Receita"),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: CustomTextRecipeTile(
                      text: "Nome da Receita",
                    )),
                CustomTextFormFieldTile(
                    hintText: "Digite o nome da Receita...",
                    labelText: "",
                    padding: EdgeInsets.zero,
                    keyboardType: TextInputType.name,
                    validator: (string) {},
                    onChanged: (value) {}),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Align(
                      alignment: Alignment.center,
                      child: CustomTextRecipeTile(
                        text: "Foto",
                      )),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GFButton(
                    size: GFSize.MEDIUM,
                    color: CustomTheme.thirdColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    onPressed: () {},
                    text: "Carregar imagem",
                    shape: GFButtonShape.pills,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextRecipeTile(
                              text: "Tempo de preparo",
                              fontSize: 16,
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(25.0),
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                                        .hourPreparationTime
                                                        .value,
                                                    minValue: 0,
                                                    maxValue: 24,
                                                    infiniteLoop: true,
                                                    textMapper: (value) {
                                                      return value + "h";
                                                    },
                                                    onChanged: crudRecipeController
                                                        .updateHourPreparationTime),
                                                NumberPicker(
                                                    value: crudRecipeController
                                                        .minutesPreparationTime
                                                        .value,
                                                    minValue: 0,
                                                    maxValue: 59,
                                                    textMapper: (value) {
                                                      return value + "m";
                                                    },
                                                    infiniteLoop: true,
                                                    onChanged: crudRecipeController
                                                        .updateMinutesPreparationTime),
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
                                                onPressed: () {},
                                                text: "Confirmar",
                                                shape: GFButtonShape.pills,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    border: Border.all(
                                        color: CustomTheme.greyColor)),
                              ),
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
                            CustomTextRecipeTile(
                              text: "Número de porções",
                              fontSize: 16,
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(25.0),
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                          NumberPicker(
                                            value: 0,
                                            minValue: 0,
                                            maxValue: 100,
                                            itemWidth: 200,
                                            textMapper: (value) {
                                              if (int.parse(value) <= 1) {
                                                return value + " porção";
                                              }
                                              return value + " porções";
                                            },
                                            onChanged: (value) => print(value),
                                          ),
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
                                                onPressed: () {},
                                                text: "Confirmar",
                                                shape: GFButtonShape.pills,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    border: Border.all(
                                        color: CustomTheme.greyColor)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
        ));
  }
}
