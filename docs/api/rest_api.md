# API文档

## 1. API概述

Life Fit API采用RESTful设计风格，使用HTTP协议进行通信，返回JSON格式数据。API支持版本控制，当前版本为v1。

### 1.1 基础URL
```
https://api.lifefit.example.com/api/v1
```

### 1.2 认证方式
- **Bearer Token**：所有API请求（除了认证相关的请求）都需要在请求头中包含`Authorization: Bearer <token>`
- **API Key**：部分公开API需要在请求头中包含`X-API-Key: <api_key>`

### 1.3 响应格式

#### 1.3.1 成功响应
```json
{
  "status": "success",
  "data": {...},
  "message": "操作成功"
}
```

#### 1.3.2 错误响应
```json
{
  "status": "error",
  "error": {
    "code": 400,
    "message": "错误信息"
  }
}
```

### 1.4 错误码

| 错误码 | 描述 |
|-------|------|
| 400 | 请求参数错误 |
| 401 | 未授权，缺少或无效的令牌 |
| 403 | 禁止访问，权限不足 |
| 404 | 资源不存在 |
| 405 | 不支持的请求方法 |
| 500 | 服务器内部错误 |
| 503 | 服务不可用 |

## 2. 认证相关API

### 2.1 用户注册

**请求方式**：POST
**请求URL**：`/users/register`
**认证要求**：不需要

#### 请求参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| email | string | 是 | 用户邮箱 |
| password | string | 是 | 用户密码（至少8位） |
| name | string | 是 | 用户名称 |

#### 示例请求
```json
{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe"
}
```

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "user": {
      "id": "123456",
      "email": "user@example.com",
      "name": "John Doe",
      "avatar": null,
      "created_at": "2023-01-01T00:00:00Z",
      "updated_at": "2023-01-01T00:00:00Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  },
  "message": "注册成功"
}
```

### 2.2 用户登录

**请求方式**：POST
**请求URL**：`/users/login`
**认证要求**：不需要

#### 请求参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| email | string | 是 | 用户邮箱 |
| password | string | 是 | 用户密码 |

#### 示例请求
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "user": {
      "id": "123456",
      "email": "user@example.com",
      "name": "John Doe",
      "avatar": null,
      "created_at": "2023-01-01T00:00:00Z",
      "updated_at": "2023-01-01T00:00:00Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  },
  "message": "登录成功"
}
```

### 2.3 密码重置

**请求方式**：POST
**请求URL**：`/users/reset-password`
**认证要求**：不需要

#### 请求参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| email | string | 是 | 用户邮箱 |

#### 示例请求
```json
{
  "email": "user@example.com"
}
```

#### 示例响应
```json
{
  "status": "success",
  "data": null,
  "message": "密码重置邮件已发送"
}
```

### 2.4 获取当前用户信息

**请求方式**：GET
**请求URL**：`/users/me`
**认证要求**：需要Bearer Token

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "user": {
      "id": "123456",
      "email": "user@example.com",
      "name": "John Doe",
      "avatar": "https://example.com/avatar.jpg",
      "created_at": "2023-01-01T00:00:00Z",
      "updated_at": "2023-01-01T00:00:00Z"
    }
  },
  "message": "获取成功"
}
```

### 2.5 更新用户信息

**请求方式**：PUT
**请求URL**：`/users/me`
**认证要求**：需要Bearer Token

#### 请求参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| name | string | 否 | 用户名称 |
| avatar | string | 否 | 用户头像URL |

#### 示例请求
```json
{
  "name": "Jane Doe",
  "avatar": "https://example.com/avatar2.jpg"
}
```

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "user": {
      "id": "123456",
      "email": "user@example.com",
      "name": "Jane Doe",
      "avatar": "https://example.com/avatar2.jpg",
      "created_at": "2023-01-01T00:00:00Z",
      "updated_at": "2023-01-02T00:00:00Z"
    }
  },
  "message": "更新成功"
}
```

### 2.6 用户登出

**请求方式**：POST
**请求URL**：`/users/logout`
**认证要求**：需要Bearer Token

#### 示例响应
```json
{
  "status": "success",
  "data": null,
  "message": "登出成功"
}
```

