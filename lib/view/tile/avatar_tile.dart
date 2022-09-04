import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';

class AvatarTile extends StatelessWidget {
  final ImageProvider<Object> backgroundImage;
  final double size;
  final Alignment alignment;
  const AvatarTile(
      {required this.backgroundImage,
      required this.size,
      required this.alignment,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Align(
        alignment: alignment,
        child: GFAvatar(size: size, backgroundImage: backgroundImage),
      ),
    );
  }
}
