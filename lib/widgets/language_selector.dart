import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:write_craft_ai/models/language.dart';
import 'package:write_craft_ai/theme/app_theme.dart';

/// 语言选择器组件 - 按钮样式（带下拉箭头）
/// 显示在输入框左下角
class LanguageSelector extends StatelessWidget {
  final Language selectedLanguage;
  final ValueChanged<Language> onLanguageChanged;

  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  void _showLanguagePicker(BuildContext context) {
    if (AppTheme.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: const Text('选择语言'),
          actions: Language.values.map((lang) {
            return CupertinoActionSheetAction(
              onPressed: () {
                onLanguageChanged(lang);
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(lang.icon, size: 20),
                  const SizedBox(width: 8),
                  Text(lang.label),
                  if (lang == selectedLanguage) ...[
                    const Spacer(),
                    const Icon(CupertinoIcons.check_mark, size: 18),
                  ],
                ],
              ),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '选择语言',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ...Language.values.map((lang) {
                final isSelected = lang == selectedLanguage;
                return ListTile(
                  leading: Icon(lang.icon),
                  title: Text(lang.label),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    onLanguageChanged(lang);
                    Navigator.of(context).pop();
                  },
                );
              }),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (AppTheme.isIOS) {
      return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minSize: 0,
        onPressed: () => _showLanguagePicker(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selectedLanguage.icon, size: 16),
            const SizedBox(width: 4),
            Text(selectedLanguage.label, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            const Icon(CupertinoIcons.chevron_down, size: 12),
          ],
        ),
      );
    } else {
      return TextButton.icon(
        onPressed: () => _showLanguagePicker(context),
        icon: Icon(selectedLanguage.icon, size: 16),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selectedLanguage.label, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 16),
          ],
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }
  }
}
