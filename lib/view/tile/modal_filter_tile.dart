import 'package:flutter/material.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';
import 'package:tuple/tuple.dart';

class ModalFilterTile extends StatelessWidget {
  final Tuple3 tuple;
  final String typeFilter;
  final bool isSelected;
  const ModalFilterTile(
      {super.key,
      required this.tuple,
      required this.typeFilter,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isSelected
              ? CustomTheme.thirdColor.withOpacity(0.9)
              : CustomTheme.greyAccent,
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "${tuple.item3} ${tuple.item1} ${typeFilter.toLowerCase()}",
          style: TextStyle(
            fontFamily: "CostaneraAltBook",
            color: isSelected ? CustomTheme.greyAccent : CustomTheme.greyColor,
          ),
        ),
      ),
    );
  }
}
