import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:luamris_ui/luamris_ui.dart';

class ListTilesDemo extends StatelessWidget {
  const ListTilesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return McPageScaffold(
      title: '列表 McListTile',
      navigationBarStyle: McNavigationBarStyle.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('完整配置', m),
          const SizedBox(height: 10),
          McCard.grouped(
            child: Column(
              children: [
                McListTile(
                  leading: const McAvatar(name: '张三', size: 40),
                  title: const Text('张三'),
                  subtitle: const Text('计算机科学与技术 · 2023 级'),
                  showChevron: true,
                  onTap: () => _showToast(context, '点击了张三'),
                ),
                _divider(m),
                McListTile(
                  leading: const McAvatar(name: '李四', size: 40),
                  title: const Text('李四'),
                  subtitle: const Text('软件工程 · 2024 级'),
                  showChevron: true,
                  onTap: () => _showToast(context, '点击了李四'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _sectionTitle('选中与禁用', m),
          const SizedBox(height: 10),
          McCard.grouped(
            child: Column(
              children: [
                McListTile(
                  title: const Text('当前选中项'),
                  subtitle: const Text('使用 selectionFill 作为背景'),
                  selected: true,
                  showChevron: true,
                  onTap: () => _showToast(context, '点击了选中项'),
                ),
                _divider(m),
                McListTile(
                  title: const Text('禁用项'),
                  subtitle: const Text('enabled: false 时不可交互'),
                  enabled: false,
                  showChevron: true,
                  onTap: () => _showToast(context, '不应出现'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _sectionTitle('长按与自定义样式', m),
          const SizedBox(height: 10),
          McCard.grouped(
            child: McListTile(
              title: const Text('长按这一行'),
              subtitle: const Text('支持 onLongPress'),
              titleTextStyle: TextStyle(
                color: m.primary,
                fontWeight: FontWeight.w700,
              ),
              onTap: () => _showToast(context, '短按'),
              onLongPress: () => _showToast(context, '长按触发'),
            ),
          ),

          const SizedBox(height: 24),
          _sectionTitle('分组列表', m),
          const SizedBox(height: 10),
          McCard.grouped(
            child: Column(
              children: [
                McListTile(
                  leading: Icon(
                    CupertinoIcons.bell,
                    color: m.warning,
                    size: 20,
                  ),
                  title: const Text('通知'),
                  showChevron: true,
                  onTap: () => _showToast(context, '通知设置'),
                ),
                _divider(m),
                McListTile(
                  leading: Icon(
                    CupertinoIcons.lock,
                    color: m.secondaryLabel,
                    size: 20,
                  ),
                  title: const Text('隐私'),
                  showChevron: true,
                  onTap: () => _showToast(context, '隐私设置'),
                ),
                _divider(m),
                McListTile(
                  leading: Icon(
                    CupertinoIcons.info_circle,
                    color: m.secondaryLabel,
                    size: 20,
                  ),
                  title: const Text('关于'),
                  subtitle: const Text('版本 0.3.0'),
                  showChevron: true,
                  onTap: () => _showToast(context, '关于页面'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _sectionTitle('带统计芯片', m),
          const SizedBox(height: 10),
          McCard.grouped(
            child: Column(
              children: [
                McListTile(
                  title: const Text('校园集市热门贴'),
                  subtitle: const Text('二手教材转让 · 9 成新'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      McStatChip(icon: CupertinoIcons.heart, label: '128'),
                      const SizedBox(width: 8),
                      McStatChip(icon: CupertinoIcons.chat_bubble, label: '36'),
                    ],
                  ),
                ),
                _divider(m),
                McListTile(
                  title: const Text('自习室推荐'),
                  subtitle: const Text('图书馆 B 区 3 楼 · 安静适合备考'),
                  trailing: McStatChip(icon: CupertinoIcons.eye, label: '2.4k'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(McTheme m) {
    return Container(height: 0.5, color: m.separator.withValues(alpha: 0.5));
  }

  void _showToast(BuildContext context, String message) {
    McFeedback.showInfo(context, message: message);
  }
}

Widget _sectionTitle(String text, McTheme m) {
  return Text(text, style: m.textSection);
}
