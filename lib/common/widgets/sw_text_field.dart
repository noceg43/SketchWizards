import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';

class SWTextField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onDone;
  final bool enabled;
  final int maxLength;
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;

  const SWTextField({
    super.key,
    required this.controller,
    required this.onDone,
    required this.enabled,
    this.maxLength = 20,
    required this.hintText,
    this.inputFormatters,
  });

  @override
  SWTextFieldState createState() => SWTextFieldState();
}

class SWTextFieldState extends State<SWTextField> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TextField(
        controller: widget.controller,
        onEditingComplete: widget.onDone,
        enabled: widget.enabled,
        maxLength: widget.maxLength,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          counterText: "",
          contentPadding: const EdgeInsets.all(20),
          hintText: widget.hintText,
          hintStyle: SWTheme.regularTextStyle.copyWith(
              color: SWTheme.textColor.withOpacity(SWTheme.notEnabledOpacity)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: _isHovered ? Colors.white : SWTheme.textColor, width: 4),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: _isHovered ? Colors.white : SWTheme.primaryColor,
                width: 4),
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
        inputFormatters: widget.inputFormatters,
        cursorColor: SWTheme.textColor,
        style: SWTheme.regularTextStyle,
      ),
    );
  }
}
