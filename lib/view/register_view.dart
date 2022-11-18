import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/register_controller.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/view/tile/custom_text_form_field_tile.dart';
import 'package:tudo_em_casa_receitas/support/custom_icons_icons.dart';

import '../route/app_pages.dart';
import 'tile/sign_in_tile.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final RegisterController registerController = Get.find();
  final UserController userController = Get.find();
  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    if (userController.currentUser.value.name != "") {
      Navigator.of(context).pop();
    }
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CustomIcons.logo,
                    color: Theme.of(context).dialogBackgroundColor,
                    size: 150,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Registrar",
                      style: TextStyle(
                          fontFamily: 'CostaneraAltBold', fontSize: 30),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      CustomTextFormFieldTile(
                        hintText: "Digite seu nome...",
                        labelText: "Nome",
                        textInputAction: TextInputAction.next,
                        onChanged: registerController.updateNameValue,
                        icon: FontAwesomeIcons.user,
                        keyboardType: TextInputType.name,
                        validator: (string) {
                          if (string == "") {
                            return "Nome não pode ser vazio";
                          } else if (string!.length < 3) {
                            return "Nome precisa ter pelo menos 3 caracteres.";
                          }
                          return null;
                        },
                      ),
                      CustomTextFormFieldTile(
                        hintText: "Digite seu email...",
                        labelText: "Email",
                        icon: Icons.email,
                        textInputAction: TextInputAction.next,
                        onChanged: registerController.updateEmailValue,
                        keyboardType: TextInputType.emailAddress,
                        validator: (string) {
                          if (string == "") {
                            return "Email não pode ser vazio";
                          } else if (!emailValid.hasMatch(string!)) {
                            return "Email inválido";
                          }
                          return null;
                        },
                      ),
                      CustomTextFormFieldTile(
                        hintText: "Digite sua senha(min. 8 caracteres)",
                        labelText: "Senha",
                        icon: Icons.lock,
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
                        onChanged: registerController.updatePasswordValue,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: (string) {
                          if (string == "") {
                            return "Senha não pode ser vazia";
                          }
                          return null;
                        },
                      ),
                      CustomTextFormFieldTile(
                        hintText: "Confirme sua senha(min. 8 caracteres)",
                        labelText: "Confirmar senha",
                        icon: Icons.lock,
                        maxLines: 1,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onChanged:
                            registerController.updateConfirmPasswordValue,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (string) {
                          if (string == "") {
                            return "Senha não pode ser vazia";
                          } else if (!registerController.passwordIsEqual()) {
                            return "Senhas não coincidem";
                          }
                          return null;
                        },
                      ),
                      Obx(() {
                        if (registerController.errorText.value == "") {
                          return Container();
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(registerController.errorText.value,
                                style: TextStyle(
                                    fontFamily: "CostaneraAltBook",
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .secondaryHeaderColor)),
                          );
                        }
                      }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() {
                          return GFButton(
                            size: 40,
                            color: Theme.of(context).secondaryHeaderColor,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 120),
                            onPressed: registerController.isLoading.value
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      var result = await registerController
                                          .registerWithEmailAndPassword();

                                      if (result) {
                                        Get.offAllNamed(Routes.MAIN_PAGE);
                                        if (mounted) {
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
                                              "Registrado com sucesso!!",
                                              context);
                                        }
                                      }
                                    }
                                  },
                            text: "Registrar",
                            textStyle: const TextStyle(
                                fontFamily: "CostaneraAltBold", fontSize: 17),
                            shape: GFButtonShape.pills,
                          );
                        }),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Divider(
                              color: Theme.of(context).secondaryHeaderColor,
                            )),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "OU REGISTRE-SE COM",
                                style: TextStyle(
                                    fontFamily: "CostaneraAltBook",
                                    fontSize: 11),
                              ),
                            ),
                            Expanded(
                                child: Divider(
                              color: Theme.of(context).secondaryHeaderColor,
                            )),
                          ]),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Obx(() {
                                  return SignInTile(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    icon: FontAwesomeIcons.google,
                                    onPressed: registerController
                                            .isLoading.value
                                        ? null
                                        : () async {
                                            _formKey.currentState!.deactivate();
                                            var result =
                                                await registerController
                                                    .registerWithGoogle();
                                            if (result) {
                                              Get.offAllNamed(Routes.MAIN_PAGE);
                                              if (mounted) {
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
                                                    "Registrado com sucesso!!",
                                                    context);
                                              }
                                            }
                                          },
                                  );
                                }),
                              ),
                            ]),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                splashColor: Colors.transparent,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).dialogBackgroundColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
