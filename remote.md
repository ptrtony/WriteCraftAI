接口：AI 写作

POST /api/v1/write

Request
{
"mode": "polish | expand | continue | rewrite | shorten",
"text": "用户输入内容",
"model": "auto | gpt | claude | deepseek",
"lang": "zh"
}

Response
{
"code": 0,
"result": "AI生成的内容",
"usage": {
"tokens": 1240,
"model": "claude-3.5"
}
}

四、OpenAI / Claude 接入代码（Node.js）
1️⃣ OpenAI（GPT-4.1）
import OpenAI from "openai";
const client = new OpenAI({ apiKey: process.env.OPENAI_KEY });

export async function callGPT(prompt) {
const res = await client.chat.completions.create({
model: "gpt-4.1",
messages: [
{ role: "system", content: "你是一名专业写作助手" },
{ role: "user", content: prompt }
]
});

return res.choices[0].message.content;
}

2️⃣ Claude 3.5
import Anthropic from "@anthropic-ai/sdk";

const anthropic = new Anthropic({
apiKey: process.env.CLAUDE_KEY,
});

export async function callClaude(prompt) {
const msg = await anthropic.messages.create({
model: "claude-3-5-sonnet-20240620",
max_tokens: 4000,
messages: [
{ role: "user", content: prompt }
],
});

return msg.content[0].text;
}

3️⃣ AI 路由器
export async function callAI(text, mode, model) {
const prompt = buildPrompt(text, mode);

if (model === "claude" || text.length > 1500) {
return await callClaude(prompt);
} else {
return await callGPT(prompt);
}
}

五、Prompt 工厂
function buildPrompt(text, mode) {
const map = {
polish: "请润色以下内容，使表达更专业流畅：",
expand: "请扩写以下内容，使其更详细：",
continue: "请续写以下内容：",
rewrite: "请用不同方式重写以下内容：",
shorten: "请精简以下内容，保留核心信息："
};
return `${map[mode]}\n\n${text}`;
}