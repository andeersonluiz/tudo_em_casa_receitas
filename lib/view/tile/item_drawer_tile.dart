import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class ItemDrawer extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()? onTap;
  const ItemDrawer(
      {required this.text, required this.icon, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        textAlign: TextAlign.right,
        style: context.theme.textTheme.titleMedium!.copyWith(
          fontSize: 18,
        ),
      ),
      trailing: Icon(
        icon,
        color: context.theme.textTheme.titleMedium!.color!,
      ),
      onTap: onTap,
    );
  }
}
