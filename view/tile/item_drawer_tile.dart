import 'package:flutter/material.dart';

class ItemDrawer extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()? onTap;
  final bool isSelected;
  const ItemDrawer(
      {required this.text,
      required this.icon,
      required this.onTap,
      this.isSelected = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isSelected ? Colors.red[300] : null,
      title: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
            fontFamily: "CostaneraAltMedium",
            fontSize: 18,
            color: isSelected ? Colors.white : Colors.black),
      ),
      trailing: Icon(icon, color: isSelected ? Colors.white : Colors.black),
      onTap: onTap,
    );
  }
}