## 3. 日程相关API

### 3.1 获取日程列表

**请求方式**：GET
**请求URL**：`/schedule`
**认证要求**：需要Bearer Token

#### 查询参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| start_date | string | 否 | 开始日期（YYYY-MM-DD） |
| end_date | string | 否 | 结束日期（YYYY-MM-DD） |
| type | string | 否 | 日程类型 |
| page | integer | 否 | 页码，默认1 |
| limit | integer | 否 | 每页数量，默认10 |

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "schedule_events": [
      {
        "id": 1,
        "title": "晨跑",
        "description": "每天早上6点晨跑30分钟",
        "start_time": "2023-01-01T06:00:00Z",
        "end_time": "2023-01-01T06:30:00Z",
        "type": "running",
        "is_completed": false,
        "created_at": "2023-01-01T00:00:00Z",
        "updated_at": "2023-01-01T00:00:00Z"
      }
    ],
    "pagination": {
      "total": 1,
      "page": 1,
      "limit": 10,
      "total_pages": 1
    }
  },
  "message": "获取成功"
}
```

### 3.2 创建日程

**请求方式**：POST
**请求URL**：`/schedule`
**认证要求**：需要Bearer Token

#### 请求参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| title | string | 是 | 日程标题 |
| description | string | 否 | 日程描述 |
| start_time | string | 是 | 开始时间（ISO 8601格式） |
| end_time | string | 是 | 结束时间（ISO 8601格式） |
| type | string | 是 | 日程类型 |
| is_completed | boolean | 否 | 是否完成，默认false |

#### 示例请求
```json
{
  "title": "晨跑",
  "description": "每天早上6点晨跑30分钟",
  "start_time": "2023-01-01T06:00:00Z",
  "end_time": "2023-01-01T06:30:00Z",
  "type": "running",
  "is_completed": false
}
```

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "schedule_event": {
      "id": 1,
      "title": "晨跑",
      "description": "每天早上6点晨跑30分钟",
      "start_time": "2023-01-01T06:00:00Z",
      "end_time": "2023-01-01T06:30:00Z",
      "type": "running",
      "is_completed": false,
      "created_at": "2023-01-01T00:00:00Z",
      "updated_at": "2023-01-01T00:00:00Z"
    }
  },
  "message": "创建成功"
}
```

### 3.3 获取单个日程

**请求方式**：GET
**请求URL**：`/schedule/:id`
**认证要求**：需要Bearer Token

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "schedule_event": {
      "id": 1,
      "title": "晨跑",
      "description": "每天早上6点晨跑30分钟",
      "start_time": "2023-01-01T06:00:00Z",
      "end_time": "2023-01-01T06:30:00Z",
      "type": "running",
      "is_completed": false,
      "created_at": "2023-01-01T00:00:00Z",
      "updated_at": "2023-01-01T00:00:00Z"
    }
  },
  "message": "获取成功"
}
```

### 3.4 更新日程

**请求方式**：PUT
**请求URL**：`/schedule/:id`
**认证要求**：需要Bearer Token

#### 请求参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| title | string | 否 | 日程标题 |
| description | string | 否 | 日程描述 |
| start_time | string | 否 | 开始时间（ISO 8601格式） |
| end_time | string | 否 | 结束时间（ISO 8601格式） |
| type | string | 否 | 日程类型 |
| is_completed | boolean | 否 | 是否完成 |

#### 示例请求
```json
{
  "title": "晨跑更新",
  "is_completed": true
}
```

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "schedule_event": {
      "id": 1,
      "title": "晨跑更新",
      "description": "每天早上6点晨跑30分钟",
      "start_time": "2023-01-01T06:00:00Z",
      "end_time": "2023-01-01T06:30:00Z",
      "type": "running",
      "is_completed": true,
      "created_at": "2023-01-01T00:00:00Z",
      "updated_at": "2023-01-02T00:00:00Z"
    }
  },
  "message": "更新成功"
}
```

### 3.5 删除日程

**请求方式**：DELETE
**请求URL**：`/schedule/:id`
**认证要求**：需要Bearer Token

