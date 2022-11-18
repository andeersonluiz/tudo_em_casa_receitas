import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/notification_controller.dart';
import 'package:tudo_em_casa_receitas/model/notification_model.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/view/tile/notification_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/app_bar_text_widget.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});
  @override
  Widget build(BuildContext context) {
    NotificationController notificationController = Get.find();

    return SafeArea(
      child: Scaffold(
        appBar: AppBarWithText(
            text: "Minhas notificações",
            onPressed: () => Get.back(),
            textColor: Theme.of(context).dialogBackgroundColor,
            showDrawer: false),
        body: Obx(() {
          return NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: ListView.separated(
                separatorBuilder: (context, index) => Container(
                      color: Colors.white.withOpacity(0.2),
                      child: Divider(
                        height: 1,
                        color: Theme.of(context).textTheme.titleLarge!.color,
                      ),
                    ),
                itemCount: notificationController.listNotifications.length,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      NotificationModel notificationModel =
                          notificationController.listNotifications[index];
                      Get.toNamed(Routes.NOTIFICATIONS_INFO, arguments: {
                        "title": notificationModel.title,
                        "body": notificationModel.body
                      });
                      notificationController
                          .viewNotification(notificationModel);
                    },
                    child: NotificationTile(
                        notification:
                            notificationController.listNotifications[index]),
                  );
                }),
          );
        }),
      ),
    );
  }
}
