// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/controller/suggestion_controller.dart';
import 'package:tudo_em_casa_receitas/support/custom_icons_icons.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/custom_text_form_field_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/select_ingredient_tile.dart';
import 'package:string_validator/string_validator.dart';

import 'tile/custom_text_recipe_tile.dart';

class SuggestionIngredientView extends StatelessWidget {
  SuggestionIngredientView({super.key});
  final SuggestionController suggestionController = Get.find();
  final IngredientController ingredientController = Get.find();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        await Future.delayed(const Duration(milliseconds: 100));
        suggestionController.wipeData();
        return Future.delayed(Duration.zero, () => true);
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Icon(
                          CustomIcons.logo,
                          color: context.theme.secondaryHeaderColor,
                          size: 150,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 24.0),
                          child: Text(
                            "Faça a sugestão de um ingrediente",
                            style: TextStyle(
                                fontSize: 19, fontFamily: "CostaneraAltBold"),
                          ),
                        ),
                        CustomTextFormFieldTile(
                            hintText: "Escreva o ingrediente(Singular)",
                            labelText: "Ingrediente(Singular)",
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validator: (string) {
                              if (string == "") {
                                return "Escreva um ingrediente";
                              } else if (string!.trim().length > 20) {
                                return "Ingrediente deve ter menos que 20 caracteres";
                              } else if (!isAlpha(string)) {
                                return "É aceito apenas texto";
                              }
                              return null;
                            },
                            onChanged: suggestionController
                                .updateIngredientSingularText),
                        CustomTextFormFieldTile(
                            hintText: "Escreva o ingrediente(Plural)",
                            labelText: "Ingrediente(Plural)",
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.done,
                            validator: (string) {
                              if (string == "") {
                                return "Escreva um ingrediente(Caso não tenha plural, repita o campo singular";
                              } else if (string!.length > 20) {
                                return "Ingrediente deve ter menos que 20 caracteres";
                              } else if (!isAlpha(string)) {
                                return "É aceito apenas texto";
                              }
                              return null;
                            },
                            onChanged: suggestionController
                                .updateIngredientPluralText),
                        const Padding(
                          padding: EdgeInsets.only(top: 32.0),
                          child: Text(
                            "É sinonimo de algum ingrediente registrado?",
                            style: TextStyle(
                                fontSize: 17, fontFamily: "CostaneraAltBook"),
                          ),
                        ),
                        Obx(() {
                          return GFButton(
                            size: GFSize.MEDIUM,
                            color: suggestionController.isSynonyms.value
                                ? Colors.green
                                : context.theme.secondaryHeaderColor,
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
                                          key: const Key("a"),
                                          title: Row(children: [
                                            CustomTextRecipeTile(
                                              text: "Selecione o ingrediente",
                                              color: context
                                                  .theme.secondaryHeaderColor,
                                              required: false,
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              splashColor: Colors.transparent,
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              icon: Icon(Icons.clear,
                                                  color: context.theme
                                                      .secondaryHeaderColor),
                                            )
                                          ]),
                                          content: SizedBox(
                                            width:
                                                MediaQuery.of(ctx).size.width,
                                            child: SelectIngredientTile(
                                              hintText: "Buscar ingrediente...",
                                              isSuggestionIngredient: true,
                                              list: ingredientController
                                                  .listIngredients
                                                  .where((item) =>
                                                      !item.isRevision)
                                                  .toList(),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  height: 50,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 32),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: suggestionController
                                                .itemSelected.value ==
                                            ""
                                        ? CustomTheme.greyColor
                                        : Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(25.0),
                                    border: Border.all(
                                        color: CustomTheme.greyColor),
                                  ),
                                  child: Center(
                                    child: Text(
                                        suggestionController
                                                    .itemSelected.value ==
                                                ""
                                            ? "Selecionar ingrediente"
                                            : suggestionController
                                                .itemSelected.value,
                                        style: context
                                            .theme.textTheme.titleMedium!
                                            .copyWith(fontSize: 17)),
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
                            color: context.theme.secondaryHeaderColor,
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (!mounted) return;
                                var result = await suggestionController
                                    .sendIngredientToRevision();
                                if (result == "") {
                                  GFToast.showToast(
                                      backgroundColor: context
                                          .theme.textTheme.titleMedium!.color!,
                                      textStyle: TextStyle(
                                        color: context.theme.bottomSheetTheme
                                            .backgroundColor,
                                      ),
                                      toastDuration: 4,
                                      toastPosition: GFToastPosition.BOTTOM,
                                      "Ingrediente enviado para revisão. Obrigado pela contribuição",
                                      context);
                                  Navigator.of(context).pop();
                                  await Future.delayed(
                                      const Duration(milliseconds: 100));
                                  suggestionController.wipeData();
                                } else {
                                  GFToast.showToast(
                                      backgroundColor: context
                                          .theme.textTheme.titleMedium!.color!,
                                      textStyle: TextStyle(
                                        color: context.theme.bottomSheetTheme
                                            .backgroundColor,
                                      ),
                                      toastDuration: 4,
                                      toastPosition: GFToastPosition.BOTTOM,
                                      result.toString(),
                                      context);
                                }
                              }
                            },
                            shape: GFButtonShape.pills,
                            child: const Text(
                              "Enviar ingrediente para revisão",
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
                      splashColor: Colors.transparent,
                      onPressed: () async {
                        Get.back();
                        await Future.delayed(const Duration(milliseconds: 100));
                        suggestionController.wipeData();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: context.theme.splashColor,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
