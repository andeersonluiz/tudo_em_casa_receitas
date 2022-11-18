import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/login_controller.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/support/custom_icons_icons.dart';
import 'package:tudo_em_casa_receitas/view/tile/custom_text_form_field_tile.dart';

import 'tile/sign_in_tile.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final LoginController loginController = Get.find();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontFamily: 'CostaneraAltBold', fontSize: 30),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      CustomTextFormFieldTile(
                        hintText: "Digite seu email...",
                        labelText: "Email",
                        textEditingController: emailController,
                        onChanged: loginController.updateEmailValue,
                        icon: Icons.email,
                        textInputAction: TextInputAction.next,
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
                      Obx(() {
                        return CustomTextFormFieldTile(
                          hintText: "Digite sua senha(min. 8 caracteres)",
                          labelText: "Senha",
                          textEditingController: passwordController,
                          textInputAction: TextInputAction.done,
                          iconSufix: loginController.visiblePassword.value
                              ? FontAwesomeIcons.eyeSlash
                              : FontAwesomeIcons.eye,
                          onChangedSufix: () {
                            loginController.updateVisiblePassword(
                                !loginController.visiblePassword.value);
                          },
                          icon: Icons.lock,
                          maxLines: 1,
                          onChanged: loginController.passwordValue,
                          obscureText: loginController.visiblePassword.value,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (string) {
                            if (string == "") {
                              return "Senha não pode ser vazia";
                            } else if (string!.length < 8) {
                              return "Senha inválida";
                            }
                            return null;
                          },
                        );
                      }),
                      Obx(() {
                        if (loginController.errorText.value == "") {
                          return Container();
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(loginController.errorText.value,
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
                            onPressed: loginController.isLoading.value
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      var result = await loginController
                                          .loginWithEmailAndPassword();
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
                                              "Logado com sucesso!!",
                                              context);
                                        }
                                      }
                                    }
                                  },
                            text: "Entrar",
                            textStyle: const TextStyle(
                                fontFamily: "CostaneraAltBold", fontSize: 17),
                            shape: GFButtonShape.pills,
                          );
                        }),
                      ),
                      TextButton(
                        onPressed: () {
                          _showDialog();
                        },
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 97, 94, 94))),
                        child: Text(
                          "Esqueceu a senha?",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
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
                                "OU ENTRAR COM",
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                    onPressed: loginController.isLoading.value
                                        ? null
                                        : () async {
                                            var result = await loginController
                                                .loginWithGoogle();
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
                                                    "Logado com sucesso!!",
                                                    context);
                                              }
                                            }
                                          },
                                  );
                                }),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Não tem conta?",
                            ),
                            TextButton(
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  _formKey.currentState!.reset();
                                  Get.toNamed(Routes.REGISTER);
                                  await Future.delayed(
                                      const Duration(milliseconds: 200));
                                  loginController.wipeData();
                                  passwordController.clear();
                                  emailController.clear();
                                },
                                child: const Text("Registre-se"))
                          ],
                        ),
                      )
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

  void _showDialog() {
    final emailRecoverController =
        TextEditingController(text: loginController.emailValue.value);
    loginController.updateEmailRecoverValue(loginController.emailValue.value);
    final formKey = GlobalKey<FormState>();
    FocusScope.of(context).unfocus();
    loginController.clearInfoRecoverText();
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
                  titlePadding: EdgeInsets.zero,
                  title: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      const Text("Resetar Senha"),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            splashColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.close,
                                color: Theme.of(context).secondaryHeaderColor)),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Digite seu email para enviarmos um link de redefinição",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      CustomTextFormFieldTile(
                        hintText: "Digite seu email...",
                        labelText: "Email",
                        padding: const EdgeInsets.all(8.0),
                        textEditingController: emailRecoverController,
                        onChanged: loginController.updateEmailRecoverValue,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        validator: (string) {
                          if (!emailValid.hasMatch(string!)) {
                            return "Email inválido";
                          }
                          return null;
                        },
                      ),
                      Obx(() {
                        if (loginController.infoRecoverText.value == "") {
                          return Container();
                        } else {
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: 0.0, top: 16.0),
                            child: Text(loginController.infoRecoverText.value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "CostaneraAltBook",
                                    fontSize: 12,
                                    color: Colors.red)),
                          );
                        }
                      }),
                    ],
                  ),
                  actionsOverflowButtonSpacing: 0,
                  actionsPadding: EdgeInsets.zero,
                  actionsAlignment: MainAxisAlignment.center,
                  actions: <Widget>[
                    Obx(() {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 32.0, right: 32.0, bottom: 8.0),
                        child: GFButton(
                          size: 40,
                          blockButton: true,
                          color: Theme.of(context).secondaryHeaderColor,
                          onPressed: loginController.emailRecoverValue.value ==
                                      "" ||
                                  loginController.isLoadingResetPassword.value
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    loginController.resetPassword();
                                  }
                                },
                          text: "Enviar",
                          textStyle: const TextStyle(
                              fontFamily: "CostaneraAltBold", fontSize: 17),
                          shape: GFButtonShape.pills,
                        ),
                      );
                    })
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
