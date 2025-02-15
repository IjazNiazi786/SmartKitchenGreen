import 'package:flutter/material.dart';

String _appTheme = "primary";

/// Helper class for managing themes and colors.
class ThemeHelper {
  // A map of custom color themes supported by the app
  Map<String, PrimaryColors> _supportedCustomColor = {
    'primary': PrimaryColors()
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'primary': ColorSchemes.primaryColorScheme
  };

  /// Changes the app theme to [_newTheme].
  void changeTheme(String _newTheme) {
    _appTheme = _newTheme;
  }

  /// Returns the primary colors for the current theme.
  PrimaryColors _getThemeColors() {
    // throw exception to notify given theme is not found or not generated by the generator
    if (!_supportedCustomColor.containsKey(_appTheme)) {
      throw Exception(
          "$_appTheme is not found. Make sure you have added this theme class in JSON. Try running flutter pub run build_runner");
    }
    // return theme from map

    return _supportedCustomColor[_appTheme] ?? PrimaryColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    // throw exception to notify given theme is not found or not generated by the generator
    if (!_supportedColorScheme.containsKey(_appTheme)) {
      throw Exception(
          "$_appTheme is not found. Make sure you have added this theme class in JSON. Try running flutter pub run build_runner");
    }
    // return theme from map

    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.primaryColorScheme;
    return ThemeData(
      //------------------TEXTFORMFIELD THEME--------------------------------------//////
      inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.green),
          filled: true,
          fillColor: Colors.white.withOpacity(0.4),
          hintStyle: TextStyle(color: Colors.green),
          suffixIconColor: Colors.green[700]!,
          prefixIconColor: Colors.green[700]!,
          iconColor: Colors.green[700]!,
          errorStyle: TextStyle(color: Colors.red),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                  color: const Color.fromARGB(255, 142, 56, 56)!, width: 1)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: Colors.green[700]!, width: 1))),

      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.green[700],
        // Replace this with the extracted color
        iconTheme: IconThemeData(color: Colors.white), // Icon color
        titleTextStyle: TextStyle(
          color: Colors.white, // Title text color
          fontSize: 20.0,
          fontFamily: 'Inria Serif',
          fontWeight: FontWeight.w400,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: appTheme.black900.withOpacity(0.5),
          backgroundColor: PrimaryColors().gray50,
          textStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          elevation: 4,
          fixedSize: Size(250, 50),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: colorScheme.onPrimaryContainer,
      ),
    );
  }

  /// Returns the primary colors for the current theme.
  PrimaryColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 16,
          fontFamily: 'Inria Serif',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: appTheme.gray600,
          fontSize: 15,
          fontFamily: 'Inria Serif',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: appTheme.black900,
          fontSize: 12,
          fontFamily: 'Inria Serif',
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          color: appTheme.black900,
          fontSize: 34,
          fontFamily: 'Inria Serif',
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 30,
          fontFamily: 'Inria Serif',
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontSize: 28,
          fontFamily: 'Inria Serif',
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: TextStyle(
          color: appTheme.black900,
          fontSize: 25,
          fontFamily: 'Inria Serif',
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 12,
          fontFamily: 'Inria Serif',
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 20,
          fontFamily: 'Inria Serif',
          fontWeight: FontWeight.w400,
        ),
        titleSmall: TextStyle(
          color: appTheme.black900,
          fontSize: 15,
          fontFamily: 'Inria Serif',
          fontWeight: FontWeight.w700,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final primaryColorScheme = ColorScheme.light(
    // Primary colors
    primary: Color(0xFF4CAF50), // Green color
    primaryContainer: Color(0xFF388E3C), // Darker green
    secondary: Color(0xFF8BC34A), // Light green
    secondaryContainer: Color(0xFF689F38), // Darker light green

    // On colors (text colors)
    onPrimary: Colors.white, // Text color on primary
    onSecondary: Colors.black, // Text color on secondary
    onSurface: Colors.black, // Text color on surface
    onBackground: Colors.white, // Text color on background
    onError: Colors.white, // Text color on error
    brightness: Brightness.light, // Light theme

    surface: Color(0xFFFFFFFF), // White surface
    background: Color(0xFF2E7D32), // Background green
    error: Color(0xFFD32F2F), // Red for error
  );
}

/// Class containing custom colors for a primary theme.
class PrimaryColors {
  // Black
  Color get black900 => Color(0XFF000000);

  // Blue
  Color get blue900 => Color(0XFF194F82);

  // BlueGray
  Color get blueGray100 => Color(0XFFD9D9D9);
  Color get blueGray400 => Color(0XFF7A9894);
  Color get blueGray50035 => Color(0X35529C94);
  Color get blueGray60068 => Color(0X685F7774);

  // BlueGrayC
  Color get blueGray500C6 => Color(0XC65A9C94);

  // Cyan
  Color get cyan300 => Color(0XFF55D1C3);
  Color get cyanA200 => Color(0XFF00FFFF);

  // Gray
  Color get gray100 => Color(0XFFF5F5F5);
  Color get gray10001 => Color(0XFFF4F4F4);
  Color get gray300 => Color(0XFFE6E6E6);
  Color get gray50 => Color(0XFFFCFCFC);
  Color get gray600 => Color(0XFF737373);
  Color get gray60001 => Color(0XFF797979);
  Color get gray700 => Color(0XFF545454);
  Color get gray800 => Color(0XFF514C4C);

  // Teal
  Color get teal200 => Color(0XFF83C9C1);
  Color get teal20001 => Color(0XFF84C9C1);
  Color get teal50 => Color(0XFFE0FAF2);

  // Yellow
  Color get yellow800 => Color(0XFFFA961E);
}

PrimaryColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();
