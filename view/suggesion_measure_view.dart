// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:string_validator/string_validator.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/controller/suggestion_controller.dart';
import 'package:tudo_em_casa_receitas/support/custom_icons_icons.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/custom_text_form_field_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/select_ingredient_tile.dart';

import 'tile/custom_text_recipe_tile.dart';

class SuggestionMeasureView extends StatelessWidget {
  SuggestionMeasureView({super.key, l});
  final SuggestionController suggestionController = Get.find();
  final IngredientController ingredientController = Get.find();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Icon(
                        CustomIcons.logo,
                        color: CustomTheme.thirdColor,
                        size: 150,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 24.0),
                        child: Text(
                          "Faça a sugestão de uma medida",
                          style: TextStyle(
                              fontSize: 19, fontFamily: "CostaneraAltBold"),
                        ),
                      ),
                      CustomTextFormFieldTile(
                          hintText: "Escreva a medida(Singular)",
                          labelText: "Medida(Singular)",
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (string) {
                            if (string == "") {
                              return "Escreva uma medida";
                            } else if (string!.length > 20) {
                              return "Medida deve ter menos que 20 caracteres";
                            } else if (!isAlpha(string)) {
                              return "É aceito apenas texto";
                            }
                            return null;
                          },
                          onChanged:
                              suggestionController.updateMeasureSingularText),
                      CustomTextFormFieldTile(
                          hintText: "Escreva a medida(Plural)",
                          labelText: "Medida(Plural)",
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          validator: (string) {
                            if (string == "") {
                              return "Escreva uma medida(Caso não tenha plural, repita o campo singular";
                            } else if (string!.length > 20) {
                              return "Medida deve ter menos que 20 caracteres";
                            }
                            return null;
                          },
                          onChanged:
                              suggestionController.updateMeasurePluralText),
                      const Padding(
                        padding: EdgeInsets.only(top: 32.0),
                        child: Text(
                          "É sinonimo de alguma medida registrada?",
                          style: TextStyle(
                              fontSize: 17, fontFamily: "CostaneraAltBook"),
                        ),
                      ),
                      Obx(() {
                        return GFButton(
                          size: GFSize.MEDIUM,
                          color: suggestionController.isSynonyms.value
                              ? Colors.green
                              : CustomTheme.thirdColor,
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          onPressed: suggestionController.updateIsSynonyms,
                          shape: GFButtonShape.pills,
                          child: Text(
                            suggestionController.isSynonyms.value
                                ? "Sim"
                                : "Não",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        );
                      }),
                      Obx(() {
                        if (suggestionController.isSynonyms.value) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(25.0),
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                //FocusScope.of(context).unfocus();
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
                                            constraints: const BoxConstraints(),
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            icon: const Icon(Icons.clear,
                                                color: CustomTheme.thirdColor),
                                          )
                                        ]),
                                        content: SizedBox(
                                          width: MediaQuery.of(ctx).size.width,
                                          child: SelectIngredientTile(
                                            hintText: "Buscar medida...",
                                            isSuggestionIngredient: true,
                                            isIngredient: false,
                                            list: ingredientController
                                                .listMeasures,
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                height: 50,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color:
                                      suggestionController.itemSelected.value ==
                                              ""
                                          ? CustomTheme.greyColor
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(25.0),
                                  border:
                                      Border.all(color: CustomTheme.greyColor),
                                ),
                                child: Center(
                                  child: Text(
                                    suggestionController.itemSelected.value ==
                                            ""
                                        ? "Selecionar medida"
                                        : suggestionController
                                            .itemSelected.value,
                                    style: const TextStyle(
                                        fontFamily: "CostaneraAltBook",
                                        fontSize: 17),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return Container();
                      }),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: GFButton(
                          size: 45,
                          color: CustomTheme.thirdColor,
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (!mounted) return;
                              var result = await suggestionController
                                  .sendMeasureToRevision();
                              if (result == "") {
                                GFToast.showToast(
                                    toastDuration: 4,
                                    toastPosition: GFToastPosition.BOTTOM,
                                    "Medida enviada para revisão. Obrigado pela contribuição",
                                    context);
                                Navigator.of(context).pop();
                                await Future.delayed(
                                    const Duration(milliseconds: 100));
                                suggestionController.wipeData();
                              } else {
                                GFToast.showToast(
                                    toastDuration: 4,
                                    toastPosition: GFToastPosition.BOTTOM,
                                    result,
                                    context);
                              }
                            }
                          },
                          shape: GFButtonShape.pills,
                          child: const Text(
                            "Enviar medida para revisão",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () async {
                      Get.back();
                      await Future.delayed(const Duration(milliseconds: 100));
                      suggestionController.wipeData();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: CustomTheme.thirdColor,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
