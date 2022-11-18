import 'dart:io';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tudo_em_casa_receitas/controller/profile_controller.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_controller.dart';
import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/model/user_model.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/image_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/loader_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/my_recipe_card_tile.dart';

import 'tile/profile_item_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserController userController = Get.find();
  ProfileController profileController = Get.find();
  RecipeResultController recipeResultController = Get.find();
  bool isMyUser = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    var widthDefault = MediaQuery.of(context).size.width / 2.75;

    return SafeArea(
      child: Obx(() {
        var user = profileController.profileSelected.value;

        if (isLoading || profileController.isLoadingUpdateFollowUser.value) {
          return const SizedBox(
            height: 50,
            child: Center(
                child: LoaderTile(
              size: GFSize.LARGE,
            )),
          );
        }

        return WillPopScope(
          onWillPop: () async {
            if (profileController.isLoading.value) {
              return Future.delayed(Duration.zero, () => false);
            }
            if (profileController.isPhotoWallpaperSelected.value ||
                profileController.isPhotoImageSelected.value) {
              profileController.removePhotoSelected();
            } else {
              if (profileController.persistData) {
                recipeResultController.initData();
                Get.offAllNamed(Routes.MAIN_PAGE);
              } else {
                await profileController.updateFollowUser();
                Get.back(result: profileController.updatedLike);
              }

              userController.updateIndexSelected(0);
            }
            return false;
          },
          child: Scaffold(
            appBar: profileController.isPhotoWallpaperSelected.value ||
                    profileController.isPhotoImageSelected.value
                ? AppBar(
                    leading: IconButton(
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.arrow_back,
                          color: Theme.of(context).dialogBackgroundColor),
                      onPressed: () {
                        if (!profileController.isLoading.value) {
                          profileController.removePhotoSelected();
                        }
                      },
                    ),
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade900
                            : CustomTheme.greyAccent,
                    actions: [
                        Obx(() {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GFButton(
                              size: GFSize.SMALL,
                              color: Theme.of(context).secondaryHeaderColor,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              onPressed: profileController.isLoading.value
                                  ? null
                                  : () async {
                                      var res = await profileController
                                          .confirmProfilePhoto();
                                      if (mounted) {
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
                                            res == ""
                                                ? "Dados atualizados com sucesso!!"
                                                : res,
                                            context);
                                      }
                                    },
                              shape: GFButtonShape.pills,
                              child: const Text(
                                "Salvar alterações",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white),
                                maxLines: 1,
                              ),
                            ),
                          );
                        }),
                      ])
                : null,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade900
                : CustomTheme.greyAccent,
            body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 175 + widthDefault / 2,
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 8, color: Colors.white))),
                            child: Stack(
                              children: [
                                Obx(() {
                                  return profileController
                                          .isPhotoWallpaperSelected.value
                                      ? Image.file(File(user.wallpaperImage),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 175,
                                          fit: BoxFit.cover)
                                      : ImageTile(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 175,
                                          imageUrl: user.wallpaperImage);
                                }),
                                isMyUser
                                    ? Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: IconButton(
                                                splashColor: Colors.transparent,
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                constraints:
                                                    const BoxConstraints(),
                                                highlightColor:
                                                    Colors.transparent,
                                                onPressed: () {
                                                  if (!profileController
                                                      .isLoading.value) {
                                                    showModalPickImage(context,
                                                        isWallpaper: true);
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Positioned.fill(child: Container()),
                                profileController
                                            .isPhotoWallpaperSelected.value ||
                                        profileController
                                            .isPhotoImageSelected.value
                                    ? Positioned.fill(child: Container())
                                    : Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 20,
                                              child: IconButton(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                padding: EdgeInsets.zero,
                                                icon: const Icon(
                                                  Icons.arrow_back,
                                                ),
                                                color: context
                                                    .theme.secondaryHeaderColor,
                                                onPressed: () async {
                                                  if (profileController
                                                      .persistData) {
                                                    recipeResultController
                                                        .initData();
                                                    Get.offAllNamed(
                                                        Routes.MAIN_PAGE);
                                                  } else {
                                                    await profileController
                                                        .updateFollowUser();
                                                    Get.back(
                                                        result:
                                                            profileController
                                                                .updatedLike);
                                                  }
                                                  userController
                                                      .updateIndexSelected(0);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Obx(() {
                                return profileController
                                        .isPhotoImageSelected.value
                                    ? ImageTile(
                                        width: widthDefault,
                                        height: widthDefault,
                                        borderRadius: BorderRadius.circular(80),
                                        isBorderCircle: true,
                                        isFile: true,
                                        imageUrl: user.image)
                                    : ImageTile(
                                        width: widthDefault,
                                        height: widthDefault,
                                        borderRadius: BorderRadius.circular(80),
                                        isBorderCircle: true,
                                        imageUrl: user.image);
                              }),
                            ),
                          ),
                          isMyUser
                              ? Positioned.fill(
                                  left: widthDefault / 1.7,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: IconButton(
                                          splashColor: Colors.transparent,
                                          padding: const EdgeInsets.all(4.0),
                                          constraints: const BoxConstraints(),
                                          highlightColor: Colors.transparent,
                                          onPressed: () {
                                            if (!profileController
                                                .isLoading.value) {
                                              showModalPickImage(context,
                                                  isWallpaper: false);
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Text(
                        user.name,
                        style: const TextStyle(
                            fontFamily: "CostaneraAltBold", fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 24.0, left: 16.0, right: 16.0),
                      child: Text(
                        user.description,
                        style: const TextStyle(
                            fontFamily: "CostaneraAltBook", fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: GFButton(
                        size: GFSize.LARGE,
                        fullWidthButton: true,
                        color: Theme.of(context).dialogBackgroundColor,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        onPressed: () async {
                          if (isMyUser && !profileController.isLoading.value) {
                            profileController.usernameText = user.name;
                            profileController.descriptionText =
                                user.description;
                            Get.toNamed(Routes.EDIT_PROFILE);
                          } else {
                            profileController
                                .updateFollow(userController.currentUser.value);
                          }
                        },
                        shape: GFButtonShape.pills,
                        type: isMyUser || profileController.isFollowing.value
                            ? GFButtonType.outline2x
                            : GFButtonType.solid,
                        child: Text(
                          isMyUser
                              ? "Editar Perfil"
                              : profileController.isFollowing.value
                                  ? "Seguindo"
                                  : "Seguir",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color:
                                      !profileController.isFollowing.value &&
                                              !isMyUser
                                          ? Theme.of(context)
                                              .bottomSheetTheme
                                              .backgroundColor
                                          : Theme.of(context)
                                              .dialogBackgroundColor),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ProfileItemTile(
                              title: "Receitas Enviadas",
                              value: user.recipeList
                                  .where(
                                      (element) => element.isRevision == false)
                                  .length,
                            ),
                          ),
                          Expanded(
                            child: ProfileItemTile(
                              title: "Seguidores",
                              value: user.followers,
                            ),
                          ),
                          Expanded(
                            child: ProfileItemTile(
                              title: "Seguindo",
                              value: user.following,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Text(isMyUser ? "Minhas Receitas" : "Receitas",
                              style: const TextStyle(
                                  fontFamily: "CostaneraAltBold",
                                  fontSize: 23)),
                          const Spacer(),
                          profileController.myRecipesProfile.length > 5
                              ? GestureDetector(
                                  onTap: () async {
                                    if (isMyUser &&
                                        !profileController.isLoading.value) {
                                      Get.toNamed(Routes.MY_RECIPES);
                                    } else {
                                      Get.toNamed(Routes.RECIPE_LIST_USER,
                                          arguments: {
                                            "user": UserModel.toMap(
                                                profileController
                                                    .profileSelected.value)
                                          });
                                    }
                                  },
                                  child: Text("Ver Tudo",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(fontSize: 18)
                                      /* TextStyle(
                                              fontFamily: "CostaneraAltBook",
                                              fontSize: 18,
                                              color: Theme.of(context).secondaryHeaderColor)*/
                                      ))
                              : Container(),
                        ],
                      ),
                    ),
                    Obx(() {
                      if (profileController.statusMyRecipesProfile.value ==
                          StatusMyRecipesProfile.Finished) {
                        return Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: DynamicHeightGridView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount:
                                MediaQuery.of(context).size.width ~/ 130,
                            mainAxisSpacing: 15.0,
                            crossAxisSpacing: 10.0,
                            itemCount:
                                profileController.myRecipesProfile.length,
                            builder: (ctx, index) {
                              return InkWell(
                                onTap: () {
                                  if (!profileController.isLoading.value) {
                                    Get.toNamed(
                                        "${Routes.RECIPE_VIEW}/${profileController.myRecipesProfile[index].id}",
                                        arguments: {
                                          "recipe": profileController
                                              .myRecipesProfile[index]
                                              .toJson(),
                                          "isMyRecipe": userController
                                              .isMyRecipe(profileController
                                                  .myRecipesProfile[index]),
                                        });
                                  }
                                },
                                child: Obx(() {
                                  return MyRecipeCardTile(
                                      recipe: profileController
                                          .myRecipesProfile[index],
                                      isMyUser: isMyUser,
                                      isClickable:
                                          !profileController.isLoading.value);
                                }),
                              );
                            },
                          ),
                        );
                      } else if (profileController
                              .statusMyRecipesProfile.value ==
                          StatusMyRecipesProfile.Error) {
                        return const SizedBox(
                            height: 50,
                            child: Center(
                              child: Text(
                                "Erro ao carregar receitas, verifique sua conexão",
                              ),
                            ));
                      } else {
                        return const SizedBox(
                          height: 50,
                          child: Center(
                              child: LoaderTile(
                            size: GFSize.LARGE,
                          )),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  showModalPickImage(BuildContext context, {required bool isWallpaper}) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ListTile(
                    title: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Tirar foto da câmera",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "CostaneraAltBook",
                        ),
                      ),
                    ),
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image == null) return;
                      profileController.updateProfilePhoto(image.path,
                          isWallpaper: isWallpaper);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                    leading: CircleAvatar(
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
                  child: ListTile(
                      title: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Selecionar foto da galeria",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "CostaneraAltBook",
                          ),
                        ),
                      ),
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image == null) return;
                        profileController.updateProfilePhoto(image.path,
                            isWallpaper: isWallpaper);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor,
                          child: const Icon(
                            FontAwesomeIcons.image,
                            color: Colors.white,
                          ))),
                ),
              ],
            ),
          );
        });
  }

  bool isLoading = true;
  _getData() async {
    if (Get.arguments != null && mounted) {
      isLoading = true;
      var userId = Get.arguments["userId"];
      await profileController.loadData(userId);
      profileController.getRecipesFromUser(
        // ignore: use_build_context_synchronously
        MediaQuery.of(context).size.width ~/ 130,
      );
      profileController.initializeFollow(userController.currentUser.value);

      isMyUser = Get.arguments["isMyUser"] ?? false;
    }
    isLoading = false;
    return [];
  }

  @override
  void dispose() {
    profileController.isLoadingUpdateFollowUser.value = false;
    super.dispose();
  }
}
