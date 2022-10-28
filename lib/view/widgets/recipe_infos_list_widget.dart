import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/controller/recipe_infos_controller.dart';
import 'dart:math' as math;

import 'package:tudo_em_casa_receitas/model/ingredient_item.dart';

class RecipeInfosListWidget extends StatelessWidget {
  final List listItems;
  RecipeInfosListWidget({required this.listItems, Key? key}) : super(key: key);
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
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: isExpaned ? 0 : 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Ingredientes',
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
                                        color:
                                            context.theme.secondaryHeaderColor,
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
                                        color:
                                            context.theme.secondaryHeaderColor,
                                        size: 15,
                                      )),
                                ),
                        ],
                      ),
                    ));
              },
              content: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: listItems.map((ing) {
                      print(ing);
                      if (ing is IngredientItem) {
                        return Row(children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                ing.toString(),
                                style: TextStyle(
                                    fontFamily: "CostaneraAltBook",
                                    decoration: ing.isChecked
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationThickness: 2,
                                    decorationColor:
                                        context.theme.secondaryHeaderColor,
                                    fontSize: fontSizeItem),
                              ),
                            ),
                          ),
                          Checkbox(
                            checkColor: context.theme.secondaryHeaderColor,
                            fillColor: MaterialStateProperty.all(Colors.white),
                            side: MaterialStateBorderSide.resolveWith(
                              (states) => BorderSide(
                                  width: 1.0, color: context.theme.splashColor),
                            ),
                            value: ing.isChecked,
                            onChanged: (bool? value) {
                              ing.isChecked = !ing.isChecked;
                              recipeInfosController.refreshList();
                            },
                          )
                        ]);
                      } else if (ing is List<IngredientItem>) {
                        print('fuuff $ing');
                        return Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  ing.join(" ou "),
                                  style: TextStyle(
                                      fontFamily: "CostaneraAltBook",
                                      decoration: ing.every(
                                              (element) => element.isChecked)
                                          ? TextDecoration.lineThrough
                                          : null,
                                      decorationThickness: 2,
                                      decorationColor:
                                          context.theme.secondaryHeaderColor,
                                      fontSize: fontSizeItem),
                                ),
                              ),
                            ),
                            Checkbox(
                              checkColor: context.theme.secondaryHeaderColor,
                              fillColor:
                                  MaterialStateProperty.all(Colors.white),
                              side: MaterialStateBorderSide.resolveWith(
                                (states) => BorderSide(
                                    width: 1.0,
                                    color: context.theme.splashColor),
                              ),
                              value: ing.every((element) => element.isChecked),
                              onChanged: (bool? value) {
                                for (var element in ing) {
                                  element.isChecked = !element.isChecked;
                                }
                                recipeInfosController.refreshList();
                              },
                            )
                          ],
                        );
                      }
                      return ExpansionWidget(
                          initiallyExpanded: true,
                          expandedAlignment: Alignment.centerLeft,
                          titleBuilder: (double animationValue, _,
                              bool isExpaned, toogleFunction) {
                            return InkWell(
                                onTap: ing[1].isNotEmpty
                                    ? () => toogleFunction(animated: true)
                                    : null,
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          ing[0].name,
                                          style: TextStyle(
                                              fontFamily: "CostaneraAltBold",
                                              fontSize: fontSizeSubTopic),
                                        ),
                                      ),
                                      ing[1].isNotEmpty
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
                                                        size: 10,
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
                                                        size: 10,
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
                                children: ing[1].map<Widget>((el) {
                                  if (el is IngredientItem) {
                                    return Row(children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                            el.toString(),
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
                                        checkColor:
                                            context.theme.secondaryHeaderColor,
                                        fillColor: MaterialStateProperty.all(
                                            Colors.white),
                                        side:
                                            MaterialStateBorderSide.resolveWith(
                                          (states) => BorderSide(
                                              width: 1.0,
                                              color: context.theme.splashColor),
                                        ),
                                        value: el.isChecked,
                                        onChanged: (bool? value) {
                                          el.isChecked = !el.isChecked;
                                          recipeInfosController.refreshList();
                                        },
                                      )
                                    ]);
                                  }
                                  var isChecked = List<IngredientItem>.from(el)
                                      .every((item) => item.isChecked);
                                  return Row(children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          el.join(" ou "),
                                          style: TextStyle(
                                              fontFamily: "CostaneraAltBook",
                                              decoration: isChecked
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
                                      checkColor:
                                          context.theme.secondaryHeaderColor,
                                      fillColor: MaterialStateProperty.all(
                                          Colors.white),
                                      side: MaterialStateBorderSide.resolveWith(
                                        (states) => BorderSide(
                                            width: 1.0,
                                            color: context.theme.splashColor),
                                      ),
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        for (var element in el) {
                                          element.isChecked =
                                              !element.isChecked;
                                        }
                                        recipeInfosController.refreshList();
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
