import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

class AppBarWithLogo extends StatelessWidget with PreferredSizeWidget {
  AppBarWithLogo({super.key});
  final UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Brightness.dark,
      automaticallyImplyLeading: false,
      backgroundColor: CustomTheme.primaryColor,
      actions: [
        Builder(builder: (context) {
          return IconButton(
            icon: Obx(() {
              print(
                  "fooooooooooooooooooi caralho ${userController.currentUser.value.image}");
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
          );
        }),
      ],
      centerTitle: false,
      title: Image.asset(
        "assets/logo_text.png",
        height: AppBar().preferredSize.height * 0.6,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
