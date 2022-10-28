import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

class CustomErrorWidget extends StatelessWidget {
  final String text;
  final Future<void> Function() onRefresh;
  const CustomErrorWidget(this.text, {required this.onRefresh, super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: context.theme.secondaryHeaderColor,
      child: CustomScrollView(slivers: [
        SliverFillRemaining(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Ionicons.sad_outline,
                  size: 90, color: context.theme.secondaryHeaderColor),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(text,
                    style: TextStyle(
                        fontFamily: "CostaneraAltBook", fontSize: 15)),
              )
            ],
          ),
        )
      ]),
    );
  }
}
