# Changelog

## 0.3.2

### Fixed

- `showMcDialog` / `showMcConfirmDialog` / `showMcInputDialog` 移除 Flutter 3.47 中 `CupertinoPopupSurface` 自带的 13px 超椭圆裁剪与额外背景模糊，修复弹窗圆角出现双层错位的问题。弹窗现在只保留一层 24px 玻璃表面。

## 0.3.1

### Fixed

- `showMcDialog` / `showMcConfirmDialog` / `showMcInputDialog` 与 `showMcBottomSheet` 的文本不再继承 Flutter 在没有 Material/Scaffold 祖先时使用的黄色调试下划线样式；弹窗与弹层内部现在提供正常的 `DefaultTextStyle`。
- `McFeedback` toast 的标题与消息显式设置 `TextDecoration.none`。

## 0.3.0

迁移 `ios_club_app` 的 UI 能力到 `luamris_ui`。这是一次 minor 版本升级，包含视觉与 API 变更。

### Added

- **iOS 色板**：`McColors` 新增 `groupedBackground`、`cardOverlay`、`surfaceRaised`、`surfaceMuted`、`surfaceSunken`、`borderStrong`、`inverseLabel`、`indigo` / `purple` / `pink` / `cyan` / `yellow`（含 `...Soft`）、`onAccent`、`selectionFill`、`shadowColor`、`skeletonBase`、`skeletonHighlight`。
- **iOS 风格别名**：`appBackground`、`cardBackground`、`label`、`danger`。
- **语义圆角**：`McRadii.control` (8)、`navigation` (12)、`panel` (16)、`card` (18)、`tile` (22)、`sheetTop` (18)、`handle` (2.5)、`indicator` (2)，以及对应的 `Radius` / `BorderRadius` 常量。
- **平滑圆角**：新增 `McSmoothCorners`（基于 `smooth_corner`），卡片、按钮、列表行、输入框、弹出层统一使用 squircle 圆角。
- **`McCard.grouped`**：零内边距分组卡片，用于承载 `McListTile`。
- **对话框 API**：
  - `showMcDialog<T>` — 通用多操作对话框
  - `showMcConfirmDialog` — 增强确认框
  - `showMcInputDialog` — 输入框对话框（返回值 `String?`）
  - `McDialogAction<T>`
- **`McAppBar`**：Material `AppBar` 包装，支持自动返回按钮、`titleWidget` 与 `bottom`。
- **`McMenu` / `McMenuItem`**：玻璃风格弹出菜单，支持禁用项与危险操作色。
- **`context.mc.colors`**：直接访问原始 `McColors` token；兜底值现在按当前亮度解析。
- **主题参数**：`McThemeData.materialTheme` 与 `wrap` 新增 `fontFamily`、`locale`；`de` / `ru` 语言自动将文字缩小 0.92。
- **主题对齐**：补齐 `textTheme` 颜色、`textButtonTheme`、`iconTheme`、`tabBarTheme`、`dialogTheme` 标题/正文样式、`snackBarTheme` 字号 / `elevation: 0` / 平滑圆角。
- `showMcBottomSheet` 新增 `maxHeight`、`showHandle`、`contentPadding` 与 `scrollable` 参数。
- `McCard` 四个命名构造函数新增 `margin`。
- `McField.text` / `McField.password` 新增 `autofocus`。
- `McPageScaffold` 新增 `backgroundColor`。

### Changed

- **主色**：`primary` 从 `#0071E3` 改为 iOS 系统蓝 `#007AFF`（暗色 `#0A84FF`）。
- **文字 / 表面色**：`foreground` 改为纯黑/纯白；`secondaryLabel`、`secondary`、`muted`、`border`、`input` 改为 iOS 系统值。
- **列表行**：`McListTile` 扩展为完整 ClubListTile API（`onLongPress`、`contentPadding`、`borderRadius`、`enabled`、`selected`、`showChevron`、`titleTextStyle`、`subtitleTextStyle`、`selectedBackgroundColor`）。默认内边距改为水平 16 + 垂直 14/10，默认圆角 18。
- **卡片**：`McCard` 默认圆角从 24 改为 18，并使用平滑圆角与 iOS 阴影。
- **按钮 / 输入框**：`McButton` 默认圆角从 16 改为 12；`McField` 改为 12 圆角并使用 `input` 填充色。
- **页面背景**：`McPageScaffold` 与 `MaterialApp` 的 scaffold 背景改为 `groupedBackground`（浅色 `#F8F8F8`）。
- **底层弹窗**：`showMcBottomSheet` 顶部圆角从 24 改为 18，使用平滑圆角。
- **主题**：`McThemeData.materialTheme` 的 Card / BottomSheet / Input 形状与 ColorScheme 同步更新；`McThemeData.wrap` 支持显式 `colors:`，并优先从 `CupertinoTheme` 解析亮度。
- **依赖约束**：`cupertino_ui` 收紧为 `^1.1.3`，`material_ui` 收紧为 `^1.7.0`。
- **仓库地址**：`homepage` / `repository` 改为 `LumarisTeam/luamris_ui`。
- **非圆形头像**：使用平滑圆角裁剪。

### Deprecated

- `McListTile.padding` → 使用 `contentPadding`
- `McListTile.titleStyle` → 使用 `titleTextStyle`

### Breaking

- 直接调用 `McColors(...)` 构造器的代码需要补充新增的 22 个必填字段；推荐使用 `McColors.light` / `McColors.dark`、`copyWith` 或 `lerp`。
- `McListTile` 的默认内边距与 `McCard` 的默认圆角发生变化，布局可能与旧版本略有不同。

### Unchanged

- 对话框视觉保持不变：24px 圆角、玻璃模糊、20px 内边距、16px 圆角操作按钮。
- Toast 视觉保持不变。
