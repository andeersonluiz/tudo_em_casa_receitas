import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/settings_controller.dart';
import 'package:tudo_em_casa_receitas/main.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/custom_text_form_field_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/settings_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/app_bar_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key? key}) : super(key: key);
  final SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    print("refiz com o tema ${Theme.of(context).brightness}");

    return Obx(() {
      print("entrei");
      bool isDark =
          Theme.of(context).brightness == Brightness.dark ? true : false;
      print("fimse");
      print("a ${settingsController.isDarkModePlace.value} b${isDark}");
      if (settingsController.isDarkModePlace.value != isDark) {
        return Container(color: Colors.black);
      }
      return SafeArea(
        child: Scaffold(
          backgroundColor: context.theme.backgroundColor,
          appBar: AppBarWithText(
              text: "Configurações",
              showDrawer: false,
              onPressed: () {
                Get.back();
              }),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0, top: 16),
                  child: Center(
                    child: Text(
                      "GERAL",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 12.0, right: 12.0, bottom: 12.0, top: 6.0),
                  decoration: BoxDecoration(
                      color: context.theme.bottomSheetTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() {
                          print(settingsController.isDarkMode.value);
                          return SettingsTile(
                            isToogle: true,
                            valueToogle: settingsController.isDarkMode.value,
                            title: "Modo Escuro",
                            onToggle: (value) async {
                              await settingsController
                                  .updateDarkMode(); // sets theme mode to dark
                              settingsController.isDarkMode.value
                                  ? AdaptiveTheme.of(context).setDark()
                                  : AdaptiveTheme.of(context).setLight();

                              settingsController.isDarkModePlace.value =
                                  settingsController.isDarkMode.value;
                              await Future.delayed(Duration(seconds: 2));
                            },
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Divider(
                          color: Theme.of(context).textTheme.titleLarge!.color,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() {
                          return SettingsTile(
                            isToogle: true,
                            title: "Notificações",
                            valueToogle:
                                settingsController.showNotifications.value,
                            onToggle: (value) {
                              print(value);
                              settingsController.updateNotifications();
                            },
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Divider(
                          color: Theme.of(context).textTheme.titleLarge!.color,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SettingsTile(
                          isToogle: false,
                          title: "Remover Anuncios",
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "APOIO",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 12.0, right: 12.0, bottom: 12.0, top: 6.0),
                  decoration: BoxDecoration(
                      color: context.theme.bottomSheetTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SettingsTile(
                          onTap: () {
                            Get.toNamed(Routes.REPORT);
                          },
                          isToogle: false,
                          title: "Relatar Problema",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Divider(
                          color: Theme.of(context).textTheme.titleLarge!.color,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SettingsTile(
                          isToogle: false,
                          title: "Feedback",
                          onTap: () => showFeeback(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "APLICATIVO",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 12.0, right: 12.0, bottom: 12.0, top: 6.0),
                  decoration: BoxDecoration(
                      color: context.theme.bottomSheetTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SettingsTile(
                          isToogle: false,
                          title: "Avalie-nos na Google Play",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Divider(
                          color: Theme.of(context).textTheme.titleLarge!.color,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SettingsTile(
                          isToogle: false,
                          title: "Termos de uso",
                          onTap: () async {
                            await _launchUrl(
                                "https://pages.flycricket.io/cookiva/terms.html");
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Divider(
                          color: Theme.of(context).textTheme.titleLarge!.color,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SettingsTile(
                          isToogle: false,
                          title: "Politica de privacidade",
                          onTap: () async {
                            await _launchUrl(
                                "https://pages.flycricket.io/cookiva/privacy.html");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  showFeeback(BuildContext context) {
    final keyForm = GlobalKey<FormState>();
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Form(
              key: keyForm,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Feedback",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: "CostaneraAltBook",
                        color: context.theme.splashColor),
                  ),
                ),
                CustomTextFormFieldTile(
                    hintText: "Digite seu feedback",
                    labelText: "",
                    keyboardType: TextInputType.text,
                    contentPadding: EdgeInsets.all(14.0),
                    validator: (value) {
                      if (value == "") {
                        return "Conteúdo não pode ser vazio";
                      }
                    },
                    minLines: 5,
                    onChanged: settingsController.updateFeedbackText),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 34.0, vertical: 8.0),
                  child: GFButton(
                    size: GFSize.MEDIUM,
                    color: context.theme.secondaryHeaderColor,
                    onPressed: () async {
                      if (keyForm.currentState!.validate()) {
                        await settingsController.sendFeedback();
                        Navigator.pop(context);
                        GFToast.showToast(
                            backgroundColor:
                                context.theme.textTheme.titleMedium!.color!,
                            textStyle: TextStyle(
                              color: context
                                  .theme.bottomSheetTheme.backgroundColor,
                            ),
                            toastDuration: 3,
                            toastPosition: GFToastPosition.BOTTOM,
                            "Feedback enviado com sucesso. Obrigado!!",
                            context);
                      }
                    },
                    text: "Enviar",
                    blockButton: true,
                    shape: GFButtonShape.pills,
                  ),
                ),
              ]),
            ),
          );
        });
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