#### 示例响应
```json
{
  "status": "success",
  "data": null,
  "message": "删除成功"
}
```

## 4. 统计相关API

### 4.1 获取统计概览

**请求方式**：GET
**请求URL**：`/statistics`
**认证要求**：需要Bearer Token

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "statistics": {
      "total_workouts": 10,
      "total_minutes": 300,
      "total_calories": 3000,
      "weekly_data": {
        "labels": ["周一", "周二", "周三", "周四", "周五", "周六", "周日"],
        "workouts": [1, 2, 1, 0, 2, 2, 2],
        "minutes": [30, 60, 30, 0, 60, 60, 60],
        "calories": [300, 600, 300, 0, 600, 600, 600]
      },
      "monthly_data": {
        "labels": ["1月", "2月", "3月", "4月", "5月", "6月"],
        "workouts": [10, 12, 8, 15, 18, 20],
        "minutes": [300, 360, 240, 450, 540, 600],
        "calories": [3000, 3600, 2400, 4500, 5400, 6000]
      },
      "yearly_data": {
        "labels": ["2022", "2023"],
        "workouts": [100, 120],
        "minutes": [3000, 3600],
        "calories": [30000, 36000]
      }
    }
  },
  "message": "获取成功"
}
```

### 4.2 获取周统计数据

**请求方式**：GET
**请求URL**：`/statistics/weekly`
**认证要求**：需要Bearer Token

#### 查询参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| year | integer | 否 | 年份，默认当前年份 |
| week | integer | 否 | 周数，默认当前周数 |

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "weekly_statistics": {
      "year": 2023,
      "week": 1,
      "labels": ["周一", "周二", "周三", "周四", "周五", "周六", "周日"],
      "workouts": [1, 2, 1, 0, 2, 2, 2],
      "minutes": [30, 60, 30, 0, 60, 60, 60],
      "calories": [300, 600, 300, 0, 600, 600, 600]
    }
  },
  "message": "获取成功"
}
```

### 4.3 获取月统计数据

**请求方式**：GET
**请求URL**：`/statistics/monthly`
**认证要求**：需要Bearer Token

#### 查询参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| year | integer | 否 | 年份，默认当前年份 |
| month | integer | 否 | 月份，默认当前月份 |

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "monthly_statistics": {
      "year": 2023,
      "month": 1,
      "labels": ["1日", "2日", "3日", "4日", "5日", "6日", "7日"],
      "workouts": [1, 2, 1, 0, 2, 2, 2],
      "minutes": [30, 60, 30, 0, 60, 60, 60],
      "calories": [300, 600, 300, 0, 600, 600, 600]
    }
  },
  "message": "获取成功"
}
```

### 4.4 获取年统计数据

**请求方式**：GET
**请求URL**：`/statistics/yearly`
**认证要求**：需要Bearer Token

#### 查询参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| year | integer | 否 | 年份，默认当前年份 |

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "yearly_statistics": {
      "year": 2023,
      "labels": ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
      "workouts": [10, 12, 8, 15, 18, 20, 0, 0, 0, 0, 0, 0],
      "minutes": [300, 360, 240, 450, 540, 600, 0, 0, 0, 0, 0, 0],
      "calories": [3000, 3600, 2400, 4500, 5400, 6000, 0, 0, 0, 0, 0, 0]
    }
  },
  "message": "获取成功"
}
```

## 5. 天气相关API

### 5.1 获取当前天气

**请求方式**：GET
**请求URL**：`/weather/current`
**认证要求**：需要API Key或Bearer Token

