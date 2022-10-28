import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tudo_em_casa_receitas/model/infos_model.dart';
import 'package:tudo_em_casa_receitas/support/custom_icons_icons.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:get/utils.dart';

class InfosTile extends StatelessWidget {
  final Info infos;
  final double iconSize;
  final double fontSize;
  const InfosTile(
      {required this.infos, this.iconSize = 20, this.fontSize = 13, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
          child: Icon(
            FontAwesomeIcons.clock,
            color: Colors.lightBlue,
            size: iconSize,
          ),
        ),
        Text(
            infos.preparationTime == 0
                ? "- MIN"
                : "${infos.preparationTime} MIN",
            style: context.theme.textTheme.bodySmall!.copyWith(
              fontSize: fontSize,
            )),
        const Spacer(),
        Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
            child: Icon(
              CustomIcons.tray_svgrepo_com,
              size: iconSize,
              color: Colors.red,
            )),
        Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
          ),
          child: Text(
              infos.yieldRecipe == 0
                  ? "- PORÇÕES"
                  : "${infos.yieldRecipe} PORÇÕES",
              style: context.theme.textTheme.bodySmall!.copyWith(
                fontSize: fontSize,
              )

              /*TextStyle(
                  fontFamily: "CostaneraAltBook",
                  fontSize: fontSize,
                  color: CustomTheme.greyColor)*/
              ),
        ),
      ],
    );
  }
}
