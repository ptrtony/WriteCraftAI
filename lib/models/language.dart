import 'package:flutter/material.dart';

/// 语言枚举
enum Language {
  zh('zh', '中文', Icons.translate),
  en('en', 'English', Icons.language);

  final String code;
  final String label;
  final IconData icon;

  const Language(this.code, this.label, this.icon);

  /// 根据 code 获取语言
  static Language? fromCode(String code) {
    return Language.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => Language.zh,
    );
  }
}

