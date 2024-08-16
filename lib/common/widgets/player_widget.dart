import 'package:flutter/material.dart';
import 'package:sketch_wizards/common/widgets/sw_icon_button.dart';
import 'package:sketch_wizards/constants/sw_theme.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key, required this.text, this.onDelete});
  final String text;
  final VoidCallback? onDelete;
  @override
  Widget build(BuildContext context) {
    Widget playerWidget = SizedBox(
      width: 320,
      height: 120,
      child: Container(
        decoration: BoxDecoration(
          color: SWTheme.textColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Center(
          child: Text(
            text,
            style:
                SWTheme.regularTextStyle.copyWith(color: SWTheme.primaryColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

    if (onDelete == null) return playerWidget;

    return SizedBox(
      width: 350,
      height: 140,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: playerWidget,
          ),
          if (onDelete != null)
            Align(
              alignment: Alignment.topRight,
              child: SWIconButton(
                icon: Icons.close,
                enabled: true,
                smallIcon: true,
                backgroundColor: SWTheme.negativeColor,
                onPressed: onDelete,
              ),
            ),
        ],
      ),
    );
  }
}
