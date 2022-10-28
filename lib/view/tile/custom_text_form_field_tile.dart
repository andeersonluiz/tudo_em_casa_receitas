import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:tudo_em_casa_receitas/theme/textTheme_theme.dart';

class CustomTextFormFieldTile extends StatelessWidget {
  final String? hintText;
  final String labelText;
  final IconData? icon;
  final TextEditingController? textEditingController;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool obscureText;
  final IconData? iconSufix;
  final void Function()? onChangedSufix;
  final TextInputAction? textInputAction;
  final EdgeInsets padding;
  final String? initialValue;
  final bool autofocus;
  final TextAlign textAlign;
  final AutovalidateMode? autovalidateMode;
  final int? minLines;
  final int? maxLines;
  final EdgeInsets contentPadding;
  const CustomTextFormFieldTile(
      {required this.hintText,
      required this.labelText,
      this.icon,
      required this.keyboardType,
      required this.validator,
      required this.onChanged,
      this.obscureText = false,
      this.textInputAction,
      this.textEditingController,
      this.padding =
          const EdgeInsets.symmetric(horizontal: 33.0, vertical: 8.0),
      this.initialValue,
      this.autofocus = false,
      this.textAlign = TextAlign.start,
      this.onChangedSufix,
      this.iconSufix,
      this.maxLines,
      this.minLines,
      this.contentPadding = const EdgeInsets.symmetric(horizontal: 12.0),
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        autofocus: autofocus,
        autovalidateMode: autovalidateMode,
        initialValue: initialValue,
        validator: validator,
        controller: textEditingController,
        textInputAction: textInputAction,
        onChanged: onChanged,
        textAlign: textAlign,
        minLines: minLines,
        maxLines: maxLines,
        cursorColor: context.theme.splashColor,
        style: context.theme.textTheme.headline5!.copyWith(fontSize: 16),
        obscureText: obscureText,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 13),
            label: Text(labelText),
            contentPadding: contentPadding,
            labelStyle: const TextStyle(color: CustomTheme.greyColor),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: context.theme.splashColor, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            suffixIcon: iconSufix == null
                ? null
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0),
                    child: GestureDetector(
                      onTap: onChangedSufix,
                      child: Icon(
                        iconSufix,
                        size: 17,
                        color: context.theme.splashColor,
                      ),
                    ),
                  ),
            prefixIcon: icon == null
                ? null
                : Icon(
                    icon,
                    color: context.theme.splashColor,
                  )),
        keyboardType: keyboardType,
      ),
    );
  }
}
