import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:tudo_em_casa_receitas/controller/notification_controller.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';

class AppBarWithLogo extends StatelessWidget with PreferredSizeWidget {
  AppBarWithLogo({super.key});
  final UserController userController = Get.find();
  final NotificationController notificationController = Get.find();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      actions: [
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Stack(
            children: <Widget>[
              Icon(
                Icons.notifications,
                color: Theme.of(context).textTheme.bodySmall!.color,
                size: 30,
              ),
              Obx(() {
                var listNotifications = notificationController.listNotifications
                    .where((p0) => p0.isViewed == false)
                    .toList();
                if (listNotifications.isEmpty) {
                  return Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                    ),
                  );
                }
                return Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 15,
                      minHeight: 15,
                    ),
                    child: Text(
                      listNotifications.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              })
            ],
          ),
          onPressed: () {
            Get.toNamed(Routes.NOTIFICATIONS);
          },
        ),
        Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 8.0),
            child: IconButton(
              splashColor: Colors.transparent,
              icon: Obx(() {
                if (userController.currentUser.value.image == "") {
                  return const GFAvatar(
                    backgroundImage: AssetImage("assets/anom_avatar.png"),
                  );
                }
                return GFAvatar(
                    backgroundColor: Colors.grey[350],
                    backgroundImage: NetworkImage(
                      userController.currentUser.value.image,
                    ));
              }),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          );
        }),
      ],
      centerTitle: false,
      title: Image.asset(
        "assets/logo_text.png",
        color: Theme.of(context).dialogBackgroundColor,
        height: AppBar().preferredSize.height * 0.6,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
