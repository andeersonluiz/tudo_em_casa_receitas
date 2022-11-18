import 'package:flutter/material.dart';

class ErrorTextTile extends StatelessWidget {
  final String text;
  const ErrorTextTile({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontFamily: "CostaneraAltBook",
            fontSize: 12,
            color: Theme.of(context).secondaryHeaderColor));
  }
}
