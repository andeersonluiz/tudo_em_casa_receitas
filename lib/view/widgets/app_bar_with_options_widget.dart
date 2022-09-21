import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../theme/textTheme_theme.dart';

class AppBarWithOptions extends StatelessWidget with PreferredSizeWidget {
  final String text;
  const AppBarWithOptions({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: CustomTheme.primaryColor,
        brightness: Brightness.dark,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: CustomTheme.thirdColor,
            )),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                customButton: const Icon(
                  FontAwesomeIcons.ellipsisVertical,
                  size: 24,
                  color: Colors.red,
                ),
                onChanged: (value) {
                  print(value);
                },
                items: ["Reportar problema"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                itemHeight: 48,
                itemPadding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                dropdownWidth: 160,
                dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                style: const TextStyle(
                    fontFamily: 'CostaneraAltBook',
                    fontSize: 15,
                    color: Colors.red),
                dropdownElevation: 8,
                offset: const Offset(0, 8),
              ),
            ),
          )
        ],
        title: Text(
          text,
          style: const TextStyle(
              color: Colors.red, fontFamily: 'CosanteraAltMedium'),
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
