# luamris_ui

> Apple 风格 Flutter UI 组件库，同时支持 **Material** 与 **Cupertino** 应用框架，原生亮色 / 暗色模式。
>
> 为 LuamrisTeam 的课表、校园集市等 Flutter App 提供一致的设计语言。

---

## 安装

```yaml
# pubspec.yaml
dependencies:
  luamris_ui:
    git:
      url: https://github.com/LumarisTeam/luamris_ui
      ref: v0.4.0
```

```dart
import 'package:luamris_ui/luamris_ui.dart';
```

> 零额外状态管理依赖。开箱即用。

---

## 快速上手

### Cupertino 应用（推荐 iOS 风格）

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
      builder: (context, child) => McThemeData.wrap(child: child!), // ← 注入主题
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
```

### Material 应用

```dart
import 'package:flutter/material.dart';
import 'package:luamris_ui/luamris_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: McThemeData.materialTheme(McColors.light),     // ← 浅色主题
      darkTheme: McThemeData.materialTheme(McColors.dark),  // ← 深色主题
      home: const HomePage(),
    );
  }
}
```

> `McThemeData.materialTheme()` 自动配置 `ColorScheme`、`AppBarTheme`、`CardTheme`、`InputDecorationTheme` 等全部组件主题，无需额外设置。

### 页面示例

```dart
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

**只记一个入口：`context.mc`。** 所有颜色、字体、圆角、阴影、装饰全部通过 `context.mc.xxx` 获取，暗色模式自动跟随。

```dart
final bg      = context.mc.background;   // Color，自动跟随亮/暗
final card    = context.mc.cardDecoration(); // BoxDecoration
final title   = context.mc.textTitle;    // TextStyle
final r       = context.mc.radiusLg;     // 16
final primary = context.mc.primary;      // Color，主色调
```

---

## 组件

### 页面

| 组件 | 说明 |
|------|------|
| `McPageScaffold` | 全页脚手架，large / compact 导航栏，响应式居中，支持底部固定栏；默认使用 `groupedBackground` 页面背景（可用 `backgroundColor:` 覆盖） |

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
| `.grouped(child:)` | 零内边距分组卡片，用于承载 `McListTile` 设置列表 |

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
| `McListTile` | 列表行：标题 + 副标题 + leading / trailing，支持点击、长按、选中、禁用、内建 chevron、自定义圆角与文字样式 |
| `McStatChip` | 图标 + 文字统计 chip（点赞数、浏览数等） |

```dart
McCard.grouped(
  child: Column(
    children: [
      McListTile(
        title: const Text('通知'),
        showChevron: true,
        onTap: () {},
      ),
      McListTile(
        title: const Text('当前选中项'),
        selected: true,
        onTap: () {},
      ),
      McListTile(
        title: const Text('禁用项'),
        enabled: false,
      ),
    ],
  ),
);
```

### 状态 — `McEmpty`

| 构造 | 说明 |
|------|------|
| `.placeholder(icon:, title:, description:)` | 空状态：图标 + 标题 + 描述 |
| `.retry(title:, description:, onRetry:)`) | 错误重试状态，自动带重试按钮 |

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
| `McFeedback.confirm()` | 确认对话框（旧入口），返回 `true` / `false` / `null` |
| `showMcConfirmDialog()` | 增强确认框：标题、内容、危险样式、自定义按钮文案 |
| `showMcInputDialog()` | 输入框对话框，返回 `String?`，支持密码、初始值、键盘类型 |
| `showMcDialog<T>()` | 通用多操作对话框，支持任意返回值、异步回调、`autoPop` |

所有对话框沿用同一套玻璃拟态视觉（`BackdropFilter` + 半透明表面 + 圆角按钮）。