#### 查询参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| city | string | 是 | 城市名称 |
| lat | float | 否 | 纬度（与city二选一） |
| lon | float | 否 | 经度（与city二选一） |
| units | string | 否 | 单位，默认metric（摄氏度），可选imperial（华氏度） |

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "weather": {
      "city": "北京",
      "temperature": 20.5,
      "description": "晴朗",
      "icon": "01d",
      "humidity": 60,
      "wind_speed": 3.5,
      "updated_at": "2023-01-01T00:00:00Z"
    }
  },
  "message": "获取成功"
}
```

### 5.2 获取天气预报

**请求方式**：GET
**请求URL**：`/weather/forecast`
**认证要求**：需要API Key或Bearer Token

#### 查询参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| city | string | 是 | 城市名称 |
| lat | float | 否 | 纬度（与city二选一） |
| lon | float | 否 | 经度（与city二选一） |
| days | integer | 否 | 预报天数，默认7天，最多14天 |
| units | string | 否 | 单位，默认metric（摄氏度），可选imperial（华氏度） |

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "forecast": {
      "city": "北京",
      "days": [
        {
          "date": "2023-01-01T00:00:00Z",
          "temperature": 20.5,
          "description": "晴朗",
          "icon": "01d",
          "humidity": 60,
          "wind_speed": 3.5
        }
      ]
    }
  },
  "message": "获取成功"
}
```

## 6. 健康数据相关API

### 6.1 添加健康数据

**请求方式**：POST
**请求URL**：`/health-data`
**认证要求**：需要Bearer Token

#### 请求参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| type | string | 是 | 数据类型（weight, height, steps, calories, etc.） |
| value | float | 是 | 数据值 |
| recorded_at | string | 否 | 记录时间（ISO 8601格式），默认当前时间 |

#### 示例请求
```json
{
  "type": "weight",
  "value": 70.5,
  "recorded_at": "2023-01-01T00:00:00Z"
}
```

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "health_data": {
      "id": 1,
      "type": "weight",
      "value": 70.5,
      "recorded_at": "2023-01-01T00:00:00Z",
      "created_at": "2023-01-01T00:00:00Z",
      "updated_at": "2023-01-01T00:00:00Z"
    }
  },
  "message": "添加成功"
}
```

### 6.2 获取健康数据

**请求方式**：GET
**请求URL**：`/health-data`
**认证要求**：需要Bearer Token

#### 查询参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| type | string | 否 | 数据类型 |
| start_date | string | 否 | 开始日期（YYYY-MM-DD） |
| end_date | string | 否 | 结束日期（YYYY-MM-DD） |
| page | integer | 否 | 页码，默认1 |
| limit | integer | 否 | 每页数量，默认10 |

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "health_data": [
      {
        "id": 1,
        "type": "weight",
        "value": 70.5,
        "recorded_at": "2023-01-01T00:00:00Z",
        "created_at": "2023-01-01T00:00:00Z",
        "updated_at": "2023-01-01T00:00:00Z"
      }
    ],
    "pagination": {
      "total": 1,
      "page": 1,
      "limit": 10,
      "total_pages": 1
    }
  },
  "message": "获取成功"
}
```

## 7. 通知相关API

### 7.1 获取通知列表

**请求方式**：GET
**请求URL**：`/notifications`
**认证要求**：需要Bearer Token

#### 查询参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| is_read | boolean | 否 | 是否已读 |
| page | integer | 否 | 页码，默认1 |
| limit | integer | 否 | 每页数量，默认10 |

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "notifications": [
      {
        "id": 1,
        "title": "日程提醒",
        "message": "您有一个日程即将开始：晨跑",
        "type": "schedule_reminder",
        "is_read": false,
        "created_at": "2023-01-01T05:30:00Z",
        "updated_at": "2023-01-01T05:30:00Z"
      }
    ],
    "pagination": {
      "total": 1,
      "page": 1,
      "limit": 10,
      "total_pages": 1
    }
  },
  "message": "获取成功"
}
```

### 7.2 标记通知为已读

**请求方式**：PUT
**请求URL**：`/notifications/:id/read`
**认证要求**：需要Bearer Token

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "notification": {
      "id": 1,
      "title": "日程提醒",
      "message": "您有一个日程即将开始：晨跑",
      "type": "schedule_reminder",
      "is_read": true,
      "created_at": "2023-01-01T05:30:00Z",
      "updated_at": "2023-01-01T05:30:00Z"
    }
  },
  "message": "更新成功"
}
```

### 7.3 删除通知

**请求方式**：DELETE
**请求URL**：`/notifications/:id`
**认证要求**：需要Bearer Token

#### 示例响应
```json
{
  "status": "success",
  "data": null,
  "message": "删除成功"
}
```

## 8. 第三方集成API

### 8.1 Google登录

