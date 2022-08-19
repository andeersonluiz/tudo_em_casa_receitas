// ignore_for_file: file_names
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:tudo_em_casa_receitas/controller/page_controller.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/home_view.dart';
import 'package:tudo_em_casa_receitas/view/recipeResult_view.dart';

class MainPageView extends GetView<PageControl> {
  const MainPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: GFAppBar(
            backgroundColor: CustomTheme.primaryColor,
            leading: const Padding(
              padding: EdgeInsets.all(8.0),
              child: GFAvatar(
                backgroundImage: NetworkImage(
                    "https://itpetblog.com.br/wp-content/uploads/2019/07/grumpy-cat.jpg"),
              ),
            ),
            title: const Text(
              "LOGO_APP",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
          resizeToAvoidBottomInset: false,
          body: PersistentTabView(context,
              screens: const [
                HomeView(),
                RecipeResultView(),
              ],
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
                    icon: const Icon(Icons.home),
                    title: "Home",
                    textStyle:
                        const TextStyle(color: Colors.black, fontSize: 12),
                    inactiveColorPrimary: Colors.grey,
                    activeColorPrimary: CustomTheme.thirdColor),
                PersistentBottomNavBarItem(
                    icon: const Icon(Icons.receipt_rounded),
                    title: "Recipes",
                    textStyle:
                        const TextStyle(color: Colors.black, fontSize: 12),
                    inactiveColorPrimary: Colors.grey,
                    activeColorPrimary: CustomTheme.thirdColor),
              ])),
    );
  }
}
