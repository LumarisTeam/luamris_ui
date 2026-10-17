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
          McCard.elevated(
            child: Column(
              children: [
                McListTile(
                  leading: const McAvatar(
                    name: '张三',
                    size: 40,
                  ),
                  title: const Text('张三'),
                  subtitle: const Text('计算机科学与技术 · 2023 级'),
                  trailing: const Icon(CupertinoIcons.chevron_right, size: 16),
                  onTap: () => _showToast(context, '点击了张三'),
                ),
                _divider(m),
                McListTile(
                  leading: const McAvatar(
                    image: NetworkImage(
                      'https://api.dicebear.com/9.x/avataaars/png?seed=LiSi',
                    ),
                    name: '李四',
                    size: 40,
                  ),
                  title: const Text('李四'),
                  subtitle: const Text('软件工程 · 2024 级'),
                  trailing: const Icon(CupertinoIcons.chevron_right, size: 16),
                  onTap: () => _showToast(context, '点击了李四'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _sectionTitle('无 leading', m),
          const SizedBox(height: 10),
          McCard.elevated(
            child: McListTile(
              title: const Text('系统设置'),
              subtitle: const Text('通知、隐私、通用'),
              trailing: const Icon(CupertinoIcons.chevron_right, size: 16),
              onTap: () => _showToast(context, '进入设置'),
            ),
          ),

          const SizedBox(height: 24),
          _sectionTitle('带统计芯片', m),
          const SizedBox(height: 10),
          McCard.elevated(
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
    return Container(height: 1, color: m.border.withValues(alpha: 0.4));
  }

  void _showToast(BuildContext context, String message) {
    McFeedback.showInfo(context, message: message);
  }
}

Widget _sectionTitle(String text, McTheme m) {
  return Text(text, style: m.textSection);
}