**请求方式**：POST
**请求URL**：`/auth/google`
**认证要求**：不需要

#### 请求参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| id_token | string | 是 | Google ID Token |

#### 示例请求
```json
{
  "id_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "user": {
      "id": "123456",
      "email": "user@gmail.com",
      "name": "John Doe",
      "avatar": "https://example.com/avatar.jpg",
      "created_at": "2023-01-01T00:00:00Z",
      "updated_at": "2023-01-01T00:00:00Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  },
  "message": "登录成功"
}
```

### 8.2 Apple登录

**请求方式**：POST
**请求URL**：`/auth/apple`
**认证要求**：不需要

#### 请求参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| identity_token | string | 是 | Apple Identity Token |
| user | object | 否 | Apple User Info |

#### 示例请求
```json
{
  "identity_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "email": "user@icloud.com",
    "name": {
      "firstName": "John",
      "lastName": "Doe"
    }
  }
}
```

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "user": {
      "id": "123456",
      "email": "user@icloud.com",
      "name": "John Doe",
      "avatar": null,
      "created_at": "2023-01-01T00:00:00Z",
      "updated_at": "2023-01-01T00:00:00Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  },
  "message": "登录成功"
}
```

## 9. 管理API

### 9.1 获取用户列表

**请求方式**：GET
**请求URL**：`/admin/users`
**认证要求**：需要Bearer Token（管理员权限）

#### 查询参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| email | string | 否 | 用户邮箱（模糊查询） |
| name | string | 否 | 用户名称（模糊查询） |
| is_active | boolean | 否 | 是否激活 |
| page | integer | 否 | 页码，默认1 |
| limit | integer | 否 | 每页数量，默认10 |

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "users": [
      {
        "id": "123456",
        "email": "user@example.com",
        "name": "John Doe",
        "avatar": null,
        "is_active": true,
        "created_at": "2023-01-01T00:00:00Z",
        "updated_at": "2023-01-01T00:00:00Z"
      }
    ],
    "pagination": {
      "total": 1,
      "page": 1,
      "limit": 10,
      "total_pages": 1
    }
  },
  "message": "获取成功"
}
```

### 9.2 禁用/启用用户

**请求方式**：PUT
**请求URL**：`/admin/users/:id/status`
**认证要求**：需要Bearer Token（管理员权限）

#### 请求参数

| 参数名 | 类型 | 必须 | 描述 |
|-------|------|------|------|
| is_active | boolean | 是 | 是否激活 |

#### 示例请求
```json
{
  "is_active": false
}
```

#### 示例响应
```json
{
  "status": "success",
  "data": {
    "user": {
      "id": "123456",
      "email": "user@example.com",
      "name": "John Doe",
      "avatar": null,
      "is_active": false,
      "created_at": "2023-01-01T00:00:00Z",
      "updated_at": "2023-01-02T00:00:00Z"
    }
  },
  "message": "更新成功"
}
```

## 10. 附录

### 10.1 API版本控制

- **v1**：当前版本

### 10.2 速率限制

- **认证API**：60次/分钟/IP
- **普通API**：100次/分钟/用户
- **管理API**：50次/分钟/管理员

### 10.3 WebSocket API

Life Fit还提供WebSocket API，用于实时通知和数据更新。

**连接URL**：`wss://api.lifefit.example.com/ws/v1`

**认证方式**：在URL中包含令牌，如：`wss://api.lifefit.example.com/ws/v1?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

**支持的事件**：
- `schedule_reminder`：日程提醒
- `notification`：新通知
- `health_data_update`：健康数据更新
- `weather_update`：天气更新

### 10.4 SDK支持

Life Fit提供多种语言的SDK，便于开发者集成API：
- **Flutter SDK**：适用于Flutter应用
- **JavaScript SDK**：适用于Web应用
- **iOS SDK**：适用于原生iOS应用
- **Android SDK**：适用于原生Android应用

### 10.5 支持与反馈

如有API相关问题或建议，可通过以下方式联系我们：
- **API文档**：https://docs.lifefit.example.com/api
- **支持邮箱**：api-support@lifefit.example.com
- **开发者社区**：https://community.lifefit.example.com
