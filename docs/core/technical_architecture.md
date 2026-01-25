# 技术文档

## 1. 项目概述

Life Fit是一个基于Flutter的跨平台健身应用，旨在帮助用户管理健身计划、跟踪进度和提高健康水平。

### 1.1 项目定位
- **目标用户**：健身爱好者、健康生活追求者
- **核心价值**：提供全面的健身管理和健康追踪功能
- **竞争优势**：跨平台支持、语音交互、个性化推荐

### 1.2 技术栈
| 技术领域 | 技术选型 | 版本 | 选型理由 |
|---------|---------|------|----------|
| 框架 | Flutter | 3.10.7 | 跨平台支持、热重载、高性能 |
| 语言 | Dart | 3.0.7 | 类型安全、高性能、与Flutter深度集成 |
| 状态管理 | Provider | 6.0.5 | 简单易用、适合中小型应用、社区支持好 |
| 本地存储 | SharedPreferences | 2.1.2 | 轻量级、易于使用、适合存储简单数据 |
| UI组件 | Material Design | - | 丰富的组件库、美观的设计语言 |
| 图表库 | fl_chart | 0.62.0 | 高性能、支持多种图表类型、易于定制 |
| 语音识别 | speech_to_text | 6.3.0 | 跨平台支持、易于集成 |
| 通知 | flutter_local_notifications | 15.1.0+1 | 支持多种通知类型、跨平台 |
| 权限管理 | permission_handler | 10.4.3 | 统一的权限请求接口、跨平台支持 |

## 2. 开发环境配置

### 2.1 Flutter环境搭建
1. 下载并安装Flutter SDK：https://docs.flutter.dev/get-started/install
2. 配置环境变量：将Flutter SDK的bin目录添加到系统PATH
3. 运行`flutter doctor`检查环境是否配置成功
4. 安装Flutter插件到IDE（Android Studio/VS Code）

### 2.2 项目依赖安装
```bash
# 克隆项目
git clone <repository-url>
cd life_fit

# 安装依赖
flutter pub get

# 运行应用
flutter run
```

### 2.3 IDE配置
- **Android Studio**：
  - 安装Flutter插件
  - 安装Dart插件
  - 配置Flutter SDK路径

- **VS Code**：
  - 安装Flutter扩展
  - 安装Dart扩展
  - 配置Flutter SDK路径

## 3. 代码规范

### 3.1 Dart代码规范
- 遵循Dart官方代码规范：https://dart.dev/guides/language/effective-dart
- 使用`flutter_lints`进行代码检查
- 代码缩进：4个空格
- 命名规范：
  - 类名：大驼峰命名法（如：`UserProfile`）
  - 方法名：小驼峰命名法（如：`getUserProfile`）
  - 变量名：小驼峰命名法（如：`userName`）
  - 常量名：全大写，下划线分隔（如：`MAX_RETRY_COUNT`）

### 3.2 代码注释规范
- 为公共类、方法添加文档注释（///）
- 为复杂逻辑添加单行注释（//）
- 注释应简洁明了，说明代码的用途和实现逻辑

### 3.3 Git提交规范
- 提交信息格式：`<type>: <description>`
- 类型包括：
  - `feat`：新功能
  - `fix`：修复bug
  - `docs`：文档更新
  - `style`：代码风格调整
  - `refactor`：代码重构
  - `test`：测试代码
  - `chore`：构建脚本或依赖更新

## 4. 项目架构

### 4.1 整体架构
Life Fit采用模块化架构设计，基于功能划分模块，各模块之间通过明确的接口进行通信。

```
lib/
├── src/
│   ├── core/              # 核心功能模块
│   │   ├── localization/  # 国际化支持
│   │   ├── services/      # 通用服务
│   │   └── theme/         # 主题管理
│   └── features/          # 功能模块
│       ├── authentication/ # 认证系统
│       ├── dashboard/      # 仪表盘
│       ├── onboarding/     # 引导流程
│       ├── profile/        # 个人资料
│       ├── schedule/       # 日程管理
│       ├── settings/       # 设置
│       ├── statistics/     # 统计分析
│       ├── voice_schedule/ # 语音日程
│       └── weather/        # 天气功能
└── main.dart              # 应用入口
```

### 4.2 模块间通信
- **状态管理**：使用Provider进行状态管理，实现组件间的数据共享
- **路由管理**：使用Flutter内置的路由系统，通过命名路由进行页面跳转
- **服务调用**：通过Service层封装API调用和本地存储操作

## 5. 核心功能实现

### 5.1 认证系统
- **实现方式**：基于Provider的状态管理，使用SharedPreferences存储用户凭证
- **核心组件**：
  - `AuthProvider`：管理认证状态
  - `AuthService`：处理认证逻辑
  - `LoginScreen`：登录界面
  - `RegisterScreen`：注册界面

### 5.2 日程管理
- **实现方式**：使用SQFlite本地数据库存储日程数据，通过Provider进行状态管理
- **核心组件**：
  - `ScheduleProvider`：管理日程状态
  - `ScheduleService`：处理日程逻辑
  - `ScheduleDatabase`：数据库操作
  - `ScheduleScreen`：日程管理界面

### 5.3 统计分析
- **实现方式**：使用fl_chart库绘制图表，通过Provider管理统计数据
- **核心组件**：
  - `StatisticsProvider`：管理统计数据
  - `StatisticsService`：处理统计逻辑
  - `StatisticsScreen`：统计分析界面

