import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomTextRecipeTile extends StatelessWidget {
  final String text;
  final bool required;
  final double fontSize;
  const CustomTextRecipeTile(
      {super.key,
      required this.text,
      this.fontSize = 18,
      this.required = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                text: text,
                style: TextStyle(
                    fontFamily: "CostaneraAltBold",
                    color: Colors.black,
                    fontSize: fontSize)),
            required
                ? TextSpan(
                    text: "*",
                    style: TextStyle(
                        fontFamily: "CostaneraAltBold",
                        color: Colors.red,
                        fontSize: fontSize))
                : TextSpan()
          ])),
    );
  }
}
