# 项目结构说明文档

## 1. 项目概述

Life Fit 是一个基于 Flutter 的跨平台健身应用，旨在帮助用户管理健身计划、跟踪进度和提高健康水平。本项目采用模块化、分层架构设计，支持跨平台运行，遵循高内聚、低耦合原则，便于维护和扩展。

## 2. 文档目录结构

### 2.1 总体结构

项目文档采用模块化结构，按照文档类型和用途进行分类，便于查找和维护。

```
docs/
├── core/           # 核心文档
├── development/    # 开发文档
├── api/            # API文档
├── modules/        # 功能模块文档
├── operations/     # 运维文档
├── testing/        # 测试文档
├── user/           # 用户文档
└── README.md       # 文档总索引
```

### 2.2 核心文档 (`core/`)
包含项目的核心信息和基础架构说明：

| 文档名称 | 路径 | 用途 |
|---------|------|------|
| 项目概述 | `docs/core/README.md` | 项目简介和文档索引 |
| 技术架构 | `docs/core/technical_architecture.md` | 技术栈和架构概览 |
| 详细架构设计 | `docs/core/architecture_design.md` | 模块划分和数据流设计 |
| 项目结构 | `docs/core/project_structure.md` | 项目目录结构和核心文件说明 |
| 发展路线图 | `docs/core/roadmap.md` | 项目规划和优化计划 |

### 2.3 开发文档 (`development/`)
包含开发相关的指南和规范：

| 文档名称 | 路径 | 用途 |
|---------|------|------|
| 开发环境配置 | `docs/development/开发环境配置.md` | 开发环境搭建指南 |
| 代码命名规范 | `docs/development/coding_conventions.md` | 代码命名规则 |
| 文档与代码维护流程 | `docs/development/maintenance_process.md` | 文档和代码维护流程 |

### 2.4 API文档 (`api/`)
包含项目的 API 设计和使用说明：

| 文档名称 | 路径 | 用途 |
|---------|------|------|
| RESTful API 文档 | `docs/api/rest_api.md` | RESTful API 设计和使用 |

### 2.5 功能模块文档 (`modules/`)
包含各个功能模块的详细设计和实现：

| 文档名称 | 路径 | 用途 |
|---------|------|------|
| 天气模块设计 | `docs/modules/weather_module.md` | 天气模块的设计和实现 |

### 2.6 运维文档 (`operations/`)
包含项目的运维和部署相关信息：

| 文档名称 | 路径 | 用途 |
|---------|------|------|
| 问题诊断和解决方案 | `docs/operations/troubleshooting.md` | 常见问题和解决方案 |

## 3. 代码目录结构

### 3.1 总体结构

项目代码采用清晰的分层架构，按照功能模块进行划分，便于维护和扩展。

```
lib/
├── src/
│   ├── core/              # 核心功能
│   │   ├── common/        # 通用常量和工具
│   │   ├── localization/  # 国际化支持
│   │   ├── services/      # 核心服务
│   │   ├── theme/         # 主题管理
│   │   └── utils/         # 通用工具类
│   ├── features/          # 功能模块
│   │   ├── authentication/ # 认证模块
│   │   ├── dashboard/      # 仪表盘模块
│   │   ├── habits/         # 习惯模块
│   │   ├── onboarding/     # 引导流程模块
│   │   ├── profile/        # 个人资料模块
│   │   ├── schedule/       # 日程管理模块
│   │   ├── settings/       # 设置模块
│   │   ├── statistics/     # 统计模块
│   │   ├── voice_schedule/ # 语音日程模块
│   │   └── weather/        # 天气模块
│   └── utils/             # 全局工具类
└── main.dart              # 应用入口
```

### 3.2 核心模块 (`core/`)
提供应用的核心功能和通用组件：

#### 3.2.1 国际化支持 (`localization/`)
- `app_localizations.dart` - 应用国际化支持
- `locale_provider.dart` - 语言切换提供者

#### 3.2.2 核心服务 (`services/`)
- `ai_service.dart` - AI 智能服务
- `event_bus_service.dart` - 事件总线服务
- `fuzzy_info_handler.dart` - 模糊信息处理服务
- `nlp_service.dart` - 自然语言处理服务
- `operation_log_service.dart` - 操作日志服务
- `schedule_analysis_service.dart` - 日程分析服务
- `schedule_import_service.dart` - 日程导入服务
- `storage_service.dart` - 存储服务
- `time_service.dart` - 时间服务
- `user_feedback_service.dart` - 用户反馈服务
- `voice_recognition_service.dart` - 语音识别服务

#### 3.2.3 主题管理 (`theme/`)
- `app_colors.dart` - 应用颜色配置
- `app_theme.dart` - 应用主题定义
- `gradient_utils.dart` - 渐变工具类
- `theme_provider.dart` - 主题切换提供者

