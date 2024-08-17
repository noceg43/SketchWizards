import 'package:flutter/material.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';

class SWTextButton extends StatelessWidget {
  const SWTextButton(
      {super.key, required this.text, this.onPressed, this.enabled = true});

  final String text;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: enabled ? 1 : SWTheme.notEnabledOpacity,
      child: TextButton(
        onPressed: enabled ? onPressed : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
          child: FittedBox(
            child: Text(text, style: SWTheme.regularTextStyle),
          ),
        ),
      ),
    );
  }
}
