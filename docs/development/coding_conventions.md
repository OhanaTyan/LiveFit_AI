# 代码命名规范

## 1. 总则

为了保持代码的一致性、可读性和可维护性，Life Fit项目采用以下命名规范。所有代码贡献者都应该遵循这些规范，确保代码风格统一。

## 2. 命名风格

### 2.1 大小写规则

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

### 2.2 命名原则

1. **清晰性**：命名应清晰、准确，能够反映其用途和功能
2. **简洁性**：命名应简洁明了，避免过长或过于复杂的名称
3. **一致性**：相同类型的元素应使用相同的命名模式
4. **避免歧义**：避免使用容易引起歧义的名称
5. **避免缩写**：除非是广为人知的缩写（如API、URL、HTTP），否则应使用完整名称
6. **使用英文**：所有命名应使用英文，避免使用中文或其他语言

## 3. 具体命名规范

### 3.1 类命名

- 使用大驼峰命名法
- 类名应反映其职责和功能
- 避免使用过于通用的名称，如`Manager`、`Handler`、`Util`等
- 对于Widget类，可以使用`Widget`后缀（如`EventCardWidget`），但通常可以省略

### 3.2 方法命名

- 使用小驼峰命名法
- 方法名应包含动词，清晰描述其功能
- 对于获取数据的方法，使用`get`前缀（如`getUserProfile`）
- 对于设置数据的方法，使用`set`前缀（如`setUserProfile`）
- 对于布尔返回值的方法，使用`is`、`has`、`can`等前缀（如`isValidEmail`、`hasPermission`）
- 对于异步方法，可以使用`Async`后缀或不使用（如`loadDataAsync`或`loadData`）

### 3.3 变量命名

- 使用小驼峰命名法
- 变量名应清晰描述其用途和内容
- 避免使用单个字母作为变量名（循环计数器除外，如`i`、`j`、`k`）
- 对于布尔变量，使用`is`、`has`、`can`等前缀（如`isLoggedIn`、`hasPermission`）

### 3.4 常量命名

- 使用全大写，下划线分隔
- 常量名应清晰描述其用途和内容
- 避免使用魔法数字，应将其定义为常量
- 常量应放在适当的位置，避免全局常量过多

### 3.5 文件名命名

- 使用小写，下划线分隔
- 文件名应反映文件内容和功能
- 对于Widget文件，可以使用`_widget.dart`后缀（如`event_card_widget.dart`），但通常可以省略
- 对于Provider文件，使用`_provider.dart`后缀（如`user_profile_provider.dart`）
- 对于Service文件，使用`_service.dart`后缀（如`schedule_service.dart`）
- 对于Model文件，使用`_model.dart`后缀（如`user_profile_model.dart`）

### 3.6 目录命名

- 使用小写，单复数根据内容决定
- 目录名应反映其包含的内容和功能
- 推荐的目录结构：
  ```
  lib/
  ├── src/
  │   ├── core/              # 核心功能
  │   │   ├── common/        # 通用工具和常量
  │   │   ├── localization/  # 国际化支持
  │   │   ├── services/      # 核心服务
  │   │   └── theme/         # 主题管理
  │   ├── features/          # 功能模块
  │   │   ├── authentication/ # 认证模块
  │   │   ├── dashboard/      # 仪表盘模块
  │   │   ├── schedule/       # 日程管理模块
  │   │   └── weather/        # 天气模块
  │   └── utils/             # 通用工具类
  └── main.dart              # 应用入口
  ```

## 4. 特殊命名规范

### 4.1 Provider命名

- Provider类名应使用`Provider`后缀（如`UserProfileProvider`）
- Provider变量名应使用`provider`后缀（如`userProfileProvider`）

### 4.2 Service命名

- Service类名应使用`Service`后缀（如`ScheduleService`）
- Service变量名应使用`service`后缀（如`scheduleService`）

### 4.3 Model命名

- Model类名应使用`Model`后缀（如`UserProfileModel`），或直接使用实体名称（如`UserProfile`）
- Model变量名应使用实体名称的小驼峰形式（如`userProfile`）

### 4.4 Widget命名

- Widget类名应清晰描述其功能，如`EventCard`、`ScheduleTimeline`
- Widget变量名应使用小驼峰形式，如`eventCard`、`scheduleTimeline`

## 5. 命名规范检查

- 所有代码提交前应通过代码审查，确保命名规范得到遵守
- 可以使用IDE的代码检查工具（如Dart Analysis）来检查命名规范
- 团队成员应相互监督，确保代码风格一致

## 6. 例外情况

- 对于第三方库或API的回调函数，可以遵循其特定的命名规范
- 对于测试代码，可以适当放宽命名规范，但仍应保持清晰和一致

## 7. 总结

遵循统一的命名规范有助于提高代码的可读性、可维护性和团队协作效率。所有代码贡献者都应该认真遵守这些规范，确保Life Fit项目的代码质量。

---

**最后更新时间**：2026-01-24
**适用范围**：Life Fit项目所有代码
