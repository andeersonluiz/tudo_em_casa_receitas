// ignore_for_file: file_names
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/getwidget.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:tudo_em_casa_receitas/controller/page_controller.dart';
import 'package:tudo_em_casa_receitas/support/constants.dart';
import 'package:tudo_em_casa_receitas/support/custom_icons_icons.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/home_view.dart';
import 'package:tudo_em_casa_receitas/view/pantry_view.dart';
import 'package:tudo_em_casa_receitas/view/recipeResult_view.dart';

class MainPageView extends GetView<PageControl> {
  const MainPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("refiz");
    return SafeArea(
      child: Scaffold(
          endDrawer: Drawer(
            child: Container(),
          ),
          appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: CustomTheme.primaryColor,
            actions: [
              Builder(builder: (context) {
                return IconButton(
                  icon: const GFAvatar(
                    backgroundImage: AssetImage(
                      "assets/anom_avatar.png",
                    ),
                  ),
                  onPressed: () {
                    print("abri o drawer");
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
          ),
          resizeToAvoidBottomInset: false,
          body: PersistentTabView(context,
              screens: const [
                HomeView(),
                PantryView(),
                RecipeResultView(),
              ],
              navBarHeight: kBottomNavigationBarHeight + 3,
              navBarStyle: NavBarStyle.style3,
              itemAnimationProperties: const ItemAnimationProperties(
                // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: const ScreenTransitionAnimation(
                // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              items: [
                PersistentBottomNavBarItem(
                    icon: const Icon(
                      CustomIcons.home,
                      color: CustomTheme.thirdColor,
                    ),
                    inactiveIcon: Icon(
                      CustomIcons.homeOutlined,
                      color: CustomTheme.greyColor.withOpacity(0.5),
                    ),
                    iconSize: 21,
                    title: Constants.HOME,
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: "CostaneraAltBook"),
                    inactiveColorPrimary: Colors.grey,
                    activeColorPrimary: CustomTheme.thirdColor),
                PersistentBottomNavBarItem(
                    icon: const Icon(
                      CustomIcons.refrigerator,
                      color: CustomTheme.thirdColor,
                    ),
                    inactiveIcon: Icon(
                      CustomIcons.refrigeratorOutlined,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    iconSize: 21,
                    title: Constants.PANTRY,
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: "CostaneraAltBook"),
                    inactiveColorPrimary: Colors.grey,
                    activeColorPrimary: CustomTheme.thirdColor),
                PersistentBottomNavBarItem(
                    icon: const Icon(
                      CustomIcons.recipe,
                      color: CustomTheme.thirdColor,
                    ),
                    inactiveIcon: const Icon(
                      CustomIcons.recipeOutlined,
                      color: CustomTheme.greyColor,
                    ),
                    title: Constants.RECIPES,
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: "CostaneraAltBook"),
                    inactiveColorPrimary: Colors.grey,
                    activeColorPrimary: CustomTheme.thirdColor),
              ])),
    );
  }
}
