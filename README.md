# luamris_ui

> Apple 风格 Flutter UI 组件库，基于 Cupertino，原生支持亮色 / 暗色模式。
>
> 为 LuamrisTeam 的课表、校园集市等 Flutter App 提供一致的设计语言。

---

## 安装

```yaml
# pubspec.yaml
dependencies:
  luamris_ui:
    git:
      url: https://github.com/YoChine-Lanee/luamris_ui
      ref: v0.2.0
```

```dart
import 'package:luamris_ui/luamris_ui.dart';
```

> 零额外状态管理依赖。开箱即用。

---

## 快速上手

```dart
import 'package:flutter/cupertino.dart';
import 'package:luamris_ui/luamris_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      themeMode: _themeMode, // ← 原生切换，自动通知整棵树
      home: HomePage(
        onToggleTheme: () {
          setState(() {
            _themeMode = _themeMode == ThemeMode.dark
                ? ThemeMode.light
                : ThemeMode.dark;
          });
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.onToggleTheme});

  final VoidCallback? onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return McPageScaffold(
      title: '我的课表',
      child: Column(
        children: [
          McButton.primary(
            onPressed: () {},
            child: const Text('添加课程'),
          ),
          const SizedBox(height: 12),
          McCard.glass(
            child: McListTile(
              title: const Text('高等数学'),
              subtitle: const Text('周一 8:00–9:40 · 教三楼 101'),
            ),
          ),
          const SizedBox(height: 8),
          McEmpty.placeholder(
            icon: CupertinoIcons.calendar_badge_plus,
            title: '暂无课程',
            description: '点击上方按钮开始创建课表',
          ),
        ],
      ),
    );
  }
}
```

---

## 设计理念

**只记一个入口：`context.mc`。** 所有颜色、字体、圆角、阴影、装饰全部通过 `context.mc.xxx` 获取，暗色模式自动跟随 `CupertinoApp.themeMode`。

```dart
final bg   = context.mc.background;  // Color，自动跟随亮/暗
final card = context.mc.cardDecoration(); // BoxDecoration
final text = context.mc.textTitle;   // TextStyle
final r    = context.mc.radiusLg;    // 16
```

---

## 组件

### 页面

| 组件 | 说明 |
|------|------|
| `McPageScaffold` | 全页脚手架，large / compact 导航栏，响应式居中，支持底部固定栏 |

### 按钮 — `McButton`

| 构造 | 说明 |
|------|------|
| `.primary(onPressed:, child:)` | 实心主按钮，禁用自动变灰 |
| `.secondary(onPressed:, child:)` | 次要按钮，muted 背景 |
| `.ghost(onPressed:, child:)` | 透明按钮，仅文字 |
| `.danger(onPressed:, child:)` | 红色危险操作按钮 |

### 卡片 — `McCard`

| 构造 | 说明 |
|------|------|
| `.glass(child:)` | 毛玻璃卡片，内置 `BackdropFilter` |
| `.elevated(child:, onPressed:)` | 标准卡片 + 阴影，可点击 |
| `.flat(child:, onPressed:)` | 卡片 + 边框，无阴影 |

### 标签 — `McBadge`

| 构造 | 说明 |
|------|------|
| `McBadge(child:)` / `.neutral(child:)` | 默认/中性徽章 |
| `.success(child:)` | 绿色成功标签 |
| `.warning(child:)` | 橙色警告标签 |
| `.error(child:)` | 红色错误标签 |

### 列表 & 统计

| 组件 | 说明 |
|------|------|
| `McListTile` | 列表行：标题 + 副标题 + 可选 leading / trailing，支持点击 |
| `McStatChip` | 图标 + 文字统计 chip（点赞数、浏览数等） |

### 状态 — `McEmpty`

| 构造 | 说明 |
|------|------|
| `.placeholder(icon:, title:, description:)` | 空状态：图标 + 标题 + 描述 |
| `.retry(title:, description:, onRetry:)` | 错误重试状态，自动带重试按钮 |

### 表单 — `McField`

| 构造 | 说明 |
|------|------|
| `.text(placeholder:, validator:)` | 文本输入框，内建验证、错误提示、最大长度 |
| `.password(placeholder:, validator:)` | 密码框，带 👁 可见性切换 |

