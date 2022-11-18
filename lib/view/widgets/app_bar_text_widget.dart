import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';

class AppBarWithText extends StatelessWidget with PreferredSizeWidget {
  final String text;
  final Function() onPressed;
  final bool showDrawer;
  final bool centerTitle;
  final Color textColor;
  AppBarWithText(
      {required this.text,
      required this.onPressed,
      this.showDrawer = true,
      this.centerTitle = true,
      this.textColor = Colors.black,
      super.key});
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          showDrawer
              ? Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Obx(() {
                        if (userController.currentUser.value.image == "") {
                          return const GFAvatar(
                            backgroundImage:
                                AssetImage("assets/anom_avatar.png"),
                          );
                        }
                        return GFAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                          userController.currentUser.value.image,
                        ));
                      }),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  );
                })
              : Container(),
        ],
        leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: onPressed,
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).dialogBackgroundColor,
            )),
        centerTitle: centerTitle,
        title: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 19,
              color: Theme.of(context).dialogBackgroundColor,
              fontFamily: 'CosanteraAltMedium'),
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
