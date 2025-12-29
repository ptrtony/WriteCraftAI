import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:write_craft_ai/models/write_mode.dart';
import 'package:write_craft_ai/models/ai_model.dart';
import 'package:write_craft_ai/models/language.dart';
import 'package:write_craft_ai/theme/app_theme.dart';
import 'package:write_craft_ai/widgets/mode_selector.dart';
import 'package:write_craft_ai/widgets/model_selector.dart';
import 'package:write_craft_ai/widgets/language_selector.dart';
import 'package:write_craft_ai/pages/result_page.dart';

/// 主页面 - 文本输入和模式选择
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _textController = TextEditingController();
  WriteMode _selectedMode = WriteMode.polish;
  AIModel _selectedModel = AIModel.auto;
  Language _selectedLanguage = Language.zh;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {}); // 更新UI以显示/隐藏清除按钮和更新字数统计
    });
  }

  @override
  void dispose() {
    _textController.removeListener(() {});
    _textController.dispose();
    super.dispose();
  }

  Future<void> _handleGenerate() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      _showEmptyInputDialog();
      return;
    }

    // 导航到结果页面，并等待返回的替换文本
    final replacedText = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => ResultPage(
          originalText: text,
          mode: _selectedMode,
          model: _selectedModel,
          language: _selectedLanguage,
        ),
      ),
    );

    // 如果返回了替换文本，更新输入框
    if (replacedText != null && mounted) {
      setState(() {
        _textController.text = replacedText;
      });
    }
  }

  void _showEmptyInputDialog() {
    if (AppTheme.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('提示'),
          content: const Text('请输入要处理的文本'),
          actions: [
            CupertinoDialogAction(
              child: const Text('确定'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('提示'),
          content: const Text('请输入要处理的文本'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('确定'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (AppTheme.isIOS) {
      return _buildIOSPage(context);
    } else {
      return _buildMaterialPage(context);
    }
  }

  /// Material Design 风格页面
  Widget _buildMaterialPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WriteCraft AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: 导航到设置页面
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: 用户中心
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 模式选择器
            ModeSelector(
              selectedMode: _selectedMode,
              onModeChanged: (mode) {
                setState(() {
                  _selectedMode = mode;
                });
              },
            ),
            
            // 文本输入区（包含左下角的模型和语言选择器）
            Expanded(
              child: _buildInputWithButtons(context),
            ),
            
            // 清除按钮
            if (_textController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _textController.clear();
                      });
                    },
                    icon: const Icon(Icons.clear, size: 18),
                    label: const Text('清除'),
                  ),
                ),
              ),
            
            // 生成按钮
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _handleGenerate,
                  icon: Text(_selectedMode.icon),
                  label: Text('开始${_selectedMode.label}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.getModeColor(_selectedMode.value),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// iOS 风格页面
  Widget _buildIOSPage(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('WriteCraft AI'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                // TODO: 设置页面
              },
              child: const Icon(CupertinoIcons.settings),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                // TODO: 用户中心
              },
              child: const Icon(CupertinoIcons.person),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 模式选择器
            ModeSelector(
              selectedMode: _selectedMode,
              onModeChanged: (mode) {
                setState(() {
                  _selectedMode = mode;
                });
              },
            ),
            
            // 文本输入区（包含左下角的模型和语言选择器）
            Expanded(
              child: _buildInputWithButtons(context),
            ),
            
            // 清除按钮
            if (_textController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        _textController.clear();
                      });
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.clear, size: 18),
                        SizedBox(width: 4),
                        Text('清除'),
                      ],
                    ),
                  ),
                ),
              ),
            
            // 生成按钮
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: CupertinoButton.filled(
                  onPressed: _handleGenerate,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_selectedMode.icon),
                      const SizedBox(width: 8),
                      Text('开始${_selectedMode.label}'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建带底部按钮的输入框
  Widget _buildInputWithButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.isIOS ? AppTheme.iosSystemBackground : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.isIOS ? 10 : 4),
        border: AppTheme.isIOS
            ? Border.all(
                color: CupertinoColors.separator,
                width: 0.5,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 文本输入框
          Expanded(
            child: TextField(
              controller: _textController,
              maxLength: 5000,
              minLines: 5,
              maxLines: 15,
              decoration: InputDecoration(
                hintText: '在这里粘贴或输入文字，支持 Markdown',
                border: AppTheme.isIOS
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                contentPadding: const EdgeInsets.all(16),
                counterText: '',
              ),
              style: TextStyle(fontSize: AppTheme.isIOS ? 17 : 16),
            ),
          ),
          // 底部按钮栏（左侧：模型和语言按钮，右侧：字数统计）
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 左侧：模型和语言选择器
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ModelSelector(
                      selectedModel: _selectedModel,
                      onModelChanged: (model) {
                        setState(() {
                          _selectedModel = model;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    LanguageSelector(
                      selectedLanguage: _selectedLanguage,
                      onLanguageChanged: (language) {
                        setState(() {
                          _selectedLanguage = language;
                        });
                      },
                    ),
                  ],
                ),
                // 右侧：字数统计
                Text(
                  '${_textController.text.length} / 5000',
                  style: TextStyle(
                    fontSize: 12,
                    color: _textController.text.length > 5000
                        ? (AppTheme.isIOS
                            ? CupertinoColors.destructiveRed
                            : AppTheme.errorColor)
                        : (AppTheme.isIOS
                            ? CupertinoColors.secondaryLabel
                            : Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

