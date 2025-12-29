/// 写作模式枚举
enum WriteMode {
  polish('polish', '润色', '✨', '改善语法、语气、专业度'),
  expand('expand', '扩写', '📈', '让内容更详细、更丰富'),
  continueWrite('continue', '续写', '🔁', '基于当前内容继续写'),
  rewrite('rewrite', '重写', '🔄', '用不同表达方式重写'),
  shorten('shorten', '缩写', '✂️', '精简、提炼重点');

  final String value;
  final String label;
  final String icon;
  final String description;

  const WriteMode(this.value, this.label, this.icon, this.description);

  /// 根据值获取模式
  static WriteMode? fromValue(String value) {
    return WriteMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => WriteMode.polish,
    );
  }
}


