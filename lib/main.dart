import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/firebase_options.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(GetMaterialApp(
    defaultTransition: Transition.fadeIn,
    theme: CustomTheme.data,
    initialRoute: AppPage.INITIAL,
    getPages: AppPage.routes,
    debugShowCheckedModeBanner: false,
    builder: EasyLoading.init(),
  ));
}
