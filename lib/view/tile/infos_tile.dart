import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tudo_em_casa_receitas/model/infos_model.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

class InfosTile extends StatelessWidget {
  final Info infos;
  const InfosTile({required this.infos, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
          child: Icon(
            FontAwesomeIcons.clock,
            color: Colors.lightBlue,
            size: 20,
          ),
        ),
        Text(infos.preparationTime == "0 MIN" ? "-" : infos.preparationTime,
            style: const TextStyle(
                fontFamily: "CostaneraAltBook",
                fontSize: 13,
                color: CustomTheme.greyColor)),
        const Spacer(),
        Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
            child: Image.asset(
              "assets/food-tray.png",
              width: 20,
              height: 20,
            )),
        Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
          ),
          child: Text(infos.yield == "0 PORÇÕES" ? "-" : infos.yield,
              style: const TextStyle(
                  fontFamily: "CostaneraAltBook",
                  fontSize: 13,
                  color: CustomTheme.greyColor)),
        ),
      ],
    );
  }
}
