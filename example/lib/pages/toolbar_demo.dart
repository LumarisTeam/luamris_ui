import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:luamris_ui/luamris_ui.dart';

class ToolbarDemo extends StatefulWidget {
  const ToolbarDemo({super.key});

  @override
  State<ToolbarDemo> createState() => _ToolbarDemoState();
}

class _ToolbarDemoState extends State<ToolbarDemo> {
  final _sidebar = McSidebarController();
  final _search = TextEditingController();
  bool _showLabels = false;
  bool _focused = true;
  int _selected = 0;
  int _count = 0;
  String _status = '使用工具栏操作，或拖动侧边栏边缘调整宽度。';

  @override
  void dispose() {
    _sidebar.dispose();
    _search.dispose();
    super.dispose();
  }

  void _report(String value) => setState(() => _status = value);

  Future<void> _openSearch() async {
    final query = await showMcInputDialog(
      context: context,
      title: '搜索',
      hintText: '输入关键词',
      initialValue: _search.text,
    );
    if (mounted && query != null) {
      _search.text = query;
      _report('搜索：$query');
    }
  }

  @override
  Widget build(BuildContext context) => McPageScaffold(
    title: 'macOS 工具栏',
    navigationBarStyle: McNavigationBarStyle.compact,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '缩窄窗口或展开侧边栏，观察操作如何移入「更多操作」菜单。菜单支持方向键、Enter 和 Esc。',
          style: context.mc.textMuted,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 24,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('显示标签'),
                const SizedBox(width: 8),
                CupertinoSwitch(
                  value: _showLabels,
                  onChanged: (value) => setState(() => _showLabels = value),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('窗口焦点'),
                const SizedBox(width: 8),
                CupertinoSwitch(
                  value: _focused,
                  onChanged: (value) => setState(() => _focused = value),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 400,
          child: McSidebarShell(
            controller: _sidebar,
            sidebar: McSidebar(
              items: const [
                McSidebarDestination(icon: CupertinoIcons.doc, label: '全部文档'),
                McSidebarDestination(icon: CupertinoIcons.star, label: '收藏'),
              ],
              selectedIndex: _selected,
              onItemSelected: (index) => setState(() => _selected = index),
              isWindowFocused: _focused,
            ),
            toolbar: McToolBar(
              title: Text(_selected == 0 ? '全部文档' : '收藏'),
              titleWidth: 110,
              isWindowFocused: _focused,
              overflowLabel: '更多操作',
              leading: McToolBarIconButton(
                label: '切换侧边栏',
                icon: const Icon(CupertinoIcons.sidebar_left),
                onPressed: _sidebar.toggle,
              ),
              actions: [
                McToolBarIconButton(
                  label: '新建',
                  icon: const Icon(CupertinoIcons.add),
                  showLabel: _showLabels,
                  onPressed: () => setState(() {
                    _count++;
                    _status = '已新建文档，共 $_count 份';
                  }),
                ),
                McToolBarIconButton(
                  label: '删除',
                  icon: const Icon(CupertinoIcons.trash),
                  showLabel: _showLabels,
                  onPressed: _count == 0
                      ? null
                      : () => setState(() {
                          _count--;
                          _status = '已删除文档，剩余 $_count 份';
                        }),
                ),
                const McToolBarSpacer(spacerUnits: 0.25),
                McToolBarCustomItem(
                  width: 160,
                  overflowItems: [
                    McToolBarMenuItem(
                      label: '搜索',
                      icon: CupertinoIcons.search,
                      onSelected: _openSearch,
                    ),
                  ],
                  child: CupertinoSearchTextField(
                    controller: _search,
                    placeholder: '搜索',
                    onChanged: (value) => _report('搜索：$value'),
                  ),
                ),
                McToolBarPullDownButton(
                  label: '排序',
                  icon: const Icon(CupertinoIcons.sort_down),
                  showLabel: _showLabels,
                  items: [
                    McToolBarMenuItem(
                      label: '按名称',
                      onSelected: () => _report('已按名称排序'),
                    ),
                    McToolBarMenuItem(
                      label: '按时间',
                      onSelected: () => _report('已按时间排序'),
                    ),
                  ],
                ),
              ],
            ),
            child: ColoredBox(
              color: context.mc.card,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_status, style: context.mc.textMuted),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
