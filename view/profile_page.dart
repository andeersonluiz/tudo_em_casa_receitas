import 'dart:io';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
import 'package:tudo_em_casa_receitas/view/tile/my_recipe_card_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/error_widget.dart';

import 'tile/profile_item_tile.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

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

    return Obx(() {
      var user = profileController.profileSelected.value;
      print("refiz ${user.id} $isLoading");
      if (isLoading)
        return Container(
          height: 50,
          child: const Center(
            child: GFLoader(
              size: GFSize.LARGE,
              androidLoaderColor:
                  AlwaysStoppedAnimation<Color>(CustomTheme.thirdColor),
            ),
          ),
        );
      return SafeArea(
        child: WillPopScope(
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
                Get.back();
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
                      icon: Icon(Icons.arrow_back, color: Colors.red),
                      onPressed: () {
                        if (!profileController.isLoading.value) {
                          profileController.removePhotoSelected();
                        }
                      },
                    ),
                    backgroundColor: Colors.white,
                    actions: [
                        Obx(() {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GFButton(
                              size: GFSize.SMALL,
                              color: CustomTheme.thirdColor,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              onPressed: profileController.isLoading.value
                                  ? null
                                  : () async {
                                      var res = await profileController
                                          .confirmProfilePhoto();
                                      GFToast.showToast(
                                          toastDuration: 3,
                                          toastPosition: GFToastPosition.BOTTOM,
                                          res == ""
                                              ? "Dados atualizados com sucesso!!"
                                              : res,
                                          context);
                                    },
                              shape: GFButtonShape.pills,
                              child: Text(
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
            backgroundColor: CustomTheme.greyAccent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 175 + widthDefault / 2,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
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
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              constraints:
                                                  const BoxConstraints(),
                                              splashColor: Colors.transparent,
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 20,
                                            child: IconButton(
                                              highlightColor:
                                                  Colors.transparent,
                                              splashColor: Colors.transparent,
                                              padding: EdgeInsets.zero,
                                              icon: Icon(
                                                Icons.arrow_back,
                                              ),
                                              color: Colors.red,
                                              onPressed: () async {
                                                print(
                                                    "aaaa ${profileController.persistData}");
                                                if (profileController
                                                    .persistData) {
                                                  print(
                                                      "deletand ${profileController.persistData}");
                                                  recipeResultController
                                                      .initData();
                                                  Get.offAllNamed(
                                                      Routes.MAIN_PAGE);
                                                } else {
                                                  await profileController
                                                      .updateFollowUser();
                                                  Get.back(
                                                      result: profileController
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
                            child: Container(
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
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: IconButton(
                                        padding: const EdgeInsets.all(4.0),
                                        constraints: const BoxConstraints(),
                                        splashColor: Colors.transparent,
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
                      style: TextStyle(
                          fontFamily: "CostaneraAltBold", fontSize: 30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 24.0, left: 16.0, right: 16.0),
                    child: Text(
                      user.description,
                      style: TextStyle(
                          fontFamily: "CostaneraAltBook", fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: GFButton(
                      size: GFSize.LARGE,
                      fullWidthButton: true,
                      color: CustomTheme.thirdColor,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      onPressed: () async {
                        if (isMyUser && !profileController.isLoading.value) {
                          profileController.usernameText = user.name;
                          profileController.descriptionText = user.description;
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
                            value: user.recipeList.length,
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
                                fontFamily: "CostaneraAltBold", fontSize: 23)),
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
                                    style: TextStyle(
                                        fontFamily: "CostaneraAltBook",
                                        fontSize: 18,
                                        color: Colors.red)),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Obx(() {
                    print(userController.statusMyRecipes.value);
                    print(profileController.myRecipesProfile.length);

                    if (profileController.statusMyRecipesProfile.value ==
                        StatusMyRecipesProfile.Finished) {
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: DynamicHeightGridView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount:
                                MediaQuery.of(context).size.width ~/ 130,
                            mainAxisSpacing: 15.0,
                            crossAxisSpacing: 10.0,
                            itemCount:
                                profileController.myRecipesProfile.length,
                            builder: (ctx, index) {
                              return Container(
                                child: InkWell(
                                  onTap: () {
                                    if (!profileController.isLoading.value) {
                                      Get.toNamed(Routes.RECIPE_VIEW,
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
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else if (profileController.statusMyRecipesProfile.value ==
                        StatusMyRecipesProfile.Error) {
                      print("entri");
                      return Container(
                          height: 50,
                          child: Center(
                            child: Text(
                              "Erro ao carregar receitas, verifique sua conexão",
                            ),
                          ));
                    } else {
                      return Container(
                        height: 50,
                        child: const Center(
                          child: GFLoader(
                            size: GFSize.LARGE,
                            androidLoaderColor: AlwaysStoppedAnimation<Color>(
                                CustomTheme.thirdColor),
                          ),
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  showModalPickImage(BuildContext context, {required bool isWallpaper}) {
    return showModalBottomSheet(
        context: context,
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
                      Navigator.of(context).pop();
                    },
                    leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(
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
                        Navigator.of(context).pop();
                      },
                      leading: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Icon(
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
    if (Get.arguments != null) {
      isLoading = true;
      print("fufufu");
      var userId = Get.arguments["userId"];
      await profileController.loadData(userId);
      profileController.getRecipesFromUser(
        MediaQuery.of(context).size.width ~/ 130,
      );
      profileController.initializeFollow(userController.currentUser.value);

      isMyUser = Get.arguments["isMyUser"] ?? false;
    }
    isLoading = false;
    return [];
  }
}
