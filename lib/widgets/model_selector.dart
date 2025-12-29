import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:write_craft_ai/models/ai_model.dart';
import 'package:write_craft_ai/theme/app_theme.dart';

/// 模型选择器组件 - 按钮样式（带下拉箭头）
/// 显示在输入框左下角
class ModelSelector extends StatelessWidget {
  final AIModel selectedModel;
  final ValueChanged<AIModel> onModelChanged;

  const ModelSelector({
    super.key,
    required this.selectedModel,
    required this.onModelChanged,
  });

  void _showModelPicker(BuildContext context) {
    if (AppTheme.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: const Text('选择模型'),
          actions: AIModel.values.map((model) {
            return CupertinoActionSheetAction(
              onPressed: () {
                onModelChanged(model);
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(model.icon, size: 20),
                  const SizedBox(width: 8),
                  Text(model.label),
                  if (model == selectedModel) ...[
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
                  '选择模型',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ...AIModel.values.map((model) {
                final isSelected = model == selectedModel;
                return ListTile(
                  leading: Icon(model.icon),
                  title: Text(model.label),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    onModelChanged(model);
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
        onPressed: () => _showModelPicker(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selectedModel.icon, size: 16),
            const SizedBox(width: 4),
            Text(selectedModel.label, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            const Icon(CupertinoIcons.chevron_down, size: 12),
          ],
        ),
      );
    } else {
      return TextButton.icon(
        onPressed: () => _showModelPicker(context),
        icon: Icon(selectedModel.icon, size: 16),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selectedModel.label, style: const TextStyle(fontSize: 14)),
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
