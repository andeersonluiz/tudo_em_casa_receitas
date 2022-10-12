import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/login_controller.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/model/user_model.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

import '../tile/item_drawer_tile.dart';

class CustomDrawerWidget extends StatelessWidget {
  CustomDrawerWidget({Key? key}) : super(key: key);
  final UserController userController = Get.find();
  final LoginController loginController = Get.find();
  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return Drawer(
      child: SafeArea(
        child: Column(children: [
          Container(
            height: 150,
            decoration: userController.currentUser.value.wallpaperImage == ""
                ? const BoxDecoration(color: Colors.grey)
                : BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        opacity: 0.3,
                        image: CachedNetworkImageProvider(
                            userController.currentUser.value.wallpaperImage))),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8),
                          child: Text(
                            userController.currentUser.value.name == ""
                                ? "Anonimo"
                                : userController.currentUser.value.name,
                            style: const TextStyle(
                                fontFamily: "CostaneraAltMedium",
                                fontSize: 18,
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8),
                          child:
                              userController.currentUser.value.followers == -1
                                  ? const Text(
                                      "- Seguidores",
                                      style: TextStyle(
                                          fontFamily: "CostaneraAltBook",
                                          fontSize: 14,
                                          color: Colors.black),
                                    )
                                  : Text(
                                      "${userController.currentUser.value.followers} Seguidores",
                                      style: const TextStyle(
                                          fontFamily: "CostaneraAltBook",
                                          fontSize: 14,
                                          color: Colors.black),
                                    ),
                        )
                      ],
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: userController.currentUser.value.image == ""
                        ? const GFAvatar(
                            size: 45,
                            backgroundImage: AssetImage(
                              "assets/anom_avatar.png",
                            ),
                          )
                        : GFAvatar(
                            size: 45,
                            backgroundImage: CachedNetworkImageProvider(
                              userController.currentUser.value.image,
                            )),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(35)),
                          ),
                        )),
                    const Divider(
                      color: CustomTheme.thirdColor,
                    ),
                    userController.currentUser.value.id == ""
                        ? ItemDrawer(
                            icon: FontAwesomeIcons.rightToBracket,
                            text: "Login/Registro",
                            onTap: () {
                              Get.toNamed(Routes.LOGIN);
                            },
                          )
                        : Column(
                            children: [
                              ItemDrawer(
                                  icon: FontAwesomeIcons.rightToBracket,
                                  text: "Minhas Receitas",
                                  onTap: () {
                                    if (userController.indexSelected.value ==
                                        1) {
                                      Navigator.of(context).pop();
                                    } else {
                                      userController.updateIndexSelected(1);
                                      Navigator.of(context).pop();
                                      Get.toNamed(Routes.MY_RECIPES);
                                      //Get.toNamed(Routes.LOGIN);
                                    }
                                  },
                                  isSelected: false),
                              ItemDrawer(
                                  icon: FontAwesomeIcons.user,
                                  text: "Perfil",
                                  onTap: () {
                                    if (userController.indexSelected.value ==
                                        2) {
                                      Navigator.of(context).pop();
                                    } else {
                                      userController.updateIndexSelected(2);
                                      Navigator.of(context).pop();
                                      Get.toNamed(Routes.PROFILE, arguments: {
                                        "userId":
                                            userController.currentUser.value.id,
                                        "isMyUser": true
                                      });
                                    }
                                  },
                                  isSelected: false),
                              ItemDrawer(
                                  icon: FontAwesomeIcons.star,
                                  text: "Favoritos",
                                  onTap: () {
                                    if (userController.indexSelected.value ==
                                        3) {
                                      Navigator.of(context).pop();
                                    } else {
                                      userController.updateIndexSelected(3);
                                      //Get.toNamed(Routes.LOGIN);
                                    }
                                  },
                                  isSelected: false),
                              ItemDrawer(
                                  icon: FontAwesomeIcons.medal,
                                  text: "Conquistas",
                                  onTap: () {
                                    if (userController.indexSelected.value ==
                                        4) {
                                      Navigator.of(context).pop();
                                    } else {
                                      userController.updateIndexSelected(4);
                                      //Get.toNamed(Routes.LOGIN);
                                    }
                                  },
                                  isSelected:
                                      userController.indexSelected.value == 4
                                          ? true
                                          : false),
                              const Divider(
                                color: CustomTheme.thirdColor,
                              ),
                            ],
                          ),
                    ItemDrawer(
                      icon: FontAwesomeIcons.gear,
                      text: "Configurações",
                      onTap: () {
                        userController.updateIndexSelected(0);
                      },
                    ),
                    ItemDrawer(
                      icon: FontAwesomeIcons.circleQuestion,
                      text: "Ajuda e Feedback",
                      onTap: () {
                        userController.updateIndexSelected(0);
                      },
                    ),
                    userController.currentUser.value.id == ""
                        ? Container()
                        : ItemDrawer(
                            icon: FontAwesomeIcons.rightToBracket,
                            text: "Sair",
                            onTap: () async {
                              await loginController.logOut();
                              userController.updateIndexSelected(0);
                              if (mounted) {
                                Get.offAllNamed(Routes.MAIN_PAGE);
                                GFToast.showToast(
                                    toastDuration: 3,
                                    toastPosition: GFToastPosition.BOTTOM,
                                    "Saiu com sucesso!!",
                                    context);
                              }
                            },
                          ),
                  ],
                ),
              );
            }),
          ),
        ]),
      ),
    );
  }
}
