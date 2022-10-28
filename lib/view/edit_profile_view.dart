import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tudo_em_casa_receitas/controller/profile_controller.dart';
import 'package:tudo_em_casa_receitas/model/user_model.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tudo_em_casa_receitas/view/tile/custom_text_form_field_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/image_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/loader_tile.dart';
import 'package:tudo_em_casa_receitas/view/widgets/app_bar_text_widget.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({super.key});
  ProfileController profileController = Get.find();
  final totalHeight = 175.0;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var user = profileController.profileSelected.value;
      return Scaffold(
        appBar: AppBarWithText(
          text: "Editar perfil",
          showDrawer: false,
          centerTitle: false,
          textColor: context.theme.secondaryHeaderColor,
          onPressed: () {
            if (profileController.isLoading.value) return;
            if (profileController.changedAnyData()) {
              FocusScope.of(context).unfocus();
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Editar Perfil",
                        style: TextStyle(fontFamily: "CostaneraAltBold"),
                      ),
                      content: Text(
                        "Descartar Alterações?",
                        style: TextStyle(fontFamily: "CostaneraAltBook"),
                      ),
                      actions: [
                        GFButton(
                            shape: GFButtonShape.pills,
                            color: context.theme.secondaryHeaderColor,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancelar",
                              style: TextStyle(fontFamily: "CostaneraAltBold"),
                            )),
                        GFButton(
                            shape: GFButtonShape.pills,
                            color: context.theme.secondaryHeaderColor,
                            onPressed: () {
                              profileController.removePhotoSelected();
                              Get.back();
                              Get.back();
                            },
                            child: Text(
                              "Decartar",
                              style: TextStyle(fontFamily: "CostaneraAltBold"),
                            ))
                      ],
                    );
                  });
            } else {
              Get.back();
            }
          },
        ),
        body: WillPopScope(
          onWillPop: () {
            if (profileController.isLoading.value) {
              return Future.delayed(Duration.zero, () => false);
            }
            if (profileController.changedAnyData()) {
              FocusScope.of(context).unfocus();
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Editar Perfil",
                        style: TextStyle(fontFamily: "CostaneraAltBold"),
                      ),
                      content: Text(
                        "Descartar Alterações?",
                        style: TextStyle(fontFamily: "CostaneraAltBook"),
                      ),
                      actions: [
                        GFButton(
                            shape: GFButtonShape.pills,
                            color: context.theme.secondaryHeaderColor,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancelar",
                              style: TextStyle(fontFamily: "CostaneraAltBold"),
                            )),
                        GFButton(
                            shape: GFButtonShape.pills,
                            color: context.theme.secondaryHeaderColor,
                            onPressed: () {
                              profileController.removePhotoSelected();
                              Get.back();
                              Get.back();
                            },
                            child: Text(
                              "Decartar",
                              style: TextStyle(fontFamily: "CostaneraAltBold"),
                            ))
                      ],
                    );
                  });
            } else {
              Get.back();
            }
            return Future.delayed(Duration.zero, () => false);
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: totalHeight + (totalHeight / 1.5) / 2,
                    child: Stack(
                      children: [
                        profileController.isPhotoWallpaperSelected.value
                            ? Image.file(File(user.wallpaperImage),
                                width: MediaQuery.of(context).size.width,
                                height: totalHeight,
                                fit: BoxFit.cover)
                            : ImageTile(
                                width: MediaQuery.of(context).size.width,
                                height: totalHeight,
                                imageUrl: user.wallpaperImage),
                        InkWell(
                          borderRadius: BorderRadius.circular(80),
                          onTap: () {
                            showModalPickImage(context, isWallpaper: true);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: ClipRRect(
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: totalHeight,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: profileController.isPhotoImageSelected.value
                                ? ImageTile(
                                    width: totalHeight / 1.5,
                                    height: totalHeight / 1.5,
                                    borderRadius: BorderRadius.circular(80),
                                    isBorderCircle: true,
                                    isFile: true,
                                    imageUrl: user.image)
                                : ImageTile(
                                    width: totalHeight / 1.5,
                                    height: totalHeight / 1.5,
                                    borderRadius: BorderRadius.circular(80),
                                    isBorderCircle: true,
                                    imageUrl: user.image)),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(80),
                            onTap: () {
                              showModalPickImage(context, isWallpaper: false);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8), // Border width
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: SizedBox(
                                    width: totalHeight / 1.5,
                                    height: totalHeight / 1.5,
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextFormFieldTile(
                        hintText: "Digite o nome de usuário",
                        labelText: "Nome do usuário",
                        keyboardType: TextInputType.name,
                        initialValue: user.name,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        validator: (value) {
                          if (value == "") {
                            return "Usuário não pode ser vazio";
                          } else if (value!.length > 20) {
                            return "Usuário só pode ter no maximo 20 caracteres";
                          }
                          return null;
                        },
                        onChanged: profileController.updateUsernameText),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextFormFieldTile(
                        hintText: "Digite a descrição",
                        labelText: "Descrição",
                        keyboardType: TextInputType.name,
                        initialValue: user.description,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value!.length > 50) {
                            return "Descrição só pode ter no maximo 50 caracteres";
                          }
                          return null;
                        },
                        onChanged: profileController.updateDescriptionText),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 84),
                    child: Obx(() {
                      return GFButton(
                        size: GFSize.LARGE,
                        color: context.theme.secondaryHeaderColor,
                        fullWidthButton: true,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        onPressed: profileController.isLoading.value
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  var res =
                                      await profileController.updateUser();
                                  GFToast.showToast(
                                      backgroundColor: context
                                          .theme.textTheme.titleMedium!.color!,
                                      textStyle: TextStyle(
                                        color: context.theme.bottomSheetTheme
                                            .backgroundColor,
                                      ),
                                      toastDuration: 3,
                                      toastPosition: GFToastPosition.BOTTOM,
                                      res == ""
                                          ? "Dados atualizados com sucesso!!"
                                          : res,
                                      context);
                                  if (res == "") {
                                    Get.back();
                                  }
                                }
                              },
                        shape: GFButtonShape.pills,
                        child: profileController.isLoading.value
                            ? LoaderTile(color: Colors.white)
                            : Text(
                                "Salvar alterações",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                      );
                    }),
                  ),
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
                        backgroundColor: context.theme.secondaryHeaderColor,
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
                          backgroundColor: context.theme.secondaryHeaderColor,
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
}
