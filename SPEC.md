# Leaf - 新能源汽车内容平台

## 1. 项目概述

**项目名称**: Leaf (叶子)
**包名**: com.leaflife.app
**品牌色**: #00C853 (环保绿)
**风格**: 懂车帝深色风格 - 大图/视频封面 + 卡片网格

**核心定位**: 新能源汽车内容分享平台，国内用户输出经验供国外用户参考。
**内容形式**: 视频/图片 + 文字说明
**变现方式**: 汽车周边商城（后期）

---

## 2. 技术栈

| 类别 | 技术 |
|------|------|
| 框架 | Flutter 3.41.7 |
| 语言 | Dart 3.11.5 |
| 状态管理 | flutter_bloc |
| 架构 | Clean Architecture |
| 地图 | flutter_map + OpenStreetMap (免费，无API Key) |
| DI | get_it |
| 包名 | com.leaflife.app |

---

## 3. 功能列表

### 3.1 主页 (Home) ✅
- [x] 分类Tab：推荐/新能源/热门/问题解决/保养
- [x] 搜索栏
- [x] 热门内容Banner
- [x] 内容卡片网格
- [x] 下拉刷新
- [x] BLoC状态管理
- [x] Mock数据（8条真实EV内容）

### 3.2 内容发布 ✅
- [x] 标题+内容输入
- [x] 分类选择（经验/技巧/问题解决/保养）
- [x] 车型标签
- [x] 图片选择（ImagePicker）
- [x] 视频选择（ImagePicker）
- [x] BLoC驱动发布状态
- [x] 发布成功/失败提示
- [ ] Firebase Firestore 上传（待配置）

### 3.3 问答功能 ✅
- [x] 问题列表展示（6条真实QA）
- [x] 视频/图文回答标记
- [x] 点赞/评论数
- [x] 发起提问 BottomSheet
- [x] FAB快速提问按钮

### 3.4 充电桩地图 ✅
- [x] OpenStreetMap 真实地图（无API Key）
- [x] 5个充电站标记（北京数据）
- [x] 筛选Chip（全部/快充/慢充/免费/24小时）
- [x] 点击标记显示详情
- [x] 充电站卡片横向滚动
- [x] 导航按钮
- [x] 定位回中心按钮

### 3.5 车型对比 ✅
- [x] 多车型参数对比
- [x] 添加车型按钮
- [x] 参数行对比（续航/快充/加速/电池等）
- [x] 分享/预约试驾按钮

### 3.6 个人中心 ✅
- [x] 用户信息展示
- [x] 数据统计（发布/关注/粉丝/获赞）
- [x] 菜单列表（我的内容/互动/车辆/其他）
- [x] 设置页面（含账号/显示/隐私/支持/退出登录）

### 3.7 搜索功能 ✅
- [x] 搜索栏
- [x] 热门搜索（7个标签）
- [x] 搜索历史（SharedPreferences持久化）
- [x] 清除历史
- [x] 搜索结果展示
- [x] 快捷入口网格

### 3.8 国际化
- [ ] ML Kit 设备端翻译（需要 Firebase 配置）

---

## 4. UI 设计

### 颜色
- 主色: #00C853 (Leaf Green)
- 深色背景: #121212
- 卡片背景: #1E1E1E / #252525
- 文字: #FFFFFF / #B0B0B0 / #666666

### 布局
- 底部 Tab 导航（首页/充电/对比/问答/我的）
- 中央悬浮 FAB 发布按钮
- 深色沉浸式主题
- 大图/视频优先
- 卡片网格布局

---

## 5. 项目结构

```
leaf/
├── lib/
│   ├── main.dart                          ✅ 主入口（BLoC+DI）
│   ├── core/
│   │   ├── di/injection_container.dart   ✅ DI容器
│   │   └── theme/app_theme.dart          ✅ 深色主题
│   ├── data/
│   │   ├── models/post.dart              ✅ 数据模型
│   │   └── mock/mock_posts.dart          ✅ Mock数据
│   └── features/
│       ├── home/presentation/
│       │   ├── bloc/                     ✅ HomeBloc
│       │   └── pages/
│       │       ├── main_page.dart        ✅ 底部导航+FAB
│       │       ├── home_tab.dart          ✅ 首页
│       │       ├── search_tab.dart        ✅ 搜索
│       │       ├── qa_tab.dart            ✅ 问答
│       │       └── profile_tab.dart        ✅ 我的
│       ├── charging/presentation/
│       │   └── pages/charging_map_tab.dart  ✅ 充电桩地图
│       ├── comparison/presentation/
│       │   └── pages/car_comparison_tab.dart ✅ 车型对比
│       ├── publish/presentation/
│       │   ├── bloc/                     ✅ PublishBloc
│       │   └── pages/publish_page.dart   ✅ 发布页
│       └── settings/presentation/
│           └── pages/settings_page.dart   ✅ 设置页
├── build/web/                            ✅ Web构建产物
├── pubspec.yaml
└── SPEC.md
```

---

## 6. 已知问题

1. **翻译功能** - 需要 Firebase + ML Kit 配置（`google-services.json`）
2. **用户认证** - 需要 Firebase Auth 配置
3. **内容发布上传** - 需要 Firebase Storage 配置
4. **Android 打包** - 需要 Visual Studio "Desktop development with C++"
5. **Windows 桌面** - 需要 Visual Studio

---

## 7. 下一步（需要你介入）

1. 提供 `google-services.json` → 启用 Firebase（翻译/认证/存储）
2. 安装 Visual Studio → 打包 Windows/Android

---

*最后更新: 2026-04-22*