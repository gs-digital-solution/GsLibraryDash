import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color primaryColor = "#02b2e4".toColor();
Color backgroundColor = "#F8F8F8".toColor();
Color cardColor = "#FFFFFF".toColor();
Color borderColor = "#DBDBDB".toColor();
Color textColor = "#000000".toColor();
Color primaryFontColor = "#4B4B4B".toColor();
Color subTextColor = "#7A7A7A".toColor();
Color alphaColor = "#FFF1EE".toColor();
Color darkCardColor = "#131416".toColor();
Color darkSubCardColor = "#1D2123".toColor();
Color darkBackgroundColor = "#080A0B".toColor();
Color darkBorderColor = "#9A9A9A".toColor();
Color subPrimaryTextColor = "#727787".toColor();

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class AppTheme {
  static ThemeData get theme {
    ThemeData base = ThemeData.light();

    return base.copyWith(
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        surface: backgroundColor,
      ),
      brightness: Brightness.light,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }

  static ThemeData get darkTheme {
    ThemeData base = ThemeData.dark();

    return base.copyWith(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      primaryColor: primaryColor,
      highlightColor: Colors.transparent,
      scaffoldBackgroundColor: darkBackgroundColor,
      cardColor: darkCardColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        surface: darkBackgroundColor,
      ),
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
    );
  }
}
