一、产品定位

App 名（暂定）：

WriteCraft AI（写作匠）

目标用户

自媒体作者

学生 / 论文写作者

商务文案

内容运营

程序员（写文档）

核心卖点

一段文字，五种智能写作能力，一键生成可复制结果

二、核心功能设计
1️⃣ 文本输入区

支持粘贴

支持字数统计

支持 Markdown（高级用户）

2️⃣ 五大AI写作能力
功能	说明
✨ 润色	改善语法、语气、专业度
📈 扩写	让内容更详细、更丰富
🔁 续写	基于当前内容继续写
🔄 重写	用不同表达方式重写
✂️ 缩写	精简、提炼重点

UI 形式：
👉 顶部 Tab 或 底部 5 个操作按钮

3️⃣ 结果展示区

原文 & AI 生成结果左右对比（PC）

移动端上下结构

支持：

一键复制

导出 txt / md

分享到微信 / 邮件

三、技术架构
整体结构
Flutter App (Windows / iOS / Android)
        |
        |
  REST API (HTTPS)
        |
        |
   AI模型服务 (OpenAI / Claude / Gemini / DeepSeek)


Flutter 只做 UI 和调用 API
所有 AI 逻辑放在你的后端

四、AI 模型选型（非常关键）

你这个产品属于：

长文本 + 写作类生成

当前最强组合：

场景	模型
中文写作	GPT-4.1 / GPT-4.5
长文章	Claude 3.5 Sonnet
成本优化	DeepSeek-R1
速度	GPT-4.1 mini

推荐策略（商业级）

优先 Claude 3.5（质量最好）
失败 → GPT-4.1
大批量 → DeepSeek

五、五种写作模式的 Prompt 设计

后端封装：

{
  "mode": "polish | expand | continue | rewrite | shorten",
  "text": "用户原文"
}


示例（润色）：

你是一名专业编辑，请对下面的文章进行润色，
保持原意不变，提高表达的流畅度和专业性：

{{text}}


扩写：

请在不改变核心观点的前提下，将以下内容扩写到更详细、更完整的版本：
{{text}}

六、Flutter 前端架构
技术栈
模块	技术
UI	Flutter 3
状态管理	Riverpod
网络	Dio
跨端	Flutter Desktop + iOS + Android
本地存储	Hive
剪贴板	Clipboard API
页面结构
MainPage
 ├── EditorPage（输入区）
 ├── ResultPage（AI输出）
 └── SettingsPage（模型 / 语言）

Flutter 调用示例
final res = await dio.post(
  "https://api.writecraft.ai/generate",
  data: {
    "mode": "polish",
    "text": inputText
  }
);

setState(() {
  resultText = res.data["result"];
});

一键复制
Clipboard.setData(ClipboardData(text: resultText));

七、后台架构（Node / Java 都可）

推荐：

API Gateway
   |
AI Router
   |
模型池（GPT / Claude / DeepSeek）


你可以做一个 智能调度器：

短文 → GPT
长文 → Claude
低价 → DeepSeek

八、收费模式设计

你这个项目非常适合订阅制：

套餐	限额
免费	每天3次
Pro	300次/月
Ultra	不限 + Claude
九、商业潜力

这是一个标准的 AI SaaS 爆款模型：

写作工具 + 多端 + API = 极强变现能力

国内类似产品（秘塔、通义写作、火山写作）
国外（Jasper、Copy.ai、Grammarly AI）

