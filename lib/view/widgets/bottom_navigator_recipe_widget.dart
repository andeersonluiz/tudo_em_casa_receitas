import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

class BottomNavigatorRecipeWidget extends StatelessWidget {
  final String textSend;
  final void Function()? onPressedSend;
  final bool isLoading;
  const BottomNavigatorRecipeWidget(
      {required this.textSend,
      required this.onPressedSend,
      required this.isLoading,
      super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 70,
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: !isLoading
              ? [
                  Expanded(
                      child: Container(
                    child: TextButton(
                      onPressed: () {},
                      child: ListTile(
                        title: Text(
                          "Pré visualizar",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "CostaneraAltBold"),
                        ),
                        trailing: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
                  Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: VerticalDivider(
                      thickness: 1,
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                      child: Container(
                    color: Colors.red,
                    child: TextButton(
                      onPressed: onPressedSend,
                      child: ListTile(
                        title: AutoSizeText(textSend,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "CostaneraAltBold"),
                            maxLines: 1),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
                ]
              : [
                  Expanded(
                      child: GFLoader(
                    size: GFSize.LARGE,
                    androidLoaderColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                  ))
                ],
        ),
      ),
    );
  }
}
