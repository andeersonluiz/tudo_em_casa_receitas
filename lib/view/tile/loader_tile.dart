import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:get/utils.dart';

class LoaderTile extends StatelessWidget {
  final double size;
  final Color color;
  const LoaderTile(
      {this.size = GFSize.MEDIUM,
      this.color = CustomTheme.thirdColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GFLoader(
      size: size,
      androidLoaderColor: AlwaysStoppedAnimation<Color>(
          color == CustomTheme.thirdColor
              ? context.theme.indicatorColor
              : color),
    );
  }
}
