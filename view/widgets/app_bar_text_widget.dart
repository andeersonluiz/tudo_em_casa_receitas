import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

class AppBarWithText extends StatelessWidget with PreferredSizeWidget {
  final String text;
  final Function()? onPressed;
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
        brightness: Brightness.dark,
        backgroundColor: CustomTheme.primaryColor,
        actions: [
          showDrawer
              ? Builder(builder: (context) {
                  return IconButton(
                    icon: Obx(() {
                      if (userController.currentUser.value.image == "") {
                        return const GFAvatar(
                          backgroundImage: AssetImage("assets/anom_avatar.png"),
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
                  );
                })
              : Container(),
        ],
        leading: IconButton(
            onPressed: onPressed,
            icon: const Icon(
              Icons.arrow_back,
              color: CustomTheme.thirdColor,
            )),
        centerTitle: centerTitle,
        title: Text(
          text,
          style: TextStyle(color: textColor, fontFamily: 'CosanteraAltMedium'),
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
