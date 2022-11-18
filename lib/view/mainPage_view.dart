// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:tudo_em_casa_receitas/support/constants.dart';
import 'package:tudo_em_casa_receitas/support/custom_icons_icons.dart';
import 'package:tudo_em_casa_receitas/view/home_view.dart';
import 'package:tudo_em_casa_receitas/view/pantry_view.dart';
import 'package:tudo_em_casa_receitas/view/recipe_view.dart';
import 'package:tudo_em_casa_receitas/view/widgets/app_bar_logo_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/custom_drawer_widget.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({Key? key}) : super(key: key);

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          endDrawer: CustomDrawerWidget(),
          drawerEdgeDragWidth: 0,
          appBar: AppBarWithLogo(),
          resizeToAvoidBottomInset: false,
          body: PersistentTabView(context,
              screens: const [
                HomeView(),
                PantryView(),
                RecipeView(),
              ],
              navBarHeight: kBottomNavigationBarHeight + 3,
              navBarStyle: NavBarStyle.style3,
              backgroundColor:
                  Theme.of(context).bottomSheetTheme.backgroundColor!,
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
                    icon: Icon(
                      CustomIcons.home,
                      color: Theme.of(context).dialogBackgroundColor,
                    ),
                    inactiveIcon: Icon(CustomIcons.homeOutlined,
                        color: Theme.of(context).iconTheme.color),
                    iconSize: 21,
                    title: Constants.HOME,
                    textStyle:
                        Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontSize: 12,
                            ),
                    inactiveColorPrimary: Colors.grey,
                    activeColorPrimary:
                        Theme.of(context).dialogBackgroundColor),
                PersistentBottomNavBarItem(
                    icon: Icon(
                      CustomIcons.refrigerator,
                      color: Theme.of(context).dialogBackgroundColor,
                    ),
                    inactiveIcon: Icon(
                      CustomIcons.refrigeratorOutlined,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    iconSize: 21,
                    title: Constants.PANTRY,
                    textStyle:
                        Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontSize: 12,
                            ),
                    inactiveColorPrimary: Colors.grey,
                    activeColorPrimary:
                        Theme.of(context).dialogBackgroundColor),
                PersistentBottomNavBarItem(
                    icon: Icon(
                      CustomIcons.recipe,
                      color: Theme.of(context).dialogBackgroundColor,
                    ),
                    inactiveIcon: Icon(
                      CustomIcons.recipeOutlined,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: Constants.RECIPES,
                    textStyle:
                        Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontSize: 12,
                            ),
                    inactiveColorPrimary: Colors.grey,
                    activeColorPrimary:
                        Theme.of(context).dialogBackgroundColor),
              ])),
    );
  }
}
