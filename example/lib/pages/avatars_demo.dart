import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:luamris_ui/luamris_ui.dart';

class AvatarsDemo extends StatelessWidget {
  const AvatarsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return McPageScaffold(
      title: '头像 McAvatar',
      navigationBarStyle: McNavigationBarStyle.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('网络图片', m),
          const SizedBox(height: 10),
          McCard.elevated(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('传入 NetworkImage 即可加载远程头像', style: m.textMuted),
                const SizedBox(height: 12),
                Wrap(spacing: 12, runSpacing: 12, children: const [
                  McAvatar(
                    image: NetworkImage(
                      'https://api.dicebear.com/9.x/avataaars/png?seed=Felix',
                    ),
                    name: 'Felix',
                    size: 48,
                  ),
                  McAvatar(
                    image: NetworkImage(
                      'https://api.dicebear.com/9.x/avataaars/png?seed=Aneka',
                    ),
                    name: 'Aneka',
                    size: 48,
                  ),
                  McAvatar(
                    image: NetworkImage(
                      'https://api.dicebear.com/9.x/avataaars/png?seed=Salem',
                    ),
                    name: 'Salem',
                    size: 48,
                  ),
                ]),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _sectionTitle('不同头像风格', m),
          const SizedBox(height: 10),
          McCard.elevated(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('支持任意 ImageProvider，如 NetworkImage、AssetImage', style: m.textMuted),
                const SizedBox(height: 12),
                Wrap(spacing: 12, runSpacing: 12, children: const [
                  McAvatar(
                    image: NetworkImage(
                      'https://api.dicebear.com/9.x/lorelei/png?seed=Jack',
                    ),
                    name: 'Jack',
                    size: 48,
                  ),
                  McAvatar(
                    image: NetworkImage(
                      'https://api.dicebear.com/9.x/bottts/png?seed=Mia',
                    ),
                    name: 'Mia',
                    size: 48,
                  ),
                  McAvatar(
                    image: NetworkImage(
                      'https://api.dicebear.com/9.x/adventurer/png?seed=Leo',
                    ),
                    name: 'Leo',
                    size: 48,
                  ),
                ]),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _sectionTitle('首字母回退', m),
          const SizedBox(height: 10),
          McCard.elevated(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('无图片或加载失败时显示首字母', style: m.textMuted),
                const SizedBox(height: 12),
                Wrap(spacing: 12, runSpacing: 12, children: const [
                  McAvatar(name: '王小明', size: 48),
                  McAvatar(name: 'Alice', size: 48),
                  McAvatar(name: 'Bob Chen', size: 48),
                ]),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _sectionTitle('不同尺寸与形状', m),
          const SizedBox(height: 10),
          McCard.elevated(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('圆形与圆角方形', style: m.textMuted),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: const [
                    McAvatar(name: 'S', size: 28),
                    McAvatar(name: 'M', size: 40),
                    McAvatar(name: 'L', size: 56),
                    McAvatar(name: 'XL', size: 72),
                    SizedBox(width: 16),
                    McAvatar(name: '方', size: 48, isCircle: false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _sectionTitle(String text, McTheme m) {
  return Text(text, style: m.textSection);
}
