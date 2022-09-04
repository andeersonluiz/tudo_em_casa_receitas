import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/home_view_controller.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/card_recipe_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/card_recipe_trend_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/custom_toggle_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/error_widget.dart';
import 'package:extension/extension.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeViewController homeViewController = Get.find();
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: CustomToggle(),
        ),
        Obx(() {
          if (homeViewController.listRecipesHomePage.isNotEmpty &&
              homeViewController.statusRecipes.value == Status.Finished) {
            return Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children:
                    homeViewController.listRecipesHomePage.map<Widget>((item) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16.0, right: 16.0),
                        child: Row(
                          children: [
                            Text(
                                item[0] == ""
                                    ? "Principais Receitas"
                                    : item[0]
                                        .toString()
                                        .toLowerCase()
                                        .capitalizeFirstLetter(),
                                style: const TextStyle(
                                    fontFamily: "CostaneraAltBook",
                                    fontSize: 18)),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {},
                              child: const Text("Ver Tudo",
                                  style: TextStyle(
                                      fontFamily: "CostaneraAltBook",
                                      fontSize: 14,
                                      color: Colors.red)),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: item[0] == "" ? 235 : 170,
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: item[1]
                              .map<Widget>((recipe) => item[0] == ""
                                  ? CardRecipeTrendTile(recipe)
                                  : CardRecipeTile(recipe))
                              .toList(),
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            );
          } else if (homeViewController.listRecipesHomePage.isEmpty &&
              homeViewController.statusRecipes.value == Status.Finished) {
            return const Expanded(
                child: CustomErrorWidget(
                    "Erro ao carregar receitas, verifique sua conexão"));
          } else {
            return const Expanded(
                child: GFLoader(
              size: GFSize.LARGE,
              androidLoaderColor:
                  AlwaysStoppedAnimation<Color>(CustomTheme.thirdColor),
            ));
          }
        })
      ],
    );
  }
}