```dart
final ok = await showMcConfirmDialog(
  context,
  title: '删除确认',
  message: '此操作无法撤销，确定要删除吗？',
  cancelText: '取消',
  confirmText: '删除',
  destructive: true,
);

final name = await showMcInputDialog(
  context,
  title: '修改昵称',
  hintText: '请输入昵称',
  cancelText: '取消',
  confirmText: '保存',
);
```

> 需要 iOS 原生动作表时，直接使用 Flutter 的 `showCupertinoModalPopup` + `CupertinoActionSheet`。

### 下拉菜单 — `McPopoverMenu`

iOS 原生菜单风格的下拉列表。基于 `OverlayEntry` +
`CompositedTransformTarget` / `CompositedTransformFollower` 实现，菜单会跟随触发控件移动。

- 点击触发控件在附近弹出，点击外部或选中后关闭
- 下方空间不足时自动翻到上方；左右越界时自动翻转 / 平移；空间过小时内部可滚动
- 支持选中勾选、危险项、禁用项、图标
- 菜单宽度、圆角、背景、阴影、动画均可自定义
- `matchTriggerWidth` 让菜单与触发控件等宽，适合下拉选择框

```dart
int _term = 0;

McPopoverMenu<int>(
  items: const [
    McPopoverMenuItem(value: 0, label: '第一学期'),
    McPopoverMenuItem(value: 1, label: '第二学期', icon: CupertinoIcons.calendar),
    McPopoverMenuItem(value: 2, label: '第三学期'),
  ],
  selectedValue: _term,
  matchTriggerWidth: true,
  // 可选：自定义外观 / 动画
  // width: 240,
  // radius: McRadii.card,
  // backgroundColor: context.mc.card.withValues(alpha: 0.92),
  // animationDuration: const Duration(milliseconds: 200),
  onSelected: (value) => setState(() => _term = value),
  child: const MyTrigger(),
);
```

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `items` | — | `McPopoverMenuItem<T>` 列表 |
| `selectedValue` | `null` | 选中项的值，用于勾选图标与选中底色 |
| `matchTriggerWidth` | `false` | 菜单宽度等于触发控件宽度 |
| `width` | `224` | 菜单宽度（`matchTriggerWidth` 为 true 时忽略） |
| `radius` | `McRadii.card` | 菜单圆角 |
| `backgroundColor` | 半透明卡片色 | 菜单背景 |
| `barrierColor` | 透明 | 菜单后方的遮罩色 |
| `shadows` | 柔和投影 | 自定义阴影 |
| `offset` | `Offset(0, 8)` | 与触发控件的间距；`dx` 会在限制到屏幕内之前先做水平微调 |
| `alignment` | `start` | 水平对齐：`start` / `center` / `end` |
| `showCheckmark` | `true` | 选中项是否显示勾选图标 |
| `animationDuration` | `170ms` | 打开 / 关闭动画时长 |
| `animationCurve` | `easeOutCubic` | 打开 / 关闭动画曲线 |
| `onOpenChanged` | — | 打开 / 开始关闭时回调，可用于旋转箭头 |

> `child` 是触发控件本身，请不要再给它挂 `onTap`；菜单的 `GestureDetector` 会接管点击。

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

#### Accent（强调色）

| Token | 亮色 | 暗色 | 用途 |
|-------|------|------|------|
| `.primary` | `#007AFF` | `#0A84FF` | 主色调（iOS 系统蓝） |
| `.primarySoft` | `#007AFF` × 12% | `#0A84FF` × 15% | 主色软背景（选中 chip、图标底色） |
| `.primaryForeground` | `#FFFFFF` | `#FFFFFF` | 主色上的文字/图标 |

#### Surface（表面色）

