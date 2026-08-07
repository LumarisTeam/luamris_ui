import 'package:flutter/cupertino.dart';
import 'package:luamris_ui/luamris_ui.dart';

class BadgesDemo extends StatelessWidget {
  const BadgesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return McPageScaffold(
      title: '标签 & 统计',
      navigationBarStyle: McNavigationBarStyle.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('McBadge 徽章标签', m),
          const SizedBox(height: 10),
          McCard.elevated(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('语义色彩', style: m.textMuted),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    McBadge.neutral(child: Text('默认')),
                    McBadge.success(child: Text('已完成')),
                    McBadge.warning(child: Text('待处理')),
                    McBadge.error(child: Text('已取消')),
                  ],
                ),
                const SizedBox(height: 20),
                Text('自定义颜色', style: m.textMuted),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    McBadge(
                      backgroundColor: m.primary.withValues(alpha: 0.12),
                      foregroundColor: m.primary,
                      child: const Text('新课推荐'),
                    ),
                    McBadge(
                      backgroundColor: m.hot.withValues(alpha: 0.12),
                      foregroundColor: m.hot,
                      child: const Text('热门'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _sectionTitle('McStatChip 统计芯片', m),
          const SizedBox(height: 10),
          McCard.elevated(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('适合展示点赞、浏览、评论等数据', style: m.textMuted),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    McStatChip(icon: CupertinoIcons.heart_fill, label: '1,234'),
                    McStatChip(icon: CupertinoIcons.chat_bubble_fill, label: '567'),
                    McStatChip(icon: CupertinoIcons.eye_fill, label: '8.9k'),
                    McStatChip(icon: CupertinoIcons.share, label: '46'),
                  ],
                ),
                const SizedBox(height: 20),
                Text('自定义颜色', style: m.textMuted),
                const SizedBox(height: 12),
                McStatChip(
                  icon: CupertinoIcons.flame_fill,
                  label: 'Hot',
                  iconColor: m.hot,
                  backgroundColor: m.hot.withValues(alpha: 0.1),
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
