import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            child: GFButton(
                onPressed: () {
                  Get.toNamed(Routes.SEARCH_INGREDIENT);
                },
                color: CustomTheme.thirdColor,
                blockButton: true,
                shape: GFButtonShape.pills,
                size: GFSize.LARGE,
                child: Text('Achar Receitas',
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: Colors.white, fontSize: 16)))),
        //Divider(),
        const Text("Receitas em alta"),
      ],
    );
  }
}
