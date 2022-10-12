import 'package:flutter/material.dart';
import 'package:fsearch/fsearch.dart';

import '../../theme/textTheme_theme.dart';

class SearchWidget extends StatelessWidget {
  final FSearchController controller;
  final String hint;
  final Function(String)? onSearch;
  final bool center;
  final Function()? onClear;
  final EdgeInsets padding;

  const SearchWidget({
    required this.controller,
    required this.hint,
    required this.onSearch,
    this.center = true,
    this.onClear,
    this.padding = EdgeInsets.zero,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FSearch(
      height: 40,
      controller: controller,
      hints: [hint],
      padding: padding,
      hintPrefix: Text(
        hint,
        style: const TextStyle(
            fontFamily: 'CostaneraAltBook',
            fontSize: 17,
            color: Colors.black38),
      ),
      suffixes: onClear != null
          ? [
              IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.clear),
              )
            ]
          : [],
      center: center,
      style:
          const TextStyle(fontFamily: 'CostaneraAltBook', color: Colors.black),
      corner: FSearchCorner.all(16),
      backgroundColor: CustomTheme.greyAccent.withOpacity(0.5),
      onSearch: onSearch,
    );
  }
}
