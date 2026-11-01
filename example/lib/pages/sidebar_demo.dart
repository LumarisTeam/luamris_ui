import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:luamris_ui/luamris_ui.dart';

class SidebarDemo extends StatefulWidget {
  const SidebarDemo({super.key});

  @override
  State<SidebarDemo> createState() => _SidebarDemoState();
}

class _SidebarDemoState extends State<SidebarDemo> {
  static const _items = [
    McSidebarDestination(
      icon: CupertinoIcons.house,
      selectedIcon: CupertinoIcons.house_fill,
      label: '首页',
    ),
    McSidebarDestination(icon: CupertinoIcons.calendar, label: '课表'),
    McSidebarDestination(
      icon: CupertinoIcons.map,
      selectedIcon: CupertinoIcons.map_fill,
      label: '地图',
    ),
  ];
  int _selectedIndex = 0;
  bool _focused = true;

  @override
  Widget build(BuildContext context) => McPageScaffold(
    title: 'macOS 侧边栏',
    navigationBarStyle: McNavigationBarStyle.compact,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('拖动分界线调整宽度；向左拖到底可收起，再从左边缘拖出。', style: context.mc.textMuted),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text('窗口焦点'),
            const SizedBox(width: 12),
            CupertinoSwitch(
              value: _focused,
              onChanged: (value) => setState(() => _focused = value),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 360,
          child: McSidebarShell(
            sidebar: McSidebar(
              items: _items,
              selectedIndex: _selectedIndex,
              onItemSelected: (index) => setState(() => _selectedIndex = index),
              isWindowFocused: _focused,
              bottom: McSidebarUserTile(
                title: 'Luamris',
                subtitle: '个人资料',
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: context.mc.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.person_fill,
                    size: 18,
                    color: context.mc.onAccent,
                  ),
                ),
                onTap: () => setState(() => _selectedIndex = -1),
              ),
            ),
            child: ColoredBox(
              color: context.mc.card,
              child: Center(
                child: Text(
                  _selectedIndex == -1 ? '个人资料' : _items[_selectedIndex].label,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
