import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/ingredient_controller.dart';
import 'package:tudo_em_casa_receitas/controller/my_recipe_controller.dart';
import 'package:tudo_em_casa_receitas/controller/notification_controller.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/firebase_options.dart';
import 'package:tudo_em_casa_receitas/model/notification_model.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';
import 'package:tudo_em_casa_receitas/support/preferences.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("run b ");
  if (message.notification != null) {
    await Preferences.addNotificationUsers(NotificationModel(
        title: message.notification!.title!,
        body: message.notification!.body!,
        dateNotification: DateTime.now(),
        isViewed: false));

    if (Get.isRegistered<NotificationController>()) {
      NotificationController notificationController = Get.find();
      notificationController.initData();
    }
    if (Get.isRegistered<UserController>()) {
      UserController userController = Get.find();
      userController.getMyRecipes();
    }
    if (Get.isRegistered<IngredientController>()) {
      IngredientController ingredientController = Get.find();
      ingredientController.initData();
    }
  }
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Preferences.getUser();
  await Future.wait([
    Preferences.getTags(),
    Preferences.loadIngredientPantry(),
    Preferences.loadIngredientHomePantry(),
    Preferences.loadFavorites(),
    Preferences.getDartkMode(),
    Preferences.getNotifications(),
    Preferences.getCategories(),
    Preferences.getNotificationsUsers(),
  ]);

  /*Map<Permission, PermissionStatus> status = await [
    Permission.location,
    Permission.storage,
  ].request();*/
  /*await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  );*/
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print("run a ");
    if (message.notification != null) {
      await Preferences.addNotificationUsers(NotificationModel(
          title: message.notification!.title!,
          body: message.notification!.body!,
          dateNotification: DateTime.now(),
          isViewed: false));
      await Preferences.getUser();
      if (Get.isRegistered<NotificationController>()) {
        NotificationController notificationController = Get.find();
        notificationController.initData();
      }
      if (Get.isRegistered<UserController>()) {
        UserController userController = Get.find();
        userController.getMyRecipes();
      }
      if (Get.isRegistered<IngredientController>()) {
        IngredientController ingredientController = Get.find();
        ingredientController.initData();
      }
    }
  });
  /*final themeCollection = ThemeCollection(
    themes: {
      AppThemes.Light: CustomTheme.dataLight,
      AppThemes.Dark: CustomTheme.dataDark,
    },
  );*/
  runApp(AdaptiveTheme(
    light: CustomTheme.dataLight,
    dark: CustomTheme.dataDark,
    initial: LocalVariables.isDartkMode
        ? AdaptiveThemeMode.dark
        : AdaptiveThemeMode.light,
    builder: (theme, darkTheme) => GetMaterialApp(
      defaultTransition: Transition.fadeIn,
      theme: theme,
      darkTheme: darkTheme,
      navigatorObservers: <NavigatorObserver>[observer],
      initialRoute: AppPage.INITIAL,
      getPages: AppPage.routes,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    ),
  ));
  FlutterNativeSplash.remove();
}
