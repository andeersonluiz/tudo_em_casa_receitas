import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/utils.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final bool isToogle;
  final bool valueToogle;
  final void Function()? onTap;
  final void Function(bool)? onToggle;
  const SettingsTile(
      {required this.isToogle,
      required this.title,
      this.valueToogle = false,
      this.onToggle,
      this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return isToogle
        ? Row(
            children: [
              Expanded(
                child: ListTile(
                  onTap: onTap,
                  title: Text(title,
                      style: context.theme.textTheme.titleMedium!
                          .copyWith(fontSize: 20)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FlutterSwitch(
                  value: valueToogle,
                  onToggle: onToggle!,
                ),
              ),
            ],
          )
        : ListTile(
            onTap: onTap,
            title: Text(title,
                style: context.theme.textTheme.titleMedium!
                    .copyWith(fontSize: 20)),
          );
  }
}
