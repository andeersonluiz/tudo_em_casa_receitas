import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

class AppBarCustom extends StatelessWidget with PreferredSizeWidget {
  const AppBarCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Brightness.dark,
      backgroundColor: CustomTheme.primaryColor,
      actions: [
        Builder(builder: (context) {
          return IconButton(
            icon: const GFAvatar(
              backgroundImage: AssetImage(
                "assets/anom_avatar.png",
              ),
            ),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          );
        }),
      ],
      centerTitle: false,
      title: Image.asset(
        "assets/logo_text.png",
        height: AppBar().preferredSize.height * 0.6,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
