import 'package:flutter/material.dart';

class SignInTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final void Function()? onPressed;
  const SignInTile(
      {required this.icon,
      required this.color,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Colors.white,
            )),
      ),
    );
  }
}