#### 3.2.4 通用工具类 (`utils/`)
- `date_time_utils.dart` - 日期时间工具类
- `env_utils.dart` - 环境变量工具类
- `string_utils.dart` - 字符串工具类

### 3.3 功能模块 (`features/`)
按照功能划分为独立模块，每个模块包含自己的业务逻辑、数据模型和UI组件：

#### 3.3.1 认证模块 (`authentication/`)
- **主要功能**：用户登录、注册和认证管理
- **核心文件**：
  - `presentation/login_screen.dart` - 登录界面
  - `presentation/widgets/privacy_agreement_row.dart` - 隐私协议行组件
  - `presentation/widgets/social_sign_in_button.dart` - 社交登录按钮

#### 3.3.2 仪表盘模块 (`dashboard/`)
- **主要功能**：应用主界面，显示日程和AI建议
- **核心文件**：
  - `presentation/pages/dashboard_page.dart` - 仪表盘主页面
  - `presentation/widgets/energy_battery_header.dart` - 能量电池头部组件
  - `presentation/widgets/schedule_timeline.dart` - 日程时间线组件

#### 3.3.3 习惯模块 (`habits/`)
- **主要功能**：微习惯管理和生成
- **核心文件**：
  - `domain/models/micro_habit.dart` - 微习惯模型
  - `domain/services/micro_habit_generator_service.dart` - 微习惯生成服务

#### 3.3.4 引导流程模块 (`onboarding/`)
- **主要功能**：新用户引导流程
- **核心文件**：
  - `domain/onboarding_state.dart` - 引导流程状态管理
  - `presentation/screens/onboarding_screen.dart` - 引导流程主屏幕
  - `presentation/screens/steps/` - 引导步骤集合
  - `presentation/widgets/onboarding_progress_bar.dart` - 引导进度条
  - `presentation/widgets/selection_card.dart` - 选择卡片

#### 3.3.5 个人资料模块 (`profile/`)
- **主要功能**：用户资料管理和编辑
- **核心文件**：
  - `domain/user_profile.dart` - 用户资料模型
  - `presentation/profile_edit_screen.dart` - 用户资料编辑界面
  - `presentation/providers/user_profile_provider.dart` - 用户资料提供者

#### 3.3.6 日程管理模块 (`schedule/`)
- **主要功能**：健身日程的创建、编辑和管理
- **核心文件**：
  - `domain/models/schedule_event.dart` - 日程事件模型
  - `domain/services/schedule_conflict_detector.dart` - 日程冲突检测器
  - `presentation/pages/schedule_page.dart` - 日程主页面
  - `presentation/pages/schedule_edit_page.dart` - 日程编辑页面
  - `presentation/widgets/calendar_strip.dart` - 日历条组件
  - `presentation/widgets/event_card.dart` - 事件卡片组件

#### 3.3.7 设置模块 (`settings/`)
- **主要功能**：应用设置和偏好管理
- **核心文件**：
  - `presentation/settings_screen.dart` - 设置主页面
  - `presentation/widgets/setting_item.dart` - 设置项组件
  - `presentation/widgets/setting_section.dart` - 设置分组组件

#### 3.3.8 统计模块 (`statistics/`)
- **主要功能**：健身数据统计和分析
- **核心文件**：
  - `presentation/pages/statistics_page.dart` - 统计主页面
  - `presentation/pages/stats_settings_page.dart` - 统计设置页面
  - `presentation/widgets/activity_trend_chart.dart` - 活动趋势图组件
  - `presentation/widgets/workout_type_pie_chart.dart` - 锻炼类型饼图组件

#### 3.3.9 语音日程模块 (`voice_schedule/`)
- **主要功能**：语音录入和日程生成
- **核心文件**：
  - `presentation/screens/voice_schedule_screen.dart` - 语音日程主屏幕
  - `presentation/widgets/voice_input_bar.dart` - 语音输入栏组件
  - `presentation/widgets/voice_wave_animation.dart` - 语音波形动画组件

#### 3.3.10 天气模块 (`weather/`)
- **主要功能**：天气信息获取和显示
- **核心文件**：
  - `domain/models/weather_data.dart` - 天气数据模型
  - `domain/models/exercise_recommendation.dart` - 锻炼推荐模型
  - `domain/services/weather_api_service.dart` - 天气 API 服务
  - `domain/services/weather_cache_service.dart` - 天气缓存服务
  - `presentation/providers/weather_provider.dart` - 天气提供者
  - `presentation/widgets/weather_main_card.dart` - 天气主卡片组件
  - `presentation/widgets/exercise_recommendation_card.dart` - 锻炼推荐卡片组件

### 3.4 模块内部结构

每个功能模块内部采用分层结构，遵循清晰的职责划分：

