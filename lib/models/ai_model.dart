import 'package:flutter/material.dart';

/// AI 模型枚举
enum AIModel {
  auto('auto', 'Auto', Icons.auto_awesome),
  openai('openai', 'OpenAI', Icons.smart_toy),
  deepseek('deepseek', 'DeepSeek', Icons.psychology);

  final String value;
  final String label;
  final IconData icon;

  const AIModel(this.value, this.label, this.icon);

  /// 根据值获取模型
  static AIModel? fromValue(String value) {
    return AIModel.values.firstWhere(
      (model) => model.value == value,
      orElse: () => AIModel.auto,
    );
  }
}

