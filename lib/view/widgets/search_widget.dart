import 'package:flutter/material.dart';
import 'package:fsearch/fsearch.dart';

import '../../theme/textTheme_theme.dart';

class SearchWidget extends StatelessWidget {
  final FSearchController controller;
  final String hint;
  final Function(String) onSearch;
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
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: 17,
            ),
      ),
      suffixes: onClear != null
          ? [
              IconButton(
                splashColor: Colors.transparent,
                onPressed: onClear,
                icon: const Icon(Icons.clear),
              )
            ]
          : [],
      center: center,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(),
      corner: FSearchCorner.all(16),
      backgroundColor: CustomTheme.greyAccent.withOpacity(0.5),
      onSearch: onSearch,
    );
  }
}
