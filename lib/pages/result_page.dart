import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:write_craft_ai/models/write_mode.dart';
import 'package:write_craft_ai/models/ai_model.dart';
import 'package:write_craft_ai/models/language.dart';
import 'package:write_craft_ai/theme/app_theme.dart';
import 'package:write_craft_ai/network/repository/write_repository.dart';

/// 结果页面 - 显示AI生成结果
class ResultPage extends StatefulWidget {
  final String originalText;
  final WriteMode mode;
  final AIModel model;
  final Language language;

  const ResultPage({
    super.key,
    required this.originalText,
    required this.mode,
    required this.model,
    required this.language,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _isOriginalExpanded = false;
  String _resultText = '';
  bool _isLoading = true;
  String? _errorMessage;
  final WriteRepository _repository = WriteRepository();

  @override
  void initState() {
    super.initState();
    _loadAIResult();
  }

  /// 调用 API 获取 AI 生成结果
  Future<void> _loadAIResult() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _repository.generate(
        text: widget.originalText,
        mode: widget.mode,
        model: widget.model,
        lang: widget.language,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _resultText = result;
        });
      }
    } on DioException catch (e) {
      // 处理网络错误
      String errorMsg = '网络请求失败';
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMsg = '请求超时，请检查网络连接';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMsg = '无法连接到服务器，请检查网络设置';
      } else if (e.response != null) {
        errorMsg = '服务器错误: ${e.response?.statusCode}';
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = errorMsg;
        });
      }
      
      _showErrorDialog(errorMsg);
    } catch (e) {
      // 处理其他错误
      final errorMsg = '发生错误: ${e.toString()}';
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = errorMsg;
        });
      }
      
      _showErrorDialog(errorMsg);
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _resultText));
    _showSnackBar('已复制到剪贴板');
  }

  /// 分享功能
  Future<void> _shareResult() async {
    if (_resultText.isEmpty) return;

    try {
      await Share.share(
        _resultText,
        subject: 'AI ${widget.mode.label}结果',
      );
    } catch (e) {
      _showSnackBar('分享失败: ${e.toString()}');
    }
  }

  /// 替换原文功能 - 返回替换的文本到上一页
  void _replaceOriginalText() {
    Navigator.of(context).pop(_resultText);
  }

  /// 导出功能 - 导出为文本文件
  Future<void> _exportToFile() async {
    if (_resultText.isEmpty) return;

    try {
      // 获取文档目录
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'writecraft_${widget.mode.label}_$timestamp.txt';
      final file = File('${directory.path}/$fileName');

      // 写入文件内容
      await file.writeAsString(_resultText);

      // 分享文件
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'AI ${widget.mode.label}结果',
        subject: fileName,
      );

      _showSnackBar('已导出到文件');
    } catch (e) {
      _showSnackBar('导出失败: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    if (AppTheme.isIOS) {
      // iOS使用CupertinoAlertDialog或HUD
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text('确定'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
    }
  }

  /// 显示错误对话框
  void _showErrorDialog(String message) {
    if (AppTheme.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('错误'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text('重试'),
              onPressed: () {
                Navigator.of(context).pop();
                _loadAIResult();
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('错误'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _loadAIResult();
              },
              child: const Text('重试'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
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
        title: Text('AI ${widget.mode.label}结果'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _resultText.isNotEmpty ? _copyToClipboard : null,
            tooltip: '复制',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _resultText.isNotEmpty ? _shareResult : null,
            tooltip: '分享',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage != null
              ? _buildErrorState()
              : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 原文折叠区
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: ExpansionTile(
                      leading: const Icon(Icons.text_fields),
                      title: const Text('原文'),
                      initiallyExpanded: _isOriginalExpanded,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          _isOriginalExpanded = expanded;
                        });
                      },
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: SelectableText(
                            widget.originalText,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // AI结果区
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.mode.icon,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'AI 生成结果',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SelectableText(
                            _resultText,
                            style: const TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // 操作按钮
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _copyToClipboard,
                            icon: const Icon(Icons.copy),
                            label: const Text('复制'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _resultText.isNotEmpty ? _replaceOriginalText : null,
                            icon: const Icon(Icons.refresh),
                            label: const Text('替换原文'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _resultText.isNotEmpty ? _exportToFile : null,
                            icon: const Icon(Icons.download),
                            label: const Text('导出'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _resultText.isNotEmpty ? _shareResult : null,
                            icon: const Icon(Icons.share),
                            label: const Text('分享'),
                          ),
                        ),
                      ],
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
        middle: Text('AI ${widget.mode.label}结果'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _resultText.isNotEmpty ? _copyToClipboard : null,
              child: const Icon(CupertinoIcons.doc_on_clipboard),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _resultText.isNotEmpty ? _shareResult : null,
              child: const Icon(CupertinoIcons.share),
            ),
          ],
        ),
      ),
      child: _isLoading
          ? _buildLoadingState()
          : _errorMessage != null
              ? _buildErrorState()
              : SafeArea(
              child: ListView(
                children: [
                  // 原文折叠区
                  CupertinoListSection(
                    children: [
                      CupertinoListTile(
                        leading: const Icon(CupertinoIcons.text_alignleft),
                        title: const Text('原文'),
                        trailing: Icon(
                          _isOriginalExpanded
                              ? CupertinoIcons.chevron_up
                              : CupertinoIcons.chevron_down,
                        ),
                        onTap: () {
                          setState(() {
                            _isOriginalExpanded = !_isOriginalExpanded;
                          });
                        },
                      ),
                      if (_isOriginalExpanded)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: SelectableText(
                            widget.originalText,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                    ],
                  ),
                  
                  // AI结果区
                  CupertinoListSection(
                    header: Row(
                      children: [
                        Text(
                          widget.mode.icon,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        const Text('AI 生成结果'),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SelectableText(
                          _resultText,
                          style: const TextStyle(fontSize: 17, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                  
                  // 操作按钮
                  CupertinoListSection(
                    children: [
                      CupertinoListTile(
                        title: const Text('复制'),
                        leading: const Icon(CupertinoIcons.doc_on_clipboard),
                        onTap: _copyToClipboard,
                      ),
                      CupertinoListTile(
                        title: const Text('替换原文'),
                        leading: const Icon(CupertinoIcons.arrow_2_squarepath),
                        onTap: _resultText.isNotEmpty ? _replaceOriginalText : null,
                      ),
                      CupertinoListTile(
                        title: const Text('导出'),
                        leading: const Icon(CupertinoIcons.arrow_down_doc),
                        onTap: _resultText.isNotEmpty ? _exportToFile : null,
                      ),
                      CupertinoListTile(
                        title: const Text('分享'),
                        leading: const Icon(CupertinoIcons.share),
                        onTap: _resultText.isNotEmpty ? _shareResult : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (AppTheme.isIOS)
            const CupertinoActivityIndicator(radius: 20)
          else
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.getModeColor(widget.mode.value),
              ),
            ),
          const SizedBox(height: 24),
          Text(
            'AI 正在${widget.mode.label}中...',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// 构建错误状态视图
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppTheme.isIOS ? CupertinoIcons.exclamationmark_triangle : Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              '出错了',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? '未知错误',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            if (AppTheme.isIOS)
              CupertinoButton.filled(
                onPressed: _loadAIResult,
                child: const Text('重试'),
              )
            else
              ElevatedButton.icon(
                onPressed: _loadAIResult,
                icon: const Icon(Icons.refresh),
                label: const Text('重试'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.getModeColor(widget.mode.value),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


