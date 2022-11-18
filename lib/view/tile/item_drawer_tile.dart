import 'package:flutter/material.dart';

class ItemDrawer extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function() onTap;
  const ItemDrawer(
      {required this.text, required this.icon, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 18,
            ),
      ),
      trailing: Icon(
        icon,
        color: Theme.of(context).textTheme.titleMedium!.color!,
      ),
      onTap: onTap,
    );
  }
}
