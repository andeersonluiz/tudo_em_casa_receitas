import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/crud_recipe_controller.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_item.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/image_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/recipe_infos_list_widget.dart';
import 'dart:math' as math;

import '../controller/recipe_infos_controller.dart';
import '../support/custom_icons_icons.dart';
import 'widgets/recipe_infos_list_preparation_widget.dart';

class RecipeInfosView extends StatefulWidget {
  RecipeInfosView({super.key});

  @override
  State<RecipeInfosView> createState() => _RecipeInfosViewState();
}

class _RecipeInfosViewState extends State<RecipeInfosView>
    with WidgetsBindingObserver {
  bool isMyRecipe = true;
  bool isPreview = false;
  RecipeInfosController recipeInfosController = Get.find();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    print("reiniciei");
    if (Get.arguments != null) {
      Recipe rec = Recipe.fromJson(
          Get.arguments["recipe"], Get.arguments["recipe"]["id"]);
      isMyRecipe = Get.arguments["isMyRecipe"];
      if (Get.arguments["isPreview"] != null) {
        isPreview = Get.arguments["isPreview"];
      }
      recipeInfosController.loadData(rec);
      print(recipeInfosController.initalRecipe.categories);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          NestedScrollView(headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 230,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                  color: Colors.red,
                  onPressed: () {
                    Get.back();
                    recipeInfosController.updateRecipeLike();
                  },
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.share),
                    color: Colors.red,
                    onPressed: isPreview ? null : () {},
                  ),
                ),
              ),
              isMyRecipe
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          padding: EdgeInsets.only(right: 2),
                          constraints: BoxConstraints(),
                          icon: Icon(FontAwesomeIcons.star),
                          color: Colors.yellow,
                          onPressed: () {},
                        ),
                      ),
                    ),
              isMyRecipe
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            FontAwesomeIcons.ellipsisVertical,
                          ),
                          color: Colors.red,
                          onPressed: () {},
                        ),
                      ),
                    ),
            ],
            flexibleSpace: LayoutBuilder(builder: (context, constraints) {
              var top = constraints.biggest.height;
              return FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  titlePadding: top == 56
                      ? EdgeInsetsDirectional.only(start: 72, bottom: 0)
                      : EdgeInsets.zero,
                  title: Center(
                    child: Column(
                      mainAxisAlignment: top == 56
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        top > 200
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      recipeInfosController.initalRecipe.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "CostaneraAltBold",
                                          fontSize: 17),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Icon(
                                            Icons.thumb_up,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ),
                                        Obx(() {
                                          var count = recipeInfosController
                                              .recipeSelected.value!.likes;
                                          print("refzi");
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              count <= 1
                                                  ? "${count} curtida"
                                                  : "${count} curtidas",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontFamily:
                                                      "CostaneraAltBold"),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        top == 56
                            ? Row(
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      recipeInfosController.initalRecipe.title,
                                      maxLines: 1,
                                      minFontSize: 15,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: CustomTheme.thirdColor,
                                          fontFamily: "CostaneraAltBold"),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20,
                                      child: IconButton(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        padding: EdgeInsets.zero,
                                        icon: Icon(Icons.share),
                                        color: Colors.transparent,
                                        onPressed: null,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        top > 120
                            ? Container(
                                color: Colors.black.withOpacity(0.5),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                FontAwesomeIcons.clock,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 3.0),
                                              child: Text(
                                                "${recipeInfosController.initalRecipe.infos.preparationTime} minutos",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontFamily:
                                                        "CostaneraAltMedium"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: VerticalDivider(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  CustomIcons.tray_svgrepo_com,
                                                  color: Colors.white,
                                                  size: 15,
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Text(
                                                "${recipeInfosController.initalRecipe.infos.yieldRecipe.toString()} porções",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontFamily:
                                                        "CostaneraAltMedium"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      isMyRecipe
                                          ? Container()
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              child: VerticalDivider(
                                                color: Colors.white,
                                              ),
                                            ),
                                      isMyRecipe
                                          ? Container()
                                          : Expanded(
                                              flex: 2,
                                              child: Obx(() {
                                                return IconButton(
                                                    onPressed: () {
                                                      recipeInfosController
                                                          .likeRecipe();
                                                    },
                                                    constraints:
                                                        BoxConstraints(),
                                                    padding: EdgeInsets.zero,
                                                    icon: recipeInfosController
                                                            .isLiked.value
                                                        ? Icon(
                                                            Icons
                                                                .thumb_up_sharp,
                                                            fill: 1,
                                                            color: Colors.white,
                                                            size: 15,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .thumb_up_outlined,
                                                            color: Colors.white,
                                                            size: 15,
                                                          ));
                                              }),
                                            )
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  background: top == 56
                      ? Container()
                      : Stack(
                          children: [
                            recipeInfosController.initalRecipe.imageUrl
                                        .startsWith("https://firebase") ||
                                    recipeInfosController
                                            .initalRecipe.imageUrl ==
                                        ""
                                ? ImageTile(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    imageUrl: recipeInfosController
                                                .initalRecipe.imageUrl ==
                                            ""
                                        ? "https://firebasestorage.googleapis.com/v0/b/tudoemcasareceitas-e865a.appspot.com/o/background.png?alt=media&token=c1e73d52-bf40-46a5-aa3f-b8454f1721a0"
                                        : recipeInfosController
                                            .initalRecipe.imageUrl,
                                  )
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    child: Image.file(
                                      File(
                                        recipeInfosController
                                            .initalRecipe.imageUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            Container(
                              color: Colors.black.withOpacity(0.4),
                              height: MediaQuery.of(context).size.height,
                            )
                          ],
                        ));
            }),
          )
        ];
      }, body: SingleChildScrollView(child: Obx(() {
        print(recipeInfosController.listIngredients);
        print(recipeInfosController.listPreparations);
        return Column(children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    flex: 45,
                    child: Row(
                      children: [
                        ImageTile(
                          height: 60,
                          width: 60,
                          imageUrl: recipeInfosController
                              .initalRecipe.userInfo!.imageUrl,
                          borderRadius: BorderRadius.circular(75),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  recipeInfosController
                                      .initalRecipe.userInfo!.name,
                                  style: TextStyle(
                                      fontFamily: "CostaneraAltBold",
                                      fontSize: 19)),
                              Text(
                                  "${recipeInfosController.initalRecipe.userInfo!.followers} seguidores",
                                  style: TextStyle(
                                      fontFamily: "CostaneraAltBook",
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 55,
                    child: isMyRecipe
                        ? Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: GFButton(
                              size: GFSize.MEDIUM,
                              color: isPreview
                                  ? Colors.grey
                                  : CustomTheme.thirdColor,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              onPressed: isPreview
                                  ? null
                                  : () async {
                                      recipeInfosController.updateRecipeLike();
                                      Get.offNamed(Routes.UPDATE_RECIPE,
                                          arguments: {
                                            "recipe": recipeInfosController
                                                .recipeSelected
                                                .toJson()
                                          });
                                    },
                              shape: GFButtonShape.pills,
                              type: GFButtonType.outline2x,
                              child: Text(
                                "Editar Receita",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: GFButton(
                              size: GFSize.MEDIUM,
                              color: CustomTheme.thirdColor,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              onPressed: () async {},
                              shape: GFButtonShape.pills,
                              child: Text(
                                "Seguir",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.red,
            thickness: 1,
          ),
          RecipeInfosListWidget(
            listItems: recipeInfosController.listIngredients,
          ),
          RecipeInfosListPreparationWidget(
            listItems: recipeInfosController.listPreparations,
          ),
          Row(
            children: [
              Expanded(
                  child: Divider(
                color: Colors.red,
                thickness: 1,
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "CATEGORIAS RELACIONADAS",
                  style: TextStyle(
                      fontFamily: "CostaneraAltBook",
                      color: CustomTheme.thirdColor),
                ),
              ),
              Expanded(
                  child: Divider(
                color: Colors.red,
                thickness: 1,
              )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: recipeInfosController.initalRecipe.categories
                    .map((element) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            onTap: isPreview
                                ? null
                                : () {
                                    Get.toNamed(Routes.RECIPE_CATEGORY,
                                        arguments: {"category": element});
                                  },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Text(
                                  element
                                      .toString()
                                      .toLowerCase()
                                      .capitalizeFirstLetter(),
                                  style: const TextStyle(
                                      fontFamily: "CostaneraAltBook",
                                      color: Colors.white)),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          isMyRecipe
              ? Container()
              : Divider(
                  color: Colors.red,
                  thickness: 1,
                ),
          isMyRecipe
              ? Container()
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16.0),
                  child: Row(children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Gostou da Receita? Dê uma curtida para incentivar o criador a produzir mais.",
                            style: TextStyle(fontFamily: "CostaneraAltBook")),
                      ),
                    ),
                    Obx(() {
                      return GFButton(
                          size: GFSize.MEDIUM,
                          color: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          onPressed: () async {
                            recipeInfosController.likeRecipe();
                          },
                          shape: GFButtonShape.pills,
                          type: recipeInfosController.isLiked.value
                              ? GFButtonType.solid
                              : GFButtonType.outline2x,
                          child: Row(
                            children: [
                              recipeInfosController.isLiked.value
                                  ? Icon(
                                      Icons.thumb_up_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  : Icon(
                                      Icons.thumb_up_outlined,
                                      color: Colors.red,
                                      size: 25,
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: recipeInfosController.isLiked.value
                                    ? Text(
                                        "Curtiu",
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : Text(
                                        "Curtir",
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.red),
                                      ),
                              ),
                            ],
                          ));
                    }),
                  ]),
                )
        ]);
      }))),
    );
  }
}
