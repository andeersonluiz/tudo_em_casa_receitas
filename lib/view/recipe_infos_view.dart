// ignore_for_file: avoid_print

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tudo_em_casa_receitas/controller/favorite_controller.dart';
import 'package:tudo_em_casa_receitas/controller/like_controller.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/model/recipe_model.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/image_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/loader_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/recipe_infos_list_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:math' as math;

import '../controller/recipe_infos_controller.dart';
import '../support/custom_icons_icons.dart';
import 'widgets/recipe_infos_list_preparation_widget.dart';

class RecipeInfosView extends StatefulWidget {
  const RecipeInfosView({super.key});

  @override
  State<RecipeInfosView> createState() => _RecipeInfosViewState();
}

class _RecipeInfosViewState extends State<RecipeInfosView> with RouteAware {
  bool isMyRecipe = true;
  bool isPreview = false;
  bool isFavorite = false;
  bool isLiked = false;
  RecipeInfosController recipeInfosController = Get.find();
  FavoriteController favoriteController = Get.find();
  LikeController likeController = Get.find();
  RecipeResultController recipeResultController = Get.find();
  UserController userController = Get.find();
  bool isLoading = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    if (Get.arguments != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        isLoading = true;
        if (Get.arguments["isPreview"] != null) {
          isPreview = Get.arguments["isPreview"];
        }

        Recipe recipe;
        if (isPreview) {
          recipe = Recipe.fromJson(
              Get.arguments["recipe"], Get.arguments["recipe"]["id"]);
        } else {
          recipe = await recipeInfosController
              .getRecipe(Get.arguments["recipe"]["id"]);
        }

        if (Get.arguments["isFavorite"] != null) {
          recipe.isFavorite = Get.arguments["isFavorite"];
        }
        if (Get.arguments["isLiked"] != null) {
          recipe.isLiked = Get.arguments["isLiked"];
        }
        isMyRecipe = Get.arguments["isMyRecipe"];

        await recipeInfosController.loadData(recipe);
        await userController.getUser(
            recipeInfosController.recipeSelected.value!.userInfo!.idUser);
        await recipeInfosController.updateViewsAndCategories();
        setState(() {
          isLoading = false;
        });
      });
    } else if (Get.parameters['data'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        isLoading = true;

        Recipe? recipe =
            await recipeInfosController.getRecipe(Get.parameters['data']!);

        if (recipe == null) {
          Get.toNamed(Routes.MAIN_PAGE);
          if (mounted) {
            GFToast.showToast(
                backgroundColor:
                    Theme.of(context).textTheme.titleMedium!.color!,
                textStyle: TextStyle(
                  color: Theme.of(context).bottomSheetTheme.backgroundColor,
                ),
                toastDuration: 4,
                toastPosition: GFToastPosition.BOTTOM,
                "Receita não encontrada",
                context);
          }
        } else {
          isMyRecipe =
              recipe.userInfo!.idUser == userController.currentUser.value.id;

          await recipeInfosController.loadData(recipe);
          await userController.getUser(
              recipeInfosController.recipeSelected.value!.userInfo!.idUser);
          await recipeInfosController.updateViewsAndCategories();
          setState(() {
            isLoading = false;
          });
        }
      });
    } else {
      Get.toNamed(Routes.MAIN_PAGE);
    }

    super.initState();
  }

  String getRandom(int length) {
    const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    math.Random r = math.Random();
    return String.fromCharCodes(
        Iterable.generate(length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SafeArea(child: LoaderTile(size: GFSize.LARGE));
    }
    return SafeArea(
      key: Key(getRandom(15)),
      child: WillPopScope(
        onWillPop: () {
          if ((Get.parameters['data'] != null && Get.arguments == null)) {
            Get.toNamed(Routes.MAIN_PAGE);
          } else {
            Get.back();
          }

          recipeInfosController.updateRecipeLike();
          return Future.delayed(Duration.zero, () => true);
        },
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 230,
                  floating: false,
                  pinned: true,
                  // ignore: deprecated_member_use
                  backgroundColor: Theme.of(context).backgroundColor,
                  leading: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                        color: Theme.of(context).secondaryHeaderColor,
                        onPressed: () {
                          if ((Get.parameters['data'] != null &&
                              Get.arguments == null)) {
                            Get.toNamed(Routes.MAIN_PAGE);
                          } else {
                            Get.back();
                          }

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
                          icon: const Icon(Icons.share),
                          color: isPreview
                              ? CustomTheme.greyColor
                              : Theme.of(context).secondaryHeaderColor,
                          onPressed: isPreview
                              ? () {}
                              : () async {
                                  var url = await recipeInfosController
                                      .generateShorUrl();
                                  Share.share(
                                      'Veja essa receita que incrivel!! $url');
                                },
                        ),
                      ),
                    ),
                    isMyRecipe
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(() {
                              return CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20,
                                child: IconButton(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    recipeInfosController
                                            .recipeSelected.value!.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined,
                                  ),
                                  color: Theme.of(context).secondaryHeaderColor,
                                  onPressed: () async {
                                    await favoriteController.setFavorite(
                                        recipeInfosController
                                            .recipeSelected.value!);
                                    recipeInfosController.setFavorite();
                                  },
                                ),
                              );
                            }),
                          ),
                    isMyRecipe
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 8.0, right: 16.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: DropdownButtonHideUnderline(
                                child: Builder(builder: (context) {
                                  return DropdownButton2(
                                    isExpanded: true,
                                    customButton: Icon(
                                      FontAwesomeIcons.ellipsisVertical,
                                      size: 24,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    ),
                                    onChanged: (value) {
                                      Get.toNamed(
                                        Routes.REPORT,
                                      );
                                    },
                                    items: const [
                                      DropdownMenuItem(
                                          value: "Reportar problema",
                                          child: Text(
                                            "Reportar problema",
                                          )),
                                    ],
                                    itemHeight: 48,
                                    itemPadding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                    ),
                                    dropdownWidth: 160,
                                    dropdownPadding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.white,
                                    ),
                                    style: TextStyle(
                                        fontFamily: 'CostaneraAltBook',
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor),
                                    dropdownElevation: 8,
                                    offset: const Offset(0, 8),
                                  );
                                }),
                              ),
                            ),
                          ),
                  ],
                  flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                    var top = constraints.biggest.height;
                    return FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        titlePadding: top == 56
                            ? const EdgeInsetsDirectional.only(
                                start: 72, bottom: 0)
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            recipeInfosController
                                                .initalRecipe.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: "CostaneraAltBold",
                                                fontSize: 17),
                                          ),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8.0),
                                                child: Icon(
                                                  Icons.thumb_up,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                              ),
                                              Obx(() {
                                                var count =
                                                    recipeInfosController
                                                        .recipeSelected
                                                        .value!
                                                        .likes;
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 4.0),
                                                  child: Text(
                                                    count <= 1
                                                        ? "$count curtida"
                                                        : "$count curtidas",
                                                    style: const TextStyle(
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
                              top > 120
                                  ? Container(
                                      color: Colors.black.withOpacity(0.5),
                                      padding: const EdgeInsets.symmetric(
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
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(
                                                      FontAwesomeIcons.clock,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 3.0),
                                                    child: Text(
                                                      "${recipeInfosController.initalRecipe.infos.preparationTime} minutos",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontFamily:
                                                              "CostaneraAltMedium"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
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
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        CustomIcons
                                                            .tray_svgrepo_com,
                                                        color: Colors.white,
                                                        size: 15,
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0),
                                                    child: Text(
                                                      "${recipeInfosController.initalRecipe.infos.yieldRecipe.toString()} porções",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
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
                                                : const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                                          splashColor: Colors
                                                              .transparent,
                                                          onPressed: () {
                                                            if (userController
                                                                    .currentUser
                                                                    .value
                                                                    .id !=
                                                                "") {
                                                              recipeInfosController
                                                                  .likeRecipe();
                                                              likeController.setLike(
                                                                  recipeInfosController
                                                                      .recipeSelected
                                                                      .value!);
                                                            } else {
                                                              GFToast.showToast(
                                                                  backgroundColor: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium!
                                                                      .color!,
                                                                  textStyle:
                                                                      TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .bottomSheetTheme
                                                                        .backgroundColor,
                                                                  ),
                                                                  toastDuration:
                                                                      4,
                                                                  toastPosition:
                                                                      GFToastPosition
                                                                          .BOTTOM,
                                                                  "Apenas usuarios cadastrados podem curtir receitas.",
                                                                  context);
                                                            }
                                                          },
                                                          constraints:
                                                              const BoxConstraints(),
                                                          padding:
                                                              EdgeInsets.zero,
                                                          icon: recipeInfosController
                                                                  .recipeSelected
                                                                  .value!
                                                                  .isLiked
                                                              ? const Icon(
                                                                  Icons
                                                                      .thumb_up_sharp,
                                                                  fill: 1,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 15,
                                                                )
                                                              : const Icon(
                                                                  Icons
                                                                      .thumb_up_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 15,
                                                                ));
                                                    }),
                                                  )
                                          ],
                                        ),
                                      ),
                                    )
                                  : top == 56
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height: kToolbarHeight,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    recipeInfosController
                                                        .initalRecipe.title,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .dialogBackgroundColor,
                                                        fontFamily: "Arial",
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                radius: 20,
                                                child: IconButton(
                                                    highlightColor:
                                                        Colors.transparent,
                                                    splashColor:
                                                        Colors.transparent,
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(
                                                      Icons.share,
                                                      color: Colors.transparent,
                                                    ),
                                                    color: Colors.transparent,
                                                    onPressed: null),
                                              ),
                                            ),
                                            isMyRecipe
                                                ? Container()
                                                : const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      radius: 20,
                                                      child: IconButton(
                                                          highlightColor: Colors
                                                              .transparent,
                                                          splashColor: Colors
                                                              .transparent,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          icon: Icon(
                                                            Icons.share,
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                          color: Colors
                                                              .transparent,
                                                          onPressed: null),
                                                    ),
                                                  ),
                                            isMyRecipe
                                                ? Container()
                                                : const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 8.0,
                                                        bottom: 8.0,
                                                        left: 8.0,
                                                        right: 16.0),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      radius: 20,
                                                      child: IconButton(
                                                          highlightColor: Colors
                                                              .transparent,
                                                          splashColor: Colors
                                                              .transparent,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          icon: Icon(
                                                            Icons.share,
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                          color: Colors
                                                              .transparent,
                                                          onPressed: null),
                                                    ),
                                                  ),
                                          ],
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          imageUrl: recipeInfosController
                                                      .initalRecipe.imageUrl ==
                                                  ""
                                              ? "https://firebasestorage.googleapis.com/v0/b/tudoemcasareceitas-e865a.appspot.com/o/background.png?alt=media&token=c1e73d52-bf40-46a5-aa3f-b8454f1721a0"
                                              : recipeInfosController
                                                  .initalRecipe.imageUrl,
                                        )
                                      : SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
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
            },
            body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(child: Obx(() {
                print(recipeInfosController.listIngredients);
                print(recipeInfosController.listPreparations);

                return Column(children: [
                  VisibilityDetector(
                    key: const Key('my-widget-key'),
                    onVisibilityChanged: (visibilityInfo) {
                      var visiblePercentage =
                          visibilityInfo.visibleFraction * 100;
                      if (visiblePercentage == 100.0) {}
                    },
                    child: Obx(() {
                      //userController.updateData.value = true;
                      if (userController.isLoading.value) {
                        return const SizedBox(
                            height: 75,
                            child: LoaderTile(
                              size: GFSize.LARGE,
                            ));
                      }
                      var user = userController.userInfo.value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 60,
                                child: Row(
                                  children: [
                                    ImageTile(
                                      height: 60,
                                      width: 60,
                                      imageUrl: user.imageUrl,
                                      borderRadius: BorderRadius.circular(75),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 8.0),
                                        child: SizedBox(
                                          height: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(user.name,
                                                  maxLines: 1,
                                                  minFontSize: 14,
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          "CostaneraAltBold",
                                                      fontSize: 19)),
                                              Text(
                                                  "${user.followers} seguidores",
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          "CostaneraAltBook",
                                                      fontSize: 13)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              isMyRecipe
                                  ? Expanded(
                                      flex: 40,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        child: GFButton(
                                          size: GFSize.MEDIUM,
                                          color: isPreview
                                              ? Colors.grey
                                              : Theme.of(context)
                                                  .dialogBackgroundColor,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 32),
                                          onPressed: isPreview
                                              ? null
                                              : () async {
                                                  recipeInfosController
                                                      .updateRecipeLike();
                                                  Get.offNamed(
                                                      Routes.UPDATE_RECIPE,
                                                      arguments: {
                                                        "recipe":
                                                            recipeInfosController
                                                                .recipeSelected
                                                                .toJson()
                                                      });
                                                },
                                          shape: GFButtonShape.pills,
                                          type: GFButtonType.outline2x,
                                          child: const Text(
                                            "Editar Receita",
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ))
                                  : Expanded(
                                      flex: 40,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        child: GFButton(
                                          size: GFSize.MEDIUM,
                                          color: isPreview
                                              ? Colors.grey
                                              : Theme.of(context)
                                                  .secondaryHeaderColor,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 32),
                                          onPressed: isPreview
                                              ? null
                                              : () async {
                                                  if (userController.currentUser
                                                          .value.id ==
                                                      "") {
                                                    GFToast.showToast(
                                                        backgroundColor: context
                                                            .theme
                                                            .textTheme
                                                            .titleMedium!
                                                            .color!,
                                                        textStyle: TextStyle(
                                                          color: context
                                                              .theme
                                                              .bottomSheetTheme
                                                              .backgroundColor,
                                                        ),
                                                        toastDuration: 4,
                                                        toastPosition:
                                                            GFToastPosition
                                                                .BOTTOM,
                                                        "Apenas usuarios cadastrados podem ver o perfil.",
                                                        context);
                                                  } else {
                                                    var res = await Get.toNamed(
                                                        Routes.PROFILE,
                                                        arguments: {
                                                          "userId": user.idUser,
                                                          "isMyUser": userController
                                                              .isMyRecipe(
                                                                  recipeInfosController
                                                                      .recipeSelected
                                                                      .value!)
                                                        });
                                                    if (res) {
                                                      userController
                                                          .getUser(user.idUser);
                                                    }
                                                  }
                                                },
                                          shape: GFButtonShape.pills,
                                          child: const Text(
                                            "Ver perfil",
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      )),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  Divider(
                    color: Theme.of(context).secondaryHeaderColor,
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
                        color: Theme.of(context).secondaryHeaderColor,
                        thickness: 1,
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "CATEGORIAS RELACIONADAS",
                          style: TextStyle(
                              fontFamily: "CostaneraAltBook",
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        color: Theme.of(context).secondaryHeaderColor,
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
                                        : () async {
                                            Get.offNamed(Routes.RECIPE_CATEGORY,
                                                arguments: {
                                                  "category": element
                                                });
                                            await Future.delayed(const Duration(
                                                milliseconds: 200));
                                            recipeResultController
                                                .clearlistFilters();
                                            recipeResultController
                                                .clearListCategory();
                                          },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 8),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                          borderRadius:
                                              BorderRadius.circular(25)),
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
                          color: Theme.of(context).secondaryHeaderColor,
                          thickness: 1,
                        ),
                  isMyRecipe
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 24, horizontal: 16.0),
                          child: Row(children: [
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    "Gostou da Receita? Dê uma curtida para incentivar o criador a produzir mais.",
                                    style: TextStyle(
                                        fontFamily: "CostaneraAltBook")),
                              ),
                            ),
                            Obx(() {
                              return GFButton(
                                  size: GFSize.MEDIUM,
                                  color: recipeInfosController
                                          .recipeSelected.value!.isLiked
                                      ? Theme.of(context).secondaryHeaderColor
                                      : Theme.of(context).dialogBackgroundColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32),
                                  onPressed: () {
                                    if (userController.currentUser.value.id !=
                                        "") {
                                      recipeInfosController.likeRecipe();
                                      likeController.setLike(
                                          recipeInfosController
                                              .recipeSelected.value!);
                                    } else {
                                      GFToast.showToast(
                                          backgroundColor: context.theme
                                              .textTheme.titleMedium!.color!,
                                          textStyle: TextStyle(
                                            color: Theme.of(context)
                                                .bottomSheetTheme
                                                .backgroundColor,
                                          ),
                                          toastDuration: 4,
                                          toastPosition: GFToastPosition.BOTTOM,
                                          "Apenas usuarios cadastrados podem curtir receitas.",
                                          context);
                                    }
                                  },
                                  shape: GFButtonShape.pills,
                                  type: recipeInfosController
                                          .recipeSelected.value!.isLiked
                                      ? GFButtonType.solid
                                      : GFButtonType.outline2x,
                                  child: Row(
                                    children: [
                                      recipeInfosController
                                              .recipeSelected.value!.isLiked
                                          ? const Icon(
                                              Icons.thumb_up_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            )
                                          : Icon(
                                              Icons.thumb_up_outlined,
                                              color: Theme.of(context)
                                                  .dialogBackgroundColor,
                                              size: 25,
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: recipeInfosController
                                                .recipeSelected.value!.isLiked
                                            ? const Text(
                                                "Curtiu",
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            : Text(
                                                "Curtir",
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: context.theme
                                                        .dialogBackgroundColor),
                                              ),
                                      ),
                                    ],
                                  ));
                            }),
                          ]),
                        )
                ]);
              })),
            )),
      ),
    );
  }
}
