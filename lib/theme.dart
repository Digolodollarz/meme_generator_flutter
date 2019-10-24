import 'package:flutter/material.dart';

ThemeData getAppTheme({ThemeColor color = ThemeColor.Dark}) {
  if (color == ThemeColor.Dark) {
    return _getDarkAppTheme();
  } else if (color == ThemeColor.Black) {
    return _getBlackAppTheme();
  } else if (color == ThemeColor.Red) {
    return _getRedAppTheme();
  } else if (color == ThemeColor.Blue) {
    return _getDarkBlueTheme();
  } else
    return _getRedAppTheme();
}

enum ThemeColor { Dark, Black, Red, Blue }

_getDarkAppTheme() {
  ThemeData _base = ThemeData.dark();

  return _base.copyWith(primaryColor: Colors.red);
}

_getRedAppTheme() {
  ThemeData _base = ThemeData.light();

  return _base.copyWith();
}

_getDarkBlueTheme() {
  ThemeData _base = ThemeData.light();

  return _base.copyWith();
}

_getBlackAppTheme() {
  ThemeData _base = ThemeData.dark();

  return _base.copyWith();
}
