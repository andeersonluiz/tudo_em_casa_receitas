import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/widgets/ingredients_pantry_home_widget.dart';
import 'package:tudo_em_casa_receitas/view/widgets/ingredients_pantry_widget.dart';

class PantryView extends StatelessWidget {
  const PantryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: DefaultTabController(
        length: 2,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    pinned: true,
                    actions: [Container()],
                    title: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        decoration: BoxDecoration(
                          color: CustomTheme.thirdColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            "Minha Despensa",
                            style: TextStyle(
                                fontFamily: "CostaneraAltBold",
                                color: Colors.white,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    bottom: const TabBar(
                      tabs: [
                        Tab(
                          text: "Meus Ingredientes",
                        ),
                        Tab(
                          text: "Já tenho em cassa",
                        )
                      ],
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                  ),
                ];
              },
              body: TabBarView(children: <Widget>[
                Stack(
                  children: [
                    const IngredientsPantryWidget(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GFButton(
                          size: GFSize.LARGE,
                          color: CustomTheme.thirdColor,
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          onPressed: () {},
                          text: "BUSCAR RECEITAS",
                          shape: GFButtonShape.pills,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: const ShapeDecoration(
                              color: CustomTheme.thirdColor,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              color: Colors.white,
                              onPressed: () async {
                                await Get.toNamed(Routes.SEARCH_INGREDIENT,
                                    arguments: {"isPantry": true});
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    const IngredientsPantryHomeWidget(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: const ShapeDecoration(
                              color: CustomTheme.thirdColor,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              color: Colors.white,
                              onPressed: () async {
                                await Get.toNamed(Routes.SEARCH_INGREDIENT,
                                    arguments: {"isPantry": false});
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ])),
        ),
      ),
    );
  }
}
