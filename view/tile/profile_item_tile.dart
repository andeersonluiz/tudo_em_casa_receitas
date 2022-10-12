import 'package:flutter/material.dart';

class ProfileItemTile extends StatelessWidget {
  final String title;
  final int value;
  const ProfileItemTile({required this.title, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(fontFamily: "CostaneraAltBold", fontSize: 25),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "CostaneraAltMedium", fontSize: 20),
        ),
      ],
    );
  }
}
