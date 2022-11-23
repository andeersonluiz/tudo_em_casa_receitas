import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/admin_controller.dart';
import 'package:tudo_em_casa_receitas/view/tile/card_ingredient_revision_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/card_measure_revision_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/loader_tile.dart';

import 'tile/card_categorie_revision_tile.dart';

class AdminView extends StatelessWidget {
  AdminView({super.key});
  final AdminController adminController = Get.find();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: GestureDetector(
          child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "Seção do adminstrador",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 19),
                ),
                leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).dialogBackgroundColor,
                    )),
                centerTitle: true,
                bottom: TabBar(
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    labelColor: Theme.of(context).textTheme.titleMedium!.color,
                    tabs: const [
                      Tab(
                        text: "Ingredientes",
                      ),
                      Tab(text: "Medidas"),
                      Tab(text: "Categorias"),
                    ]),
              ),
              body: TabBarView(
                children: [
                  RefreshIndicator(
                    onRefresh: () {
                      return adminController.getListIngredientsRevision();
                    },
                    child: Obx(() {
                      if (adminController.isLoadingIngredientsRevision.value) {
                        return const LoaderTile();
                      }
                      return NotificationListener<
                          OverscrollIndicatorNotification>(
                        onNotification: (overscroll) {
                          overscroll.disallowIndicator();
                          return true;
                        },
                        child: ListView.builder(
                            itemCount:
                                adminController.listIngredientsRevision.length,
                            itemBuilder: (ctx, index) {
                              return CardIngredientRevisionTile(
                                  ingredient: adminController
                                      .listIngredientsRevision[index]);
                            }),
                      );
                    }),
                  ),
                  RefreshIndicator(
                    onRefresh: () {
                      return adminController.getListMeasuresRevision();
                    },
                    child: Obx(() {
                      if (adminController.isLoadingMeasuresRevision.value) {
                        return const LoaderTile();
                      }
                      return NotificationListener<
                          OverscrollIndicatorNotification>(
                        onNotification: (overscroll) {
                          overscroll.disallowIndicator();
                          return true;
                        },
                        child: ListView.builder(
                            itemCount:
                                adminController.listMeasuresRevision.length,
                            itemBuilder: (ctx, index) {
                              return CardMeasureRevisionTile(
                                  measure: adminController
                                      .listMeasuresRevision[index]);
                            }),
                      );
                    }),
                  ),
                  RefreshIndicator(
                    onRefresh: () {
                      return adminController.getListCategoriesRevision();
                    },
                    child: Obx(() {
                      if (adminController.isLoadingCategoriesRevision.value) {
                        return const LoaderTile();
                      }
                      return NotificationListener<
                          OverscrollIndicatorNotification>(
                        onNotification: (overscroll) {
                          overscroll.disallowIndicator();
                          return true;
                        },
                        child: ListView.builder(
                            itemCount:
                                adminController.listCategoriesRevision.length,
                            itemBuilder: (ctx, index) {
                              return CardCategorieRevisionTile(
                                  categorie: adminController
                                      .listCategoriesRevision[index]);
                            }),
                      );
                    }),
                  ),
                ],
              )),
        ));
  }
}