| Token | 亮色 | 暗色 | 用途 |
|-------|------|------|------|
| `.background` | `#FFFFFF` | `#000000` | 应用背景 |
| `.groupedBackground` | `#F8F8F8` | `#000000` | 分组页面背景（`McPageScaffold` 默认） |
| `.card` | `#FFFFFF` | `#1C1C1E` | 卡片 / 浮层背景 |
| `.cardOverlay` | `#FFFFFF` × 70% | `#EBEBF5` × 12% | 悬浮/按压叠层 |
| `.cardForeground` | `#000000` | `#FFFFFF` | 卡片上的文字 |
| `.secondary` | `#F2F2F7` | `#2C2C2E` | 分组 / 次要背景 |
| `.secondaryForeground` | `#000000` | `#FFFFFF` | 次要背景上的文字 |
| `.muted` | `#EFEFF4` | `#242426` | 三级背景 |
| `.surfaceRaised` | `#F2F2F7` | `#2C2C2E` | 抬升表面 |
| `.surfaceMuted` | `#EFEFF4` | `#242426` | 内嵌控件表面 |
| `.surfaceSunken` | `#E5E5EA` | `#3A3A3C` | 凹陷表面 / 轨道 |

#### Text（文字色）

| Token | 亮色 | 暗色 | 用途 |
|-------|------|------|------|
| `.foreground` | `#000000` | `#FFFFFF` | 正文 / 主要文字 |
| `.secondaryLabel` | `#3C3C43` × 60% | `#EBEBF5` × 60% | 说明文字 |
| `.tertiaryLabel` | `#3C3C43` × 30% | `#EBEBF5` × 30% | 占位符 / 禁用文字 |
| `.quaternaryLabel` | `#3C3C43` × 18% | `#EBEBF5` × 18% | 最淡文字 |
| `.inverseLabel` | `#FFFFFF` | `#000000` | 反色文字 |

#### Divider（分隔色）

| Token | 亮色 | 暗色 | 用途 |
|-------|------|------|------|
| `.separator` | `#3C3C43` × 20% | `#545458` × 20% | 分割线（半透明细线） |
| `.border` | `#E5E5EA` | `#3A3A3C` | 细边框 |
| `.borderStrong` | `#D1D1D6` | `#545458` | 强边框 / 拖拽条 |
| `.input` | `#EFEFF4` | `#242426` | 输入框背景 |

#### Semantic（语义色）

| Token | 亮色 | 暗色 | 用途 |
|-------|------|------|------|
| `.success` | `#34C759` | `#30D158` | 成功 / 正向 |
| `.successSoft` | `#34C759` × 12% | `#30D158` × 15% | 成功色软背景 |
| `.warning` | `#FF9500` | `#FF9F0A` | 警告 / 注意 |
| `.warningSoft` | `#FF9500` × 12% | `#FF9F0A` × 15% | 警告色软背景 |
| `.destructive` | `#FF3B30` | `#FF453A` | 错误 / 危险 |
| `.dangerSoft` | `#FF3B30` × 12% | `#FF453A` × 15% | 危险色软背景 |
| `.hot` | `#FF7A00` | `#FF7A00` | 热门 / 趋势 |

#### Accent palette（多色板）

`indigo`、`purple`、`pink`、`cyan`、`yellow`，每个都有对应的 `...Soft` 软背景，亮/暗值取自 iOS 系统色板。

```dart
context.mc.indigo;      // #5856D6 / #5E5CE6
context.mc.indigoSoft;  // 12% / 15%
```

#### Effects（效果色）

| Token | 亮色 | 暗色 | 用途 |
|-------|------|------|------|
| `.onAccent` | `#FFFFFF` | `#FFFFFF` | 强调色上的文字 |
| `.selectionFill` | `#787880` × 12% | `#787880` × 20% | 列表选中 / 按压背景 |
| `.shadowColor` | `#000000` × 10% | 透明 | 卡片阴影 |
| `.skeletonBase` | `#EBEBF4` | `#2C2C2E` | 骨架屏底色 |
| `.skeletonHighlight` | `#F4F4F4` | `#3A3A3C` | 骨架屏高光 |

> iOS 风格别名也可用：`.appBackground`、`.cardBackground`、`.label`、`.danger`。
> `context.mc.mutedForeground` 作为 `secondaryLabel` 的语义别名仍可用。

