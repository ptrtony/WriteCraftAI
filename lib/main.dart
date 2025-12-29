import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:write_craft_ai/theme/app_theme.dart';
import 'package:write_craft_ai/pages/main_page.dart';

void main() {
  runApp(const WriteCraftApp());
}

/// WriteCraft AI 应用入口
/// 支持 Material Design (Android) 和 Cupertino (iOS) 双主题
class WriteCraftApp extends StatelessWidget {
  const WriteCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (AppTheme.isIOS) {
      return CupertinoApp(
        title: 'WriteCraft AI',
        theme: AppTheme.cupertinoTheme,
        home: const MainPage(),
        debugShowCheckedModeBanner: false,
      );
    } else {
      return MaterialApp(
        title: 'WriteCraft AI',
        theme: AppTheme.materialTheme,
        home: const MainPage(),
        debugShowCheckedModeBanner: false,
      );
    }
  }
}
