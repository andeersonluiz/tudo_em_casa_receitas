import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageControl extends GetxController {
  final controller = PageController();

  var index = 0.obs;

  updateIndex(value) {
    index.value = value;
  }

  updateIndexWithAnimation(value) {
    index.value = value;
    controller.animateToPage(index.value,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void onClose() {
    super.onClose();

    controller.dispose();
  }
}
