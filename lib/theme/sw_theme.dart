import 'package:flutter/material.dart';

//TODO move theme of widgets into the widget itself
class SWTheme {
  static const Color primaryColor = Color(0xffF6AE2D);
  static const Color backgroundColor = Color(0xff525390);
  static const Color textColor = Color(0xffFFFFFF);
  static const Color positiveColor = Color(0xff679436);
  static const Color negativeColor = Color(0xffD64550);

  static double notEnabledOpacity = 0.4;

  static ThemeData themeData = ThemeData(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    splashFactory: NoSplash.splashFactory,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: backgroundColor,
      secondary: primaryColor,
      onPrimary: textColor,
      onSecondary: textColor,
    ),
    textSelectionTheme:
        const TextSelectionThemeData(selectionColor: primaryColor),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
        shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.focused) ||
                states.contains(MaterialState.hovered)) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.white, width: 5),
              );
            }
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            );
          },
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      hintStyle: SWTheme.regularTextStyle
          .copyWith(color: SWTheme.textColor.withOpacity(0.4)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.amber, width: 4),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: SWTheme.textColor, width: 4),
        borderRadius: BorderRadius.circular(12),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: SWTheme.textColor.withOpacity(0.4), width: 4),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static TextStyle get regularTextStyle => const TextStyle(
        color: textColor,
        fontSize: 40,
        fontWeight: FontWeight.w400,
      );
}
