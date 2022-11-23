import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/controller/admin_controller.dart';
import 'package:tudo_em_casa_receitas/model/measure_model.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/view/tile/custom_text_recipe_tile.dart';
import 'package:tudo_em_casa_receitas/view/tile/loader_tile.dart';

class CardMeasureRevisionTile extends StatelessWidget {
  final Measure measure;
  CardMeasureRevisionTile({required this.measure, super.key});
  final AdminController adminController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Medida",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Text("Nome: ${measure.name} | Plural: ${measure.plural}"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("UserId: ${measure.userId}"),
                ),
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).textTheme.titleMedium!.color,
            thickness: 1,
            height: 0,
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    adminController.verifySimilarMeasure(measure);
                    _showDialogDelete(context);
                  },
                  child: GFButton(
                      icon: const Icon(
                        FontAwesomeIcons.xmark,
                        color: Colors.red,
                      ),
                      onPressed: null,
                      type: GFButtonType.transparent,
                      textStyle:
                          Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontFamily: "Arial",
                                fontSize: 14,
                                color: Colors.red,
                              ),
                      child: const Text("Rejeitar")),
                )),
                VerticalDivider(
                  color: Theme.of(context).textTheme.titleMedium!.color,
                  width: 0,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    _showDialogAccept(context);
                  },
                  child: GFButton(
                      icon: const Icon(
                        FontAwesomeIcons.check,
                        color: Colors.green,
                      ),
                      onPressed: null,
                      textStyle:
                          Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontFamily: "Arial",
                                fontSize: 14,
                                color: Colors.green,
                              ),
                      type: GFButtonType.transparent,
                      child: const Text("Aceitar")),
                ))
              ],
            ),
          )
        ],
      )),
    );
  }

  _showDialogDelete(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((ctx) {
          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.background
                : Colors.white,
            title: const CustomTextRecipeTile(
              text: "Confirmar rejeitamento",
              required: false,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Deeja realmente rejeitar a medida?",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Text("Nome: ${measure.name} | Plural: ${measure.plural}"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "UserId: ${measure.userId}",
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Medidas iguais/similares",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Obx(() {
                  if (adminController.isLoadingSimilarMeasures.value) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: LoaderTile(),
                    );
                  }
                  if (adminController.similarMeasure.value.name != "") {
                    Measure similarMeasure =
                        adminController.similarMeasure.value;

                    return Column(
                      children: [
                        Text(
                            "Nome: ${similarMeasure.name} | Plural: ${similarMeasure.plural}"),
                      ],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Não há Medidas similares",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 13)),
                    );
                  }
                })
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GFButton(
                      size: GFSize.MEDIUM,
                      color: Theme.of(context).dialogBackgroundColor,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      textColor: Theme.of(context).dialogBackgroundColor,
                      type: GFButtonType.outline,
                      shape: GFButtonShape.pills,
                      child: const Text(
                        "Cancelar",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  Obx(() {
                    return Center(
                      child: GFButton(
                        size: GFSize.MEDIUM,
                        color: Theme.of(context).secondaryHeaderColor,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        onPressed: adminController.isLoadingActionMeasures.value
                            ? null
                            : () async {
                                var result = await adminController
                                    .rejectMeasure(measure);

                                if (result) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                  // ignore: use_build_context_synchronously
                                  GFToast.showToast(
                                      backgroundColor: context
                                          .theme.textTheme.titleMedium!.color!,
                                      textStyle: TextStyle(
                                        color: context.theme.bottomSheetTheme
                                            .backgroundColor,
                                      ),
                                      toastDuration: 3,
                                      toastPosition: GFToastPosition.BOTTOM,
                                      "Medida rejeitado com sucesso",
                                      context);
                                } else {
                                  // ignore: use_build_context_synchronously
                                  GFToast.showToast(
                                      backgroundColor: context
                                          .theme.textTheme.titleMedium!.color!,
                                      textStyle: TextStyle(
                                        color: context.theme.bottomSheetTheme
                                            .backgroundColor,
                                      ),
                                      toastDuration: 3,
                                      toastPosition: GFToastPosition.BOTTOM,
                                      "Nao foi possivel excluir o medida",
                                      context);
                                }
                              },
                        shape: GFButtonShape.pills,
                        child: const Text(
                          "Confirmar rejeite",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    );
                  }),
                ],
              )
            ],
          );
        }));
  }

  _showDialogAccept(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((ctx) {
          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.background
                : Colors.white,
            title: const CustomTextRecipeTile(
              text: "Confirmar aceitamento",
              required: false,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Deseja realmente aceitar a medida?",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Text("Nome: ${measure.name} | Plural: ${measure.plural}"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "UserId: ${measure.userId}",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GFButton(
                      size: GFSize.MEDIUM,
                      color: Theme.of(context).dialogBackgroundColor,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      textColor: Theme.of(context).dialogBackgroundColor,
                      type: GFButtonType.outline,
                      shape: GFButtonShape.pills,
                      child: const Text(
                        "Cancelar",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  Obx(() {
                    return Center(
                      child: GFButton(
                        size: GFSize.MEDIUM,
                        color: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        onPressed: adminController.isLoadingActionMeasures.value
                            ? null
                            : () async {
                                var result = await adminController
                                    .acceptMeasure(measure);

                                if (result) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                  // ignore: use_build_context_synchronously
                                  GFToast.showToast(
                                      backgroundColor: context
                                          .theme.textTheme.titleMedium!.color!,
                                      textStyle: TextStyle(
                                        color: context.theme.bottomSheetTheme
                                            .backgroundColor,
                                      ),
                                      toastDuration: 3,
                                      toastPosition: GFToastPosition.BOTTOM,
                                      "Medida aceita com sucesso",
                                      context);
                                } else {
                                  // ignore: use_build_context_synchronously
                                  GFToast.showToast(
                                      backgroundColor: context
                                          .theme.textTheme.titleMedium!.color!,
                                      textStyle: TextStyle(
                                        color: context.theme.bottomSheetTheme
                                            .backgroundColor,
                                      ),
                                      toastDuration: 3,
                                      toastPosition: GFToastPosition.BOTTOM,
                                      "Nao foi possivel aceitar a medida",
                                      context);
                                }
                              },
                        shape: GFButtonShape.pills,
                        child: const Text(
                          "Confirmar aceite",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    );
                  }),
                ],
              )
            ],
          );
        }));
  }
}
