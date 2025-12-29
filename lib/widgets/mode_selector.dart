import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:write_craft_ai/models/write_mode.dart';
import 'package:write_craft_ai/theme/app_theme.dart';

/// 模式选择器组件
/// Android: 使用 SegmentedButton (Material 3)
/// iOS: 使用 SegmentedControl (iOS 风格)
class ModeSelector extends StatelessWidget {
  final WriteMode selectedMode;
  final ValueChanged<WriteMode> onModeChanged;

  const ModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (AppTheme.isIOS) {
      return _buildIOSSelector(context);
    } else {
      return _buildMaterialSelector(context);
    }
  }

  /// Material Design 风格选择器
  Widget _buildMaterialSelector(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: WriteMode.values.map((mode) {
          final isSelected = mode == selectedMode;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(mode.icon),
                  const SizedBox(width: 4),
                  Text(mode.label),
                ],
              ),
              onSelected: (selected) {
                if (selected) {
                  onModeChanged(mode);
                }
              },
              selectedColor: AppTheme.getModeColor(mode.value).withOpacity(0.2),
              checkmarkColor: AppTheme.getModeColor(mode.value),
              labelStyle: TextStyle(
                color: isSelected
                    ? AppTheme.getModeColor(mode.value)
                    : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// iOS 风格选择器
  Widget _buildIOSSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CupertinoSlidingSegmentedControl<WriteMode>(
        groupValue: selectedMode,
        onValueChanged: (WriteMode? value) {
          if (value != null) {
            onModeChanged(value);
          }
        },
        children: {
          for (var mode in WriteMode.values)
            mode: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(
                mode.label,
                style: const TextStyle(fontSize: 14),
              ),
            ),
        },
      ),
    );
  }
}


