import 'package:flutter/material.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

class ErrorTextTile extends StatelessWidget {
  final String text;
  const ErrorTextTile({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontFamily: "CostaneraAltBook",
            fontSize: 12,
            color: CustomTheme.thirdColor));
  }
}
