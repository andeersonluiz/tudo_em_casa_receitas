import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class BottomNavigatorRecipeWidget extends StatelessWidget {
  final String textSend;
  final void Function()? onPressedSend;
  final void Function()? onPressedPreview;
  final bool isLoading;
  const BottomNavigatorRecipeWidget(
      {required this.textSend,
      required this.onPressedSend,
      required this.onPressedPreview,
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
                      child: TextButton(
                    onPressed: onPressedPreview,
                    child: const ListTile(
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
                  )),
                  Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: const VerticalDivider(
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
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "CostaneraAltBold"),
                            maxLines: 1),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
                ]
              : [
                  const Expanded(
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
