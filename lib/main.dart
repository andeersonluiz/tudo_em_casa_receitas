import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/notification_controller.dart';
import 'package:tudo_em_casa_receitas/firebase_options.dart';
import 'package:tudo_em_casa_receitas/model/notification_model.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';
import 'package:tudo_em_casa_receitas/support/preferences.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class AppThemes {
  static const int Light = 0;
  static const int Dark = 1;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (message.notification != null) {
    await Preferences.addNotificationUsers(NotificationModel(
        title: message.notification!.title!,
        body: message.notification!.body!,
        dateNotification: DateTime.now(),
        isViewed: false));
    if (Get.isRegistered<NotificationController>()) {
      NotificationController notificationController = Get.find();
      notificationController.initData();
    } else {
      print("nao tá registrado");
    }
    print(
        "Handling a background message: ${message.messageId} ${message.data} ${message.notification!.title} ${message.notification!.body}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("entreii");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Future.wait([
    Preferences.getUser(),
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
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      await Preferences.addNotificationUsers(NotificationModel(
          title: message.notification!.title!,
          body: message.notification!.body!,
          dateNotification: DateTime.now(),
          isViewed: false));
      if (Get.isRegistered<NotificationController>()) {
        NotificationController notificationController = Get.find();
        notificationController.initData();
      } else {
        print("nao tá registrado");
      }

      print(
          'Message also contained a notification: ${message.notification} ${message.notification!.title} ${message.notification!.body}');
    }
  });
  print(await firebaseMessaging.getToken());
  /*final themeCollection = ThemeCollection(
    themes: {
      AppThemes.Light: CustomTheme.dataLight,
      AppThemes.Dark: CustomTheme.dataDark,
    },
  );*/
  runApp(AdaptiveTheme(
    light: CustomTheme.dataLight,
    dark: CustomTheme.dataDark,
    initial: AdaptiveThemeMode.light,
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
}
