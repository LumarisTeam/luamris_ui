# Changelog

## Unreleased

- 新增 `McSidebar` / `McSidebarDestination`，迁入光序 macOS 导航样式，支持亮暗主题、窗口焦点状态、键盘操作与自定义顶部 / 底部。
- 新增 `McSidebarUserTile`，通过参数接收用户文案、头像与点击回调。
- 新增 `McSidebarShell`，默认 220px，可在 180–280px 间拖拽，支持收起与重新展开。
- example 新增侧边栏演示。

## 0.5.0

### Added

- **动效模块**：从光序应用迁入，公开 API 统一使用 `Mc` 前缀。
  - `McMotion`：统一时长、曲线、位移、缩放 token，以及 `McMotion.reduceMotionOf(context)`。
  - `McMotionEntrance`：一次性入场（淡入 + 位移 + 可选缩放），自动跳过嵌套入场，响应系统「减少动态效果」。
  - `McAnimatedCard` / `McInteractiveCard` / `McHoverCard` / `McAnimatedInteractiveCard`。
  - `McAnimatedButton` / `McBounceButton` / `McFadeButton` / `McScaleTapContainer`，支持键盘 Enter / Space 激活与主题色焦点环。
  - `McAnimatedListItem` / `McAnimatedListItemSlideLeft` / `McAnimatedListItemScale`，列表项错峰入场。
  - `McShimmerLoading`，以及 `McSkeletonBox` / `McSkeletonCircle` / `McSkeletonLine` / `McListItemSkeleton` / `McCardSkeleton`。
- 骨架屏颜色读取 `context.mc.skeletonBase` / `skeletonHighlight`，自动跟随亮暗模式。

## 0.4.1

### Added

- **`McPopoverMenu`** 新增 `openOnTap` 与 `openOnLongPress`：
  - `openOnTap`（默认 true）控制点击触发控件是否打开菜单。
  - `openOnLongPress`（默认 false）控制长按是否打开菜单。
  - 长按模式下不会抢走触发控件自身的点击 / 双击手势，适合「点击跳转、长按弹菜单」的场景。

### Changed

- `showMcBottomSheet` 悬浮态左右留白从 16 收紧到 4，更接近截图中的卡片效果；底部留白保持 12。
- `showMcBottomSheet` 的 `showCloseButton` 默认值从 true 改为 false，关闭按钮改为按需开启。

## 0.4.0

### Added

- **`McPopoverMenu` / `McPopoverMenuItem`**：iOS 原生菜单风格的下拉列表。基于 `OverlayEntry` + `CompositedTransformTarget` / `CompositedTransformFollower` 实现，菜单会跟随触发控件定位。
  - 点击触发控件在附近弹出；点击菜单外部或选中选项后自动关闭。
  - 下方空间不足时自动翻到上方；左右越界时自动翻转 / 平移；空间过小时菜单内部可滚动。
  - 支持选中状态、勾选图标、危险项、禁用项与前置图标。
  - 可自定义宽度、圆角、背景色、遮罩色、阴影、间距、对齐方式、动画时长与曲线。
  - `matchTriggerWidth` 让菜单与触发控件等宽，适合下拉选择框。
  - `onOpenChanged` 可在打开 / 开始关闭时同步箭头等触发控件视觉。
- **`showMcBottomSheet` 悬浮卡片样式**：手机端默认四周留白（左 / 右 16、底部 12）、四角 24 圆角、抬起阴影，视觉上不再贴底；平板 / 桌面仍为居中对话框。
  - 新增 `showCloseButton`（默认 true）与 `onClose`：左上角圆形关闭按钮，默认关闭弹层。
  - 新增 `floating`（默认 true）：传 false 可恢复旧的贴底样式。
  - `showHandle` 默认值改为 true（顶部拖拽手柄）。
  - `bottomInset` 仍然生效：传底部菜单栏高度时弹层停在其上方。

### Changed

- `showMcBottomSheet` 默认外观从贴底弹层改为悬浮卡片，并默认显示手柄与关闭按钮。需要旧样式的调用方传 `floating: false`，需要隐藏手柄 / 关闭按钮的传 `showHandle: false` / `showCloseButton: false`。

## 0.3.4

### Added

- `showMcBottomSheet` 新增 `bottomInset` 参数（默认 0）。手机上传入底部菜单栏高度后，弹层会停在菜单栏上方而不是把它盖住；此时四角都改成圆角，因为它不再贴底。平板 / 桌面上该参数无效。

## 0.3.3

### Added

- `showMcBottomSheet` 的拖拽手柄现在真的可用：手机上按住顶部手柄向下拖动时弹层跟手位移，拖过 96pt 或松手速度超过 700 px/s 即收回，否则弹回原位。手柄热区是整条 28pt 高的区域，比原本 5pt 的小横条好按。

### Fixed

- `showMcBottomSheet` 在平板 / 桌面宽度下不再显示拖拽手柄。居中卡片不可下拉，多出来的横条只会让人误以为弹层卡住了。

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