### 5.4 语音日程
- **实现方式**：使用speech_to_text库进行语音识别，将识别结果转换为日程
- **核心组件**：
  - `VoiceScheduleProvider`：管理语音日程状态
  - `VoiceScheduleService`：处理语音识别逻辑
  - `VoiceScheduleScreen`：语音日程界面

## 6. 本地存储设计

### 6.1 数据模型
- **用户数据**：存储用户基本信息、偏好设置
- **日程数据**：存储用户的健身日程
- **统计数据**：存储用户的健身统计信息
- **设置数据**：存储应用的设置信息

### 6.2 存储方式
- **SharedPreferences**：存储简单的键值对数据，如用户偏好设置、认证凭证
- **SQFlite**：存储结构化数据，如日程、统计数据

## 7. 网络请求设计

### 7.1 API架构
- **RESTful API**：采用RESTful设计风格，使用HTTP协议进行通信
- **API版本控制**：通过URL路径进行版本控制，如`/api/v1/users`
- **认证方式**：使用Bearer Token进行认证

### 7.2 网络请求实现
- **HTTP客户端**：使用Dio库进行网络请求
- **请求拦截器**：添加认证令牌、请求日志
- **响应拦截器**：处理错误响应、解析响应数据

## 8. 测试体系

### 8.1 测试类型
- **单元测试**：测试核心业务逻辑、工具类
- **集成测试**：测试模块间的交互
- **UI测试**：测试用户界面流程

### 8.2 测试框架
- **flutter_test**：Flutter官方测试框架
- **mockito**：用于模拟依赖项
- **integration_test**：用于集成测试

### 8.3 测试执行
```bash
# 运行单元测试
flutter test

# 运行集成测试
flutter test integration_test

# 生成测试覆盖率报告
flutter test --coverage
```

## 9. 部署与发布

### 9.1 构建流程
```bash
# 构建Android版本
flutter build apk --release

# 构建iOS版本
flutter build ios --release

# 构建Web版本
flutter build web --release

# 构建Windows版本
flutter build windows --release

# 构建macOS版本
flutter build macos --release

# 构建Linux版本
flutter build linux --release
```

### 9.2 发布准备
- **应用图标**：准备不同尺寸的应用图标
- **启动画面**：设计启动画面
- **应用描述**：编写应用商店描述
- **截图**：准备应用截图

### 9.3 应用商店发布
- **Google Play**：上传APK文件，填写应用信息
- **App Store**：上传IPA文件，填写应用信息
- **Microsoft Store**：上传MSIX文件，填写应用信息

## 10. 性能优化

### 10.1 启动优化
- 延迟加载非关键资源
- 使用异步初始化
- 优化依赖项

### 10.2 内存优化
- 合理使用缓存
- 及时释放资源
- 优化图片加载

### 10.3 UI性能优化
- 使用const构造器
- 优化setState调用
- 使用ListView.builder等懒加载组件

## 11. 安全性

### 11.1 数据加密
- 对敏感数据进行加密存储
- 使用安全的密钥管理

### 11.2 API安全
- 使用HTTPS协议
- 实现API认证和授权
- 防止API滥用

### 11.3 应用安全
- 防止注入攻击
- 防止跨站脚本攻击
- 定期进行安全审计

## 12. 监控与维护

### 12.1 错误监控
- 集成Firebase Crashlytics
- 收集并分析崩溃日志

### 12.2 性能监控
- 集成Firebase Performance
- 监控应用性能指标

### 12.3 用户反馈
- 集成用户反馈功能
- 及时处理用户反馈

## 13. 扩展与升级

### 13.1 功能扩展
- 设计可扩展的插件系统
- 支持第三方服务集成

### 13.2 技术升级
- 定期升级Flutter和依赖库
- 跟进Flutter新特性
- 优化代码架构

## 14. 开发流程

### 14.1 分支管理
- **main**：主分支，用于发布稳定版本
- **develop**：开发分支，用于集成新功能
- **feature/xxx**：功能分支，用于开发新功能
- **bugfix/xxx**：修复分支，用于修复bug

### 14.2 代码审查
- 所有代码变更必须经过代码审查
- 使用GitHub/GitLab的Pull Request功能进行代码审查

### 14.3 持续集成/持续部署
- 配置CI/CD流程
- 自动运行测试和构建
- 自动部署到测试环境

## 15. 团队协作

### 15.1 沟通方式
- 使用Slack/Teams进行日常沟通
- 使用Jira进行任务管理
- 定期召开团队会议

### 15.2 文档协作
- 使用Confluence或Notion进行文档管理
- 保持文档的及时更新

## 16. 附录

### 16.1 常用命令
```bash
# 运行应用
flutter run

# 安装依赖
flutter pub get

# 升级依赖
flutter pub upgrade

# 代码分析
flutter analyze

# 格式化代码
flutter format .

# 运行测试
flutter test
```

### 16.2 资源链接
- [Flutter官方文档](https://docs.flutter.dev/)
- [Dart官方文档](https://dart.dev/guides)
- [Provider文档](https://pub.dev/packages/provider)
- [SQFlite文档](https://pub.dev/packages/sqflite)
- [fl_chart文档](https://pub.dev/packages/fl_chart)