### 字体 `context.mc.textXxx`

| Token | 字号 | 字重 | 行高 | 用途 |
|------|------|------|------|------|
| `.textHero` | 32 | w800 | 1.2 | 大标题 |
| `.textTitle` | 24 | w700 | 1.25 | 页面标题 |
| `.textSection` | 18 | w700 | 1.3 | 区块标题 |
| `.textBody` | 16 | normal | 1.5 | 正文 |
| `.textMuted` | 14 | normal | 1.4 | 说明文字 |
| `.textLabel` | 12 | w600 | - | 标签 / 徽章 |

> 也提供静态方法 `McTextStyles.hero(context)`、`McTextStyles.body(context)` 等。

### 圆角 `context.mc.radiusXxx`

| Token | 值 | 用途 |
|-------|-----|------|
| `.radiusXs` | 4 | 极小元素 |
| `.radiusSm` | 8 | 小组件 |
| `.radiusMd` | 12 | 头像、图片 |
| `.radiusLg` | 16 | 大控件 |
| `.radiusXl` | 24 | 对话框（保持原玻璃风格） |
| `.radiusXxl` | 32 | 大面积表面 |
| `.radiusPill` | 999 | 徽章、chip |
| `.radiusControl` | 8 | 图标容器、行内控件 |
| `.radiusNavigation` | 12 | 按钮、输入框、分段控件 |
| `.radiusPanel` | 16 | 大面板 |
| `.radiusCard` | 18 | 卡片、分组列表、列表行 |
| `.radiusTile` | 22 | 仪表盘大图块 |
| `.radiusSheetTop` | 18 | 底部弹层顶部圆角 |
| `.radiusHandle` | 2.5 | 拖拽条 |
| `.radiusIndicator` | 2 | 指示条 |

> 也提供静态常量 `McRadii.sm`、`McRadii.card`、`McRadii.cardBorder` 等。

### 平滑圆角 — `McSmoothCorners`

卡片、按钮、列表行、输入框、弹出层都使用 Apple 风格的平滑圆角（squircle）：

```dart
McSmoothCorners.shape(McRadii.cardBorder); // SmoothRectangleBorder
McSmoothCorners.clip(
  borderRadius: McRadii.cardBorder,
  child: child,
);
```

默认平滑度 `0.8`；存在可见描边或圆角 ≤ 12 时自动使用 `0.6`。对话框刻意保持普通 24px 圆角，以维持原有玻璃拟态外观。

### 阴影 `context.mc.shadowXxx`

| Token | 说明 |
|-------|------|
| `.shadowCard` | 默认卡片阴影 — 柔和模糊，微弱偏移 |
| `.shadowNone` | 无阴影（空列表） |

### 装饰 `context.mc.xxxDecoration()`

| 方法 | 说明 |
|------|------|
| `.cardDecoration()` | 标准卡片背景 + 细边框 |
| `.mutedDecoration()` | 次要背景（无边框） |
| `.glassDecoration()` | 毛玻璃表面 |
| `.pillDecoration()` | 药丸形容器 |

> 也提供静态方法 `McDecorations.card(context)`、`McDecorations.glass(context)` 等。

---

## 主题切换

直接使用 Flutter 原生的 `CupertinoApp.themeMode` 或 `MaterialApp.themeMode`，`context.mc` 自动跟随。

### Cupertino 方式

```dart
class MyApp extends StatefulWidget { ... }

class _MyAppState extends State<MyApp> {
  ThemeMode _mode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      themeMode: _mode,
      builder: (context, child) => McThemeData.wrap(child: child!),
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

### Material 方式

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system, // 或 ThemeMode.dark / ThemeMode.light
      theme: McThemeData.materialTheme(McColors.light),
      darkTheme: McThemeData.materialTheme(McColors.dark),
      home: const MyHomePage(),
    );
  }
}
```

---

## License

MIT
