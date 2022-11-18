import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/login_controller.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/view/tile/loader_tile.dart';

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
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontSize: 18,
                                  fontFamily: "CostaneraAltMedium",
                                ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8),
                            child: Text(
                              userController.currentUser.value.followers == -1
                                  ? "- Seguidores"
                                  : "${userController.currentUser.value.followers} Seguidores",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontSize: 14,
                                  ),
                            ))
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
              return NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          GFToast.showToast(
                              backgroundColor: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .color!,
                              textStyle: TextStyle(
                                color: Theme.of(context)
                                    .bottomSheetTheme
                                    .backgroundColor,
                              ),
                              toastDuration: 3,
                              toastPosition: GFToastPosition.BOTTOM,
                              "Ainda não foi lançada a versão premium, fique ligado nas novidades :)",
                              context);
                        },
                        child: Stack(
                          children: [
                            SizedBox(
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 7,
                                            color:
                                                Color.fromARGB(255, 107, 7, 7)),
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        borderRadius:
                                            BorderRadius.circular(35)),
                                  ),
                                )),
                            Positioned.fill(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "VERSÃO SEM ANUNCIOS",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontSize: 18,
                                              color: Colors.white),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Text(
                                      "Clique no banner e veja as vantagens",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontSize: 13,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.white),
                                    )),
                              ],
                            )),
                          ],
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).secondaryHeaderColor,
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
                                ),
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
                                ),
                                ItemDrawer(
                                  icon: FontAwesomeIcons.heart,
                                  text: "Favoritos",
                                  onTap: () {
                                    if (userController.indexSelected.value ==
                                        3) {
                                      Navigator.of(context).pop();
                                    } else {
                                      userController.updateIndexSelected(3);
                                      Navigator.of(context).pop();
                                      Get.toNamed(Routes.FAVORITE_LIST);
                                    }
                                  },
                                ),
                                Obx(() {
                                  if (userController.currentUser.value.id ==
                                      "28muq7t9XFMU973iV6uzI5DSNHj1") {
                                    return ItemDrawer(
                                      icon: FontAwesomeIcons.screwdriverWrench,
                                      text: "Admin",
                                      onTap: () {
                                        userController.updateIndexSelected(4);
                                        Navigator.of(context).pop();
                                        Get.toNamed(Routes.ADMIN);
                                      },
                                    );
                                  }
                                  return Container();
                                }),
                                /*ItemDrawer(
                                  icon: FontAwesomeIcons.medal,
                                  text: "Conquistas",
                                  onTap: () {
                                    if (userController.indexSelected.value == 4) {
                                      Navigator.of(context).pop();
                                    } else {
                                      userController.updateIndexSelected(4);
                                      //Get.toNamed(Routes.LOGIN);
                                    }
                                  },
                                ),*/
                                Divider(
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ],
                            ),
                      ItemDrawer(
                        icon: FontAwesomeIcons.gear,
                        text: "Configurações",
                        onTap: () {
                          userController.updateIndexSelected(0);
                          Navigator.of(context).pop();
                          Get.toNamed(Routes.SETTINGS);
                        },
                      ),
                      /* ItemDrawer(
                        icon: FontAwesomeIcons.circleQuestion,
                        text: "Ajuda e Feedback",
                        onTap: () {
                          userController.updateIndexSelected(0);
                        },
                      ),*/
                      Obx(() {
                        return loginController.isLoadingLogOut.value
                            ? const LoaderTile()
                            : userController.currentUser.value.id == ""
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
                                            backgroundColor: context.theme
                                                .textTheme.titleMedium!.color!,
                                            textStyle: TextStyle(
                                              color: context
                                                  .theme
                                                  .bottomSheetTheme
                                                  .backgroundColor,
                                            ),
                                            toastDuration: 3,
                                            toastPosition:
                                                GFToastPosition.BOTTOM,
                                            "Saiu com sucesso!!",
                                            context);
                                      }
                                    },
                                  );
                      })
                    ],
                  ),
                ),
              );
            }),
          ),
        ]),
      ),
    );
  }
}
