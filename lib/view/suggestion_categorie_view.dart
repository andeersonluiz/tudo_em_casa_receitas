// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:string_validator/string_validator.dart';
import 'package:tudo_em_casa_receitas/controller/suggestion_controller.dart';
import 'package:tudo_em_casa_receitas/support/custom_icons_icons.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/custom_text_form_field_tile.dart';

class SuggestionCategorieView extends StatelessWidget {
  SuggestionCategorieView({super.key});
  final SuggestionController suggestionController = Get.find();
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
                            "Faça a sugestão de uma categoria",
                            style: TextStyle(
                                fontSize: 19, fontFamily: "CostaneraAltBold"),
                          ),
                        ),
                        CustomTextFormFieldTile(
                            hintText: "Escreva a categoria",
                            labelText: "Categoria",
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validator: (string) {
                              if (string == "") {
                                return "Escreva uma categoria";
                              } else if (string!.length > 30) {
                                return "Categoria deve ter menos que 30 caracteres";
                              } else if (!isAlpha(string)) {
                                return "É aceito apenas texto";
                              }
                              return null;
                            },
                            onChanged:
                                suggestionController.updateCategorieText),
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
                                    .sendCategorieToRevision();
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
                                      "Categoria enviada para revisão. Obrigado pela contribuição",
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
                              "Enviar categoria para revisão",
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
