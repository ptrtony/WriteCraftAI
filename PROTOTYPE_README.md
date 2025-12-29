# WriteCraft AI 原型代码说明

## 概述

这是一个符合 Google Material Design 和 iOS Human Interface Guidelines 的 Flutter UI 原型实现。

## 文件结构

```
lib/
├── main.dart                    # 应用入口，平台自适应主题
├── theme/
│   └── app_theme.dart          # 主题配置（Material & iOS）
├── models/
│   └── write_mode.dart         # 写作模式枚举
├── widgets/
│   ├── mode_selector.dart      # 模式选择器组件（平台自适应）
│   └── text_input_field.dart   # 文本输入框组件（平台自适应）
└── pages/
    ├── main_page.dart          # 主页面（输入和模式选择）
    └── result_page.dart        # 结果页面（AI生成结果展示）
```

## 设计文档

详细的设计规范请查看：`prototype_design.md`

## 主要特性

### 1. 平台自适应
- **Android**: 使用 Material Design 3 组件
- **iOS**: 使用 Cupertino 组件
- 自动检测平台并应用对应样式

### 2. 核心页面

#### 主页面 (MainPage)
- 五大写作模式选择（润色、扩写、续写、重写、缩写）
- 文本输入区（支持多行、字数统计）
- 清除按钮（输入有内容时显示）
- 生成按钮（根据选中模式动态变化颜色和文字）

#### 结果页面 (ResultPage)
- 原文折叠展示
- AI 生成结果展示（可选中复制）
- 操作按钮（复制、替换原文、导出、分享）
- 加载状态提示

### 3. 设计规范

#### 颜色系统
- 遵循 Material Design 3 颜色规范（Android）
- 遵循 iOS Human Interface Guidelines 颜色规范（iOS）
- 每种写作模式有对应的功能色彩

#### 字体系统
- Material: 符合 Material Typography 规范
- iOS: 使用 SF Pro 字体系统

#### 间距和圆角
- Material: 基于 4dp 的间距系统
- iOS: 基于 4pt 的间距系统

## 运行方式

1. 确保已安装 Flutter SDK（3.3.3+）
2. 运行项目：
   ```bash
   flutter run
   ```

### 平台选择

- **Android**: `flutter run -d android`
- **iOS**: `flutter run -d ios`
- **macOS**: `flutter run -d macos`
- **Windows**: `flutter run -d windows`

## 功能说明

### 当前实现
✅ 平台自适应主题系统
✅ 主页面 UI（输入、模式选择）
✅ 结果页面 UI（展示、操作）
✅ 文本输入框（字数统计、平台样式）
✅ 模式选择器（平台样式）
✅ 基本的导航和页面跳转

### 待实现功能
- [ ] API 接口集成（调用后端服务）
- [ ] 设置页面
- [ ] 用户中心
- [ ] 历史记录
- [ ] 文件导出功能
- [ ] 分享功能
- [ ] 深色模式
- [ ] 国际化（i18n）

## 技术栈

- **Flutter**: 3.3.3+
- **Material Design 3**: Android 设计规范
- **Cupertino**: iOS 设计规范
- **Dart**: 3.3.3+

## 设计参考

- [Material Design 3](https://m3.material.io/)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Flutter 官方文档](https://flutter.dev/docs)

## 注意事项

1. **平台检测**: 使用 `AppTheme.isIOS` 和 `AppTheme.isAndroid` 进行平台检测
2. **主题切换**: 在 `main.dart` 中根据平台自动选择 Material 或 Cupertino 主题
3. **组件复用**: 通用组件内部处理平台差异，外部调用无需关心
4. **状态管理**: 当前使用 StatefulWidget，后续可升级为 Riverpod

## 后续开发建议

1. **状态管理**: 引入 Riverpod 进行状态管理
2. **网络请求**: 集成 Dio 调用后端 API
3. **本地存储**: 使用 Hive 存储历史记录和用户设置
4. **路由管理**: 使用 go_router 进行路由管理
5. **错误处理**: 添加全局错误处理和用户友好的错误提示
6. **性能优化**: 添加图片缓存、列表优化等

## 联系

如有问题或建议，请参考 PRD 文档和设计文档。