```
module_name/
├── domain/           # 领域层，包含业务逻辑和数据模型
│   ├── models/       # 数据模型定义
│   └── services/     # 业务逻辑服务
├── presentation/     # 表示层，包含UI组件和状态管理
│   ├── pages/        # 完整页面
│   ├── widgets/      # 可复用组件
│   └── providers/    # 状态管理提供者
└── data/             # 数据层，包含数据访问逻辑（可选）
    ├── repositories/ # 数据仓库
    └── sources/      # 数据源
```

## 4. 命名规范

### 4.1 文档命名

- 使用小写，下划线分隔
- 清晰描述文档内容
- 包含版本号（如：`rest_api_v1.md`）

### 4.2 代码命名

| 元素类型 | 命名风格 | 示例 |
|---------|---------|------|
| 类名 | 大驼峰命名法（PascalCase） | `UserProfile`, `ScheduleEvent` |
| 方法名 | 小驼峰命名法（camelCase） | `getUserProfile`, `calculateCalories` |
| 变量名 | 小驼峰命名法（camelCase） | `userName`, `isActive` |
| 常量名 | 全大写，下划线分隔 | `MAX_RETRY_COUNT`, `API_BASE_URL` |
| 枚举名 | 大驼峰命名法（PascalCase） | `UserRole`, `WorkoutType` |
| 枚举值 | 全大写，下划线分隔 | `ADMIN`, `USER`, `MUSCLE_GAIN` |
| 文件名 | 小写，下划线分隔 | `user_profile.dart`, `schedule_event.dart` |
| 目录名 | 小写，单复数根据内容决定 | `core/`, `features/`, `services/` |
| 包名 | 小写，点分隔 | `package:life_fit/core/utils`, `package:life_fit/features/schedule` |

### 4.3 目录命名

- 使用小写，单复数根据内容决定
- 目录名应反映其包含的内容和功能
- 核心目录使用单数形式，功能模块目录使用复数形式

## 5. 维护流程

### 5.1 文档维护

1. **创建流程**：确定需求 → 选择文档类型 → 编写文档 → 审核 → 发布
2. **更新触发条件**：代码功能变化、架构变化、技术栈变化、文档错误或过时
3. **更新频率**：重要文档实时更新，功能模块文档在功能开发完成后更新，其他文档至少每季度更新一次

### 5.2 代码维护

1. **编写规范**：遵循命名规范 → 编写注释 → 添加文档引用 → 编写测试
2. **更新流程**：代码审查 → 提交规范 → 版本控制
3. **重构流程**：制定计划 → 编写测试 → 重构 → 测试 → 更新文档 → 提交

### 5.3 文档与代码关联

1. **文档中引用代码**：明确引用相关代码文件路径和关键类/方法
2. **代码中引用文档**：在关键代码文件的注释中引用相关文档
3. **版本同步**：使用相同的版本号，通过Git标签标记重要版本，维护详细的变更日志

## 6. 如何使用项目结构

### 6.1 新功能开发

1. **了解项目架构**：阅读 `docs/core/architecture_design.md` 和 `docs/core/technical_architecture.md`
2. **设置开发环境**：参考 `docs/development/开发环境配置.md` 配置开发环境
3. **选择功能模块**：根据功能需求选择或创建合适的功能模块
4. **遵循命名规范**：参考 `docs/development/coding_conventions.md` 编写代码
5. **编写文档**：在开发过程中同步编写或更新相关文档
6. **进行测试**：编写单元测试和集成测试，确保代码质量
7. **提交代码**：遵循代码提交规范，进行代码审查

### 6.2 文档编写

1. **选择文档类型**：根据文档内容和用途选择合适的文档类型
2. **遵循文档结构**：参考现有文档的结构和格式
3. **使用Markdown格式**：所有文档使用Markdown格式编写
4. **添加相关链接**：在文档中添加相关文档和代码的链接
5. **审核发布**：文档编写完成后，经过审核再发布

### 6.3 项目维护

1. **定期审查**：定期审查文档和代码，确保其准确性和完整性
2. **及时更新**：当代码或功能发生变化时，及时更新相关文档
3. **保持一致性**：确保文档与代码的一致性，避免出现矛盾
4. **遵循维护流程**：严格按照文档和代码维护流程进行操作

## 7. 总结

Life Fit 项目采用了清晰、模块化的文档和代码结构，便于团队成员快速了解和使用项目。通过遵循统一的命名规范和维护流程，可以确保文档与代码的一致性、准确性和可维护性。

本文档概述了项目的整体结构，包括文档目录结构、代码目录结构、命名规范和维护流程，希望能帮助团队成员更好地理解和使用项目结构，提高开发效率和代码质量。

## 8. 参考文档

- [Flutter 官方文档](https://docs.flutter.dev/)
- [Dart 语言规范](https://dart.dev/guides/language/spec)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [RESTful API 设计指南](https://restfulapi.net/)
