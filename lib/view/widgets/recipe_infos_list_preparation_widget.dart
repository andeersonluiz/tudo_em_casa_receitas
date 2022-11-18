import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_infos_controller.dart';

import 'package:tudo_em_casa_receitas/model/preparation_item.dart';

class RecipeInfosListPreparationWidget extends StatelessWidget {
  final List listItems;
  RecipeInfosListPreparationWidget({required this.listItems, Key? key})
      : super(key: key);
  final RecipeInfosController recipeInfosController = Get.find();
  final double fontSizeTitle = 20;
  final double fontSizeSubTopic = 16;
  final double fontSizeItem = 13;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ExpansionWidget(
              initiallyExpanded: true,
              titleBuilder:
                  (double animationValue, _, bool isExpaned, toogleFunction) {
                return InkWell(
                    onTap: () => toogleFunction(animated: true),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: isExpaned ? 0 : 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Preparação',
                            style: TextStyle(
                                fontFamily: "CostaneraAltBold",
                                fontSize: fontSizeTitle),
                          ),
                          isExpaned
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: context
                                                  .theme.secondaryHeaderColor),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Icon(
                                        FontAwesomeIcons.minus,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        size: 15,
                                      )),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: context
                                                  .theme.secondaryHeaderColor),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Icon(
                                        FontAwesomeIcons.plus,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        size: 15,
                                      )),
                                ),
                        ],
                      ),
                    ));
              },
              content: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: listItems.map((prep) {
                      if (prep is PreparationItem) {
                        return Row(children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                prep.description,
                                style: TextStyle(
                                    fontFamily: "CostaneraAltBook",
                                    decoration: prep.isChecked
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationThickness: 2,
                                    decorationColor:
                                        Theme.of(context).dialogBackgroundColor,
                                    fontSize: fontSizeItem),
                              ),
                            ),
                          ),
                          Checkbox(
                            checkColor: Theme.of(context).secondaryHeaderColor,
                            fillColor: MaterialStateProperty.all(Colors.white),
                            side: MaterialStateBorderSide.resolveWith(
                              (states) => BorderSide(
                                  width: 1.0,
                                  color:
                                      Theme.of(context).dialogBackgroundColor),
                            ),
                            value: prep.isChecked,
                            onChanged: (bool? value) {
                              prep.isChecked = !prep.isChecked;
                              recipeInfosController.refreshListPreparation();
                            },
                          )
                        ]);
                      }
                      return ExpansionWidget(
                          initiallyExpanded: true,
                          expandedAlignment: Alignment.centerLeft,
                          titleBuilder: (double animationValue, _,
                              bool isExpaned, toogleFunction) {
                            return InkWell(
                                onTap: prep[1].isNotEmpty
                                    ? () => toogleFunction(animated: true)
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          prep[0].description,
                                          style: TextStyle(
                                              fontFamily: "CostaneraAltBold",
                                              fontSize: fontSizeSubTopic),
                                        ),
                                      ),
                                      prep[1].isNotEmpty
                                          ? isExpaned
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Theme.of(
                                                                      context)
                                                                  .secondaryHeaderColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      child: Icon(
                                                        FontAwesomeIcons.minus,
                                                        color: context.theme
                                                            .secondaryHeaderColor,
                                                        size: 13,
                                                      )),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Theme.of(
                                                                      context)
                                                                  .secondaryHeaderColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      child: Icon(
                                                        FontAwesomeIcons.plus,
                                                        color: context.theme
                                                            .secondaryHeaderColor,
                                                        size: 13,
                                                      )),
                                                )
                                          : Container(),
                                    ],
                                  ),
                                ));
                          },
                          content: Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: prep[1].map<Widget>((el) {
                                  return Row(children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          el.description.toString(),
                                          style: TextStyle(
                                              fontFamily: "CostaneraAltBook",
                                              decoration: el.isChecked
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                              decorationThickness: 2,
                                              decorationColor: context
                                                  .theme.secondaryHeaderColor,
                                              fontSize: fontSizeItem),
                                        ),
                                      ),
                                    ),
                                    Checkbox(
                                      checkColor: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fillColor: MaterialStateProperty.all(
                                          Colors.white),
                                      side: MaterialStateBorderSide.resolveWith(
                                        (states) => BorderSide(
                                            width: 1.0,
                                            color: Theme.of(context)
                                                .dialogBackgroundColor),
                                      ),
                                      value: el.isChecked,
                                      onChanged: (bool? value) {
                                        el.isChecked = !el.isChecked;
                                        recipeInfosController
                                            .refreshListPreparation();
                                      },
                                    )
                                  ]);
                                }).toList(),
                              )));
                    }).toList(),
                  ))),
        )
      ],
    );
  }
}
