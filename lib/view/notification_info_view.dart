import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/view/widgets/app_bar_text_widget.dart';

class NotificationInfoView extends StatelessWidget {
  const NotificationInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBarWithText(
        onPressed: () {
          Get.back();
        },
        text: Get.arguments["title"],
        showDrawer: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          Get.arguments["body"],
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    ));
  }
}
