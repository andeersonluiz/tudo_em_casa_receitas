import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CustomErrorWidget extends StatelessWidget {
  final String text;
  final Future<void> Function() onRefresh;
  const CustomErrorWidget(this.text, {required this.onRefresh, super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Theme.of(context).secondaryHeaderColor,
      child: CustomScrollView(slivers: [
        SliverFillRemaining(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Ionicons.sad_outline,
                  size: 90, color: Theme.of(context).secondaryHeaderColor),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(text,
                    style: const TextStyle(
                        fontFamily: "CostaneraAltBook", fontSize: 15)),
              )
            ],
          ),
        )
      ]),
    );
  }
}
