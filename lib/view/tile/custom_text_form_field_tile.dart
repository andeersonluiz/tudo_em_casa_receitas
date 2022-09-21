import 'package:flutter/material.dart';
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
        obscureText: obscureText,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 13),
            label: Text(labelText),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            labelStyle: const TextStyle(color: CustomTheme.greyColor),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: CustomTheme.thirdColor, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            suffixIcon: iconSufix == null
                ? null
                : IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    onPressed: onChangedSufix,
                    icon: Icon(
                      iconSufix,
                      size: 17,
                      color: CustomTheme.thirdColor,
                    ),
                  ),
            prefixIcon: icon == null
                ? null
                : Icon(
                    icon,
                    color: CustomTheme.thirdColor,
                  )),
        keyboardType: keyboardType,
      ),
    );
  }
}