### 头像 & 图片

| 组件 | 说明 |
|------|------|
| `McAvatar` | 支持网络图片（PNG / JPEG / SVG / DiceBear），首字母回退 |
| `McNetworkImage` | 磁盘缓存网络图片，自动计算内存缓存分辨率 |

### 弹出层

| 函数 | 说明 |
|------|------|
| `showMcBottomSheet` | 毛玻璃底部弹出层，手机滑入，平板居中 |
| `McFeedback.showInfo()` | 信息 Toast（蓝色），3 秒消失 |
| `McFeedback.showSuccess()` | 成功 Toast（绿色），3 秒消失 |
| `McFeedback.showError()` | 错误 Toast（红色），3 秒消失 |
| `McFeedback.confirm()` | 确认对话框，返回 `true` / `false` / `null`（取消） |

### 响应式布局

| 类 | 说明 |
|------|------|
| `McBreakpoints` | 断点：`tablet` = 768，`desktop` = 1100 |
| `McResponsive` | `isPhone` / `isTablet` / `isDesktop`、内容宽度、padding |
| `McResponsiveCenter` | 居中 + 最大宽度 + 响应式 padding |
| `McResponsiveSliverPadding` | Sliver 版响应式居中 |
| `McTwoPane` | 双栏布局：手机堆叠，宽屏并排 |

---

## Design Tokens

所有 Token 通过 `context.mc.xxx` 统一访问，亮/暗自动适配。

### 颜色 `context.mc.xxx`

| Token | 亮色 | 暗色 |
|-------|------|------|
| `.primary` | `#0071E3` | `#0071E3` |
| `.primaryForeground` | `#FFFFFF` | `#FFFFFF` |
| `.background` | `#FFFFFF` | `#000000` |
| `.foreground` | `#1D1D1F` | `#F5F5F7` |
| `.card` | `#FFFFFF` | `#1C1C1E` |
| `.secondary` | `#F5F5F7` | `#2C2C2E` |
| `.mutedForeground` | `#86868B` | `#86868B` |
| `.border` | `#E5E5E7` | `#2C2C2E` |
| `.destructive` | `#FF3B30` | `#FF453A` |
| `.hot` | `#FF7A00` | `#FF7A00` |

### 字体 `context.mc.textXxx`

| Token | 字号 | 字重 | 用途 |
|------|------|------|------|
| `.textHero` | 32 | w800 | 大标题 |
| `.textTitle` | 24 | w700 | 页面标题 |
| `.textSection` | 18 | w700 | 区块标题 |
| `.textBody` | 16 | normal | 正文 |
| `.textMuted` | 14 | normal | 说明文字 |
| `.textLabel` | 12 | w600 | 标签 / 徽章 |

### 圆角 `context.mc.radiusXxx`

| Token | 值 | 用途 |
|-------|-----|------|
| `.radiusSm` | 8 | 小组件 |
| `.radiusMd` | 12 | 头像、图片 |
| `.radiusLg` | 16 | 按钮、输入框 |
| `.radiusXl` | 24 | 卡片、弹出层 |
| `.radiusXxl` | 32 | 大面积表面 |
| `.radiusPill` | 999 | 徽章、chip |

### 装饰 `context.mc.xxxDecoration()`

| 方法 | 说明 |
|------|------|
| `.cardDecoration()` | 标准卡片背景 + 细边框 |
| `.mutedDecoration()` | 次要背景 |
| `.glassDecoration()` | 毛玻璃表面 |
| `.pillDecoration()` | 药丸形容器 |

---

## 主题切换

直接使用 Flutter 原生的 `CupertinoApp.themeMode`，`context.mc` 自动跟随。

```dart
class MyApp extends StatefulWidget { ... }

class _MyAppState extends State<MyApp> {
  ThemeMode _mode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      themeMode: _mode,
      home: CupertinoButton(
        onPressed: () {
          setState(() {
            _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
          });
        },
        child: Icon(_mode == ThemeMode.dark
            ? CupertinoIcons.moon_fill
            : CupertinoIcons.sun_max_fill),
      ),
    );
  }
}
```

---

## License

MIT
