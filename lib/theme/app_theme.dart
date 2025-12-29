import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

/// 应用主题配置
/// 符合 Material Design 3 和 iOS Human Interface Guidelines
class AppTheme {
  // ==================== Material Design Colors ====================
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color primaryVariant = Color(0xFF3700B3);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFB00020);

  // 功能色彩
  static const Color polishColor = Color(0xFF4CAF50); // 润色 - 绿色
  static const Color expandColor = Color(0xFF2196F3); // 扩写 - 蓝色
  static const Color continueColor = Color(0xFFFF9800); // 续写 - 橙色
  static const Color rewriteColor = Color(0xFF9C27B0); // 重写 - 紫色
  static const Color shortenColor = Color(0xFFF44336); // 缩写 - 红色

  // ==================== iOS Colors ====================
  static const Color iosSystemBlue = Color(0xFF007AFF);
  static const Color iosSystemGreen = Color(0xFF34C759);
  static const Color iosSystemIndigo = Color(0xFF5856D6);
  static const Color iosSystemBackground = Color(0xFFFFFFFF);
  static const Color iosSecondarySystemBackground = Color(0xFFF2F2F7);

  /// 根据模式获取功能颜色
  static Color getModeColor(String mode) {
    switch (mode) {
      case 'polish':
        return polishColor;
      case 'expand':
        return expandColor;
      case 'continue':
        return continueColor;
      case 'rewrite':
        return rewriteColor;
      case 'shorten':
        return shortenColor;
      default:
        return primaryColor;
    }
  }

  /// Material Design 3 主题
  static ThemeData get materialTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: surfaceColor,
        foregroundColor: Colors.black,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: surfaceColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25),
        displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
        displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
      ),
    );
  }

  /// iOS Cupertino 主题
  static CupertinoThemeData get cupertinoTheme {
    return const CupertinoThemeData(
      primaryColor: iosSystemBlue,
      scaffoldBackgroundColor: iosSecondarySystemBackground,
      barBackgroundColor: iosSystemBackground,
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(fontSize: 17, color: Colors.black),
        navTitleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        navLargeTitleTextStyle: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  /// 平台自适应主题
  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
}

