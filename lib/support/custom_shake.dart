import 'dart:ui';

import 'package:flutter_shake_animated/flutter_shake_animated.dart';

class CustomShake implements ShakeConstant {
  double offSetX;
  CustomShake({required this.offSetX});
  double offsetY = 1.5;
  @override
  List<int> get interval => [2];

  @override
  List<double> get opacity => const [];

  @override
  List<double> get rotate => const [];

  @override
  List<Offset> get translate => [
        Offset(offSetX + 0, offsetY),
        Offset(offSetX + 3, offsetY),
        Offset(offSetX - 5, offsetY),
        Offset(offSetX - 4, offsetY),
        Offset(offSetX - 3, offsetY),
        Offset(offSetX + 0, offsetY),
        Offset(offSetX - 5, offsetY),
        Offset(offSetX - 4, offsetY),
        Offset(offSetX - 4, offsetY),
        Offset(offSetX + 5, offsetY),
        Offset(offSetX - 3, offsetY),
        Offset(offSetX + 5, offsetY),
        Offset(offSetX + 5, offsetY),
        Offset(offSetX - 1, offsetY),
        Offset(offSetX - 5, offsetY),
        Offset(offSetX + 4, offsetY),
        Offset(offSetX - 5, offsetY),
        Offset(offSetX + 2, offsetY),
        Offset(offSetX - 3, offsetY),
        Offset(offSetX - 4, offsetY),
        Offset(offSetX - 1, offsetY),
        Offset(offSetX + 3, offsetY),
        Offset(offSetX + 2, offsetY),
        Offset(offSetX + 5, offsetY),
      ];

  @override
  Duration get duration => const Duration(milliseconds: 50);
}
