# UI 更新总结 - 模型和语言选择功能

## 更新概述

根据需求，已在 UI 中添加了 AI 模型选择和语言选择功能，并更新了相关的网络请求参数。

## 新增功能

### 1. AI 模型选择
- **支持的模型**：
  - `openai` - OpenAI（默认）
  - `deepseek` - DeepSeek
- **UI 位置**：主页面，位于模式选择器和文本输入区之间
- **平台适配**：
  - Android: Material Design SegmentedButton
  - iOS: Cupertino SegmentedControl

### 2. 语言选择
- **支持的语言**：
  - `zh` - 中文 🇨🇳（默认）
  - `en` - English 🇺🇸
- **UI 位置**：主页面，位于模型选择器下方
- **平台适配**：
  - Android: Material Design SegmentedButton（带图标）
  - iOS: Cupertino SegmentedControl（带图标）

## 实现的文件

### 1. 新增模型文件

#### `lib/models/ai_model.dart`
```dart
enum AIModel {
  openai('openai', 'OpenAI'),
  deepseek('deepseek', 'DeepSeek');
  // ...
}
```

#### `lib/models/language.dart`
```dart
enum Language {
  zh('zh', '中文', '🇨🇳'),
  en('en', 'English', '🇺🇸');
  // ...
}
```

### 2. 新增组件

#### `lib/widgets/model_selector.dart`
- 模型选择器组件
- 支持 Material Design 和 iOS 风格
- 使用 SegmentedButton / SegmentedControl

#### `lib/widgets/language_selector.dart`
- 语言选择器组件
- 支持 Material Design 和 iOS 风格
- 显示国旗图标和语言名称

### 3. 更新的文件

#### `lib/network/models/write_request.dart`
```dart
class WriteRequest {
  final String text;
  final String mode;
  final String model;  // 新增
  final String lang;   // 新增
  // ...
}
```

#### `lib/network/repository/write_repository.dart`
```dart
Future<String> generate({
  required String text,
  required WriteMode mode,
  required AIModel model,     // 新增
  required Language lang,      // 新增
}) async {
  // ...
}
```

#### `lib/pages/main_page.dart`
- 添加了模型和语言状态管理
- 在主页面 UI 中集成了模型和语言选择器
- 更新了导航逻辑，传递模型和语言参数到 ResultPage

#### `lib/pages/result_page.dart`
- 更新了构造函数，接收模型和语言参数
- 更新了 API 调用，传递模型和语言参数

## UI 布局

### 主页面布局顺序（从上到下）

1. **AppBar** - 标题和设置按钮
2. **模式选择器** - 润色/扩写/续写/重写/缩写
3. **模型选择器** - OpenAI / DeepSeek ⭐ 新增
4. **语言选择器** - 中文 🇨🇳 / English 🇺🇸 ⭐ 新增
5. **文本输入区** - 多行文本输入框
6. **清除按钮** - 清除输入内容
7. **生成按钮** - 开始 AI 写作

## API 请求格式

更新后的 API 请求参数：

```json
{
  "text": "用户输入的内容",
  "mode": "polish",
  "model": "openai",    // 新增：openai | deepseek
  "lang": "zh"          // 新增：zh | en
}
```

## 默认值

- **模型**：`openai` (OpenAI)
- **语言**：`zh` (中文)

## 用户体验

### Android (Material Design)
- 使用 `SegmentedButton` 组件
- 选中状态有明显的视觉反馈
- 模型选择器显示模型名称
- 语言选择器显示国旗图标 + 语言名称

### iOS (Cupertino)
- 使用 `CupertinoSlidingSegmentedControl` 组件
- 符合 iOS 设计规范
- 平滑的切换动画
- 模型选择器显示模型名称
- 语言选择器显示国旗图标 + 语言名称

## 代码质量

- ✅ 所有代码通过 Flutter linter 检查
- ✅ 遵循 Flutter 代码规范
- ✅ 平台自适应设计
- ✅ 清晰的代码注释
- ✅ 类型安全（使用枚举）

## 使用示例

用户在主页面的使用流程：

1. 选择写作模式（润色/扩写等）
2. 选择 AI 模型（OpenAI / DeepSeek）⭐ 新增
3. 选择输出语言（中文 / English）⭐ 新增
4. 输入文本内容
5. 点击生成按钮
6. 跳转到结果页面，显示 AI 生成的内容

## 注意事项

1. **模型限制**：当前仅支持 `openai` 和 `deepseek`，虽然 API 文档提到可能支持 `auto`、`gpt`、`claude`，但目前 UI 只显示已实现的模型。

2. **语言代码**：语言选择后，会传递对应的语言代码（`zh` 或 `en`）到后端。

3. **扩展性**：如果将来需要添加更多模型或语言，只需要：
   - 在对应的枚举中添加新值
   - UI 会自动更新（因为使用的是枚举值遍历）

## 后续优化建议

1. **模型描述**：可以为每个模型添加描述信息（如速度、质量等）
2. **模型推荐**：根据不同的写作模式推荐合适的模型
3. **语言检测**：可以自动检测输入文本的语言，并推荐对应的输出语言
4. **设置保存**：将用户的模型和语言偏好保存到本地，下次打开时自动使用
5. **模型状态**：显示模型是否可用（如果后端提供模型状态 API）

## 测试建议

1. 测试不同模型组合（OpenAI + 中文、DeepSeek + 英文等）
2. 测试模型切换时的 UI 响应
3. 测试语言切换时的 UI 响应
4. 验证 API 请求参数是否正确
5. 测试在不同屏幕尺寸下的布局

