import 'package:flutter/material.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';

class SWIconButton extends StatelessWidget {
  const SWIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.enabled = true,
    this.smallIcon = false,
    this.backgroundColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool smallIcon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: smallIcon ? 50 : 100,
      width: smallIcon ? 50 : 100,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: enabled ? 1 : SWTheme.notEnabledOpacity,
        child: TextButton(
          onPressed: enabled ? onPressed : null,
          style: ButtonStyle(
              shape: MaterialStateProperty.resolveWith<CircleBorder>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.hovered)) {
                    return const CircleBorder(
                      side: BorderSide(color: Colors.white, width: 5),
                    );
                  }
                  return const CircleBorder();
                },
              ),
              backgroundColor: MaterialStateProperty.all<Color?>(
                backgroundColor,
              )),
          child: FittedBox(
            child: Icon(
              icon,
              size: smallIcon ? 35 : 70,
              color: SWTheme.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
