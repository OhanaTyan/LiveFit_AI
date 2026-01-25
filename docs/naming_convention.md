# 文档命名规范

为了保持文档的一致性和可读性，方便团队成员快速查找和理解各模块相关的文档内容，特制定以下命名规范：

## 1. 文档命名原则

- **清晰明了**：文件名应准确反映文档的内容和用途
- **简洁一致**：文件名应简洁，避免过长，同时保持风格一致
- **易于搜索**：使用常用词汇，便于搜索工具查找

## 2. 文件名格式

### 2.1 中文文档

- 使用中文描述性文件名
- 文件名应使用主谓宾结构，明确表达文档内容
- 例如：`技术架构设计.md`、`开发环境配置.md`

### 2.2 英文文档

- 使用小写字母
- 多个单词之间使用连字符（-）分隔
- 避免使用下划线（_）和空格
- 例如：`technical-architecture.md`、`environment-setup.md`

## 3. 文档分类命名

### 3.1 核心文档（core/）

- 项目概述：`README.md`
- 技术架构：`技术架构.md` 或 `technical-architecture.md`
- 架构设计：`架构设计.md` 或 `architecture-design.md`
- 目录结构：`目录结构.md` 或 `directory-structure.md`
- 发展路线图：`roadmap.md`

### 3.2 开发文档（development/）

- 开发环境配置：`开发环境配置.md` 或 `environment-setup.md`
- 代码规范：`代码规范.md` 或 `coding-conventions.md`
- 维护流程：`维护流程.md` 或 `maintenance-process.md`

### 3.3 API文档（api/）

- REST API文档：`rest_api.md` 或 `rest-api.md`
- WebSocket API文档：`websocket_api.md` 或 `websocket-api.md`

### 3.4 功能模块文档（features/）

- 认证模块：`authentication/README.md`
- 仪表盘模块：`dashboard/README.md`
- 习惯模块：`habits/README.md`
- 天气模块：`weather/weather_module.md` 或 `weather/weather-module.md`

## 4. 文档内容规范

- 使用Markdown格式编写
- 中文文档使用中文标点符号
- 英文文档使用英文标点符号
- 图片统一放在`docs/images`目录下
- 文档开头应有清晰的标题和简短的介绍
- 文档结构应层次分明，使用适当的标题层级

## 5. 文档维护规范

- 新增文档需要在对应模块的README中更新文档列表
- 修改重要文档需记录变更历史
- 删除文档需确认不再使用并通过团队review

## 6. 示例

### 6.1 正确命名

```
docs/
├── core/
│   ├── README.md
│   ├── 技术架构.md
│   └── 目录结构.md
├── development/
│   ├── 开发环境配置.md
│   └── 代码规范.md
├── api/
│   └── rest_api.md
└── features/
    ├── authentication/
    │   └── README.md
    └── weather/
        └── weather_module.md
```

### 6.2 错误命名

```
# 错误：文件名过长且不清晰
docs/技术架构设计文档详细说明_v2.md

# 错误：使用下划线分隔
# 应该：rest-api.md
docs/api/rest_api.md

# 错误：使用空格分隔
docs/开发 环境 配置.md
```

请所有团队成员严格遵循以上命名规范，确保文档的一致性和可读性。