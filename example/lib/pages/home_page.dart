import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:luamris_ui/luamris_ui.dart';

import 'buttons_demo.dart';
import 'cards_demo.dart';
import 'list_tiles_demo.dart';
import 'badges_demo.dart';
import 'avatars_demo.dart';
import 'fields_demo.dart';
import 'empty_demo.dart';
import 'bottom_sheet_demo.dart';
import 'dialogs_demo.dart';
import 'popover_menu_demo.dart';
import 'responsive_demo.dart';
import 'sidebar_demo.dart';
import 'toolbar_demo.dart';

typedef _DemoEntry = ({
  IconData icon,
  String title,
  String subtitle,
  Widget page,
});

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<({String title, List<_DemoEntry> entries})> _groups = [
    (
      title: '基础组件',
      entries: [
        (
          icon: CupertinoIcons.circle_grid_3x3_fill,
          title: '按钮 McButton',
          subtitle: 'primary · secondary · ghost · danger',
          page: ButtonsDemo(),
        ),
        (
          icon: CupertinoIcons.square_on_square,
          title: '卡片 McCard',
          subtitle: 'glass · elevated · flat',
          page: CardsDemo(),
        ),
        (
          icon: CupertinoIcons.list_bullet,
          title: '列表 McListTile',
          subtitle: 'leading · title · subtitle · trailing',
          page: ListTilesDemo(),
        ),
        (
          icon: CupertinoIcons.tag_fill,
          title: '标签 & 统计',
          subtitle: 'McBadge · McStatChip',
          page: BadgesDemo(),
        ),
        (
          icon: CupertinoIcons.person_crop_circle_fill,
          title: '头像 McAvatar',
          subtitle: 'network · SVG · initials fallback',
          page: AvatarsDemo(),
        ),
        (
          icon: CupertinoIcons.tray,
          title: '空状态 McEmpty',
          subtitle: 'placeholder · retry',
          page: EmptyDemo(),
        ),
      ],
    ),
    (
      title: '输入与反馈',
      entries: [
        (
          icon: CupertinoIcons.pencil,
          title: '表单 McField',
          subtitle: 'text · password · validation',
          page: FieldsDemo(),
        ),
        (
          icon: CupertinoIcons.rectangle_stack,
          title: '弹出层 & 反馈',
          subtitle: 'BottomSheet · Toast · Confirm',
          page: BottomSheetDemo(),
        ),
        (
          icon: CupertinoIcons.chevron_down_circle,
          title: '下拉菜单 McPopoverMenu',
          subtitle: '锚定 · 自动避让 · 勾选',
          page: PopoverMenuDemo(),
        ),
        (
          icon: CupertinoIcons.exclamationmark_bubble,
          title: '对话框',
          subtitle: 'Confirm · Input · Multi-action',
          page: DialogsDemo(),
        ),
      ],
    ),
    (
      title: '导航与布局',
      entries: [
        (
          icon: CupertinoIcons.wrench,
          title: 'macOS 工具栏',
          subtitle: 'McToolBar · 下拉菜单 · 溢出操作',
          page: ToolbarDemo(),
        ),
        (
          icon: CupertinoIcons.sidebar_left,
          title: 'macOS 侧边栏',
          subtitle: 'McSidebar · 拖拽宽度 · 窗口焦点',
          page: SidebarDemo(),
        ),
        (
          icon: CupertinoIcons.square_grid_2x2,
          title: '响应式布局',
          subtitle: 'McResponsive · McTwoPane',
          page: ResponsiveDemo(),
        ),
      ],
    ),
  ];

  static final _entries = [for (final group in _groups) ...group.entries];

  static final _destinations = [
    for (final entry in _entries)
      McSidebarDestination(icon: entry.icon, label: entry.title),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return McResponsive.isDesktop(context)
        ? _buildDesktop(context)
        : _buildCatalog(context);
  }

  Widget _buildDesktop(BuildContext context) {
    final m = context.mc;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 236,
          child: SafeArea(
            child: McSidebar(
              items: _destinations,
              selectedIndex: _selectedIndex,
              onItemSelected: (index) => setState(() => _selectedIndex = index),
              top: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Semantics(
                    header: true,
                    child: Text('Luamris UI', style: m.textSection),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 1, child: ColoredBox(color: m.border)),
        Expanded(
          child: KeyedSubtree(
            key: ValueKey(_selectedIndex),
            child: _entries[_selectedIndex].page,
          ),
        ),
      ],
    );
  }

  Widget _buildCatalog(BuildContext context) {
    final m = context.mc;
    return McPageScaffold(
      title: 'Luamris UI',
      maxContentWidth: 640,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final group in _groups) ...[
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 12, bottom: 8),
              child: Semantics(
                header: true,
                child: Text(group.title, style: m.textSection),
              ),
            ),
            McCard.grouped(
              child: Column(
                children: [
                  for (final (index, entry) in group.entries.indexed) ...[
                    if (index > 0)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 62),
                        child: SizedBox(
                          height: 0.5,
                          width: double.infinity,
                          child: ColoredBox(color: m.separator),
                        ),
                      ),
                    McListTile(
                      leading: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: m.primarySoft,
                          borderRadius: BorderRadius.circular(m.radiusControl),
                        ),
                        child: Icon(entry.icon, color: m.primary, size: 18),
                      ),
                      title: Text(entry.title),
                      subtitle: Text(entry.subtitle),
                      showChevron: true,
                      onTap: () => Navigator.of(context).push(
                        CupertinoPageRoute<void>(builder: (_) => entry.page),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}
