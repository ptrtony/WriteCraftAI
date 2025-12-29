import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:write_craft_ai/theme/app_theme.dart';

/// 文本输入框组件
/// 支持平台自适应样式
class TextInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final int minLines;
  final int maxLines;

  const TextInputField({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLength,
    this.onChanged,
    this.minLines = 5,
    this.maxLines = 15,
  });

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {}); // 更新字数统计
    widget.onChanged?.call(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    if (AppTheme.isIOS) {
      return _buildIOSInput(context);
    } else {
      return _buildMaterialInput(context);
    }
  }

  /// Material Design 风格输入框
  Widget _buildMaterialInput(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller,
            maxLength: widget.maxLength,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            decoration: InputDecoration(
              hintText: widget.hintText ?? '在这里粘贴或输入文字，支持 Markdown',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              contentPadding: const EdgeInsets.all(16),
              counterText: '',
            ),
            style: const TextStyle(fontSize: 16),
          ),
          if (widget.maxLength != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${widget.controller.text.length} / ${widget.maxLength}',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.controller.text.length > widget.maxLength!
                        ? AppTheme.errorColor
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// iOS 风格输入框
  /// 注意：CupertinoTextField 不支持多行，所以使用 TextField 但应用 iOS 样式
  Widget _buildIOSInput(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.iosSystemBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: CupertinoColors.separator,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller,
            maxLength: widget.maxLength,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            decoration: InputDecoration(
              hintText: widget.hintText ?? '在这里粘贴或输入文字，支持 Markdown',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterText: '',
            ),
            style: const TextStyle(fontSize: 17),
          ),
          if (widget.maxLength != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 8, bottom: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${widget.controller.text.length} / ${widget.maxLength}',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.controller.text.length > widget.maxLength!
                        ? CupertinoColors.destructiveRed
                        : CupertinoColors.secondaryLabel,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

