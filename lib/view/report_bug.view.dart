// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tudo_em_casa_receitas/controller/report_bug_controller.dart';
import 'package:tudo_em_casa_receitas/view/tile/image_tile.dart';
import 'dart:math' as math;

class ReportBugView extends StatelessWidget {
  ReportBugView({Key? key}) : super(key: key);
  final ReportBugController reportBugController = Get.find();
  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Reporta um problema",
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
          ),
          leading: IconButton(
            splashColor: Colors.transparent,
            splashRadius: 20,
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).dialogBackgroundColor,
            ),
          ),
          actions: [
            Transform.rotate(
                angle: 225 * math.pi / 180,
                child: IconButton(
                    splashColor: Colors.transparent,
                    splashRadius: 20,
                    onPressed: () {
                      showModalPickImage(context);
                    },
                    icon: Icon(
                      FontAwesomeIcons.paperclip,
                      color: Theme.of(context).dialogBackgroundColor,
                    ))),
            IconButton(
                splashColor: Colors.transparent,
                splashRadius: 20,
                onPressed: () async {
                  var res = await reportBugController.sendFeedback();
                  if (res != "") {
                    if (mounted) {
                      GFToast.showToast(
                          backgroundColor:
                              Theme.of(context).textTheme.titleMedium!.color!,
                          textStyle: TextStyle(
                            color: Theme.of(context)
                                .bottomSheetTheme
                                .backgroundColor,
                          ),
                          toastDuration: 3,
                          toastPosition: GFToastPosition.BOTTOM,
                          res,
                          context);
                    }
                  } else {
                    if (mounted) {
                      Navigator.of(context).pop();
                      GFToast.showToast(
                          backgroundColor:
                              Theme.of(context).textTheme.titleMedium!.color!,
                          textStyle: TextStyle(
                            color: Theme.of(context)
                                .bottomSheetTheme
                                .backgroundColor,
                          ),
                          toastDuration: 3,
                          toastPosition: GFToastPosition.BOTTOM,
                          "Feedback enviado com sucesso. Obrigado!!",
                          context);
                    }
                  }
                },
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).dialogBackgroundColor,
                ))
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Digite o assunto',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).textTheme.titleMedium!.color!,
                            width: 0.5),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).textTheme.titleMedium!.color!,
                            width: 0.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).textTheme.titleMedium!.color!,
                            width: 0.5),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8.0)),
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  onChanged: reportBugController.updateSubject,
                ),
                TextFormField(
                  style: const TextStyle(height: 1.5),
                  decoration: const InputDecoration(
                      hintText: 'Escrever e-mail',
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      border: InputBorder.none,
                      focusColor: Colors.transparent),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  maxLines: null,
                  onChanged: reportBugController.updateContent,
                ),
                Obx(() {
                  return Wrap(
                    alignment: WrapAlignment.start,
                    children: reportBugController.listImages
                        .map((path) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  ImageTile(
                                    width: 75,
                                    height: 75,
                                    imageUrl: path,
                                    isFile: true,
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: IconButton(
                                            splashColor: Colors.transparent,
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            highlightColor: Colors.transparent,
                                            onPressed: () {
                                              reportBugController
                                                  .removeImage(path);
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ))
                        .toList(),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  showModalPickImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
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
                      reportBugController.addImage(image.path);

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
                        reportBugController.addImage(image.path);
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
}
