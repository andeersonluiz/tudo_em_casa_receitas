import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/model/notification_model.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';
import 'package:tudo_em_casa_receitas/support/preferences.dart';

class NotificationController extends FullLifeCycleController
    with FullLifeCycleMixin {
  var listNotifications = List<NotificationModel>.empty().obs;
  @override
  void onInit() async {
    await initData();
    super.onInit();
  }

  initData() async {
    listNotifications.assignAll(LocalVariables.listNotifications.reversed);
  }

  viewNotification(NotificationModel notification) async {
    notification.isViewed = true;
    await Preferences.updateNoticiationUsers(listNotifications);
    listNotifications.refresh();
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() async {
    await initData();
  }
}
