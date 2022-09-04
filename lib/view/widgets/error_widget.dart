import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

class CustomErrorWidget extends StatelessWidget {
  final String text;
  const CustomErrorWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Ionicons.sad_outline, size: 90, color: CustomTheme.thirdColor),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: CustomTheme.data.textTheme.bodyText1!.copyWith(fontSize: 16),
        ),
      )
    ]);
  }
}
