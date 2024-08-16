import 'package:flutter/material.dart';
import 'package:sketch_wizards/constants/sw_theme.dart';

class SWTextField extends StatelessWidget {
  const SWTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.enabled = true,
    this.onDone,
  });

  final TextEditingController controller;
  final String? hintText;
  final bool enabled;
  final VoidCallback? onDone;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onEditingComplete: onDone,
      enabled: enabled,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        hintStyle: SWTheme.regularTextStyle.copyWith(
            color: SWTheme.textColor.withOpacity(SWTheme.notEnabledOpacity)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber, width: 4),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: SWTheme.textColor, width: 4),
          borderRadius: BorderRadius.circular(12),
        ),
        enabled: true,
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: SWTheme.textColor.withOpacity(SWTheme.notEnabledOpacity),
              width: 4),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      cursorColor: SWTheme.textColor,
      style: SWTheme.regularTextStyle,
    );
  }
}
