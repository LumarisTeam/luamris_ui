import 'package:flutter/cupertino.dart';
import 'package:luamris_ui/luamris_ui.dart';

class CardsDemo extends StatelessWidget {
  const CardsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return McPageScaffold(
      title: '卡片 McCard',
      navigationBarStyle: McNavigationBarStyle.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Glass 毛玻璃卡片', m),
          const SizedBox(height: 10),
          McCard.glass(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('毛玻璃效果', style: m.textSection),
                const SizedBox(height: 4),
                Text(
                  '使用 BackdropFilter 实现背景模糊，适合覆盖在图片或有色背景上。',
                  style: m.textMuted,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          _sectionTitle('Elevated 带阴影卡片', m),
          const SizedBox(height: 10),
          McCard.elevated(
            onPressed: () => _showTapFeedback(context, '点击了 Elevated 卡片'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('可点击卡片', style: m.textSection),
                const SizedBox(height: 4),
                Text(
                  '带有边框和阴影，设置 onPressed 即可响应点击。',
                  style: m.textMuted,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          _sectionTitle('Flat 扁平卡片', m),
          const SizedBox(height: 10),
          McCard.flat(
            onPressed: () => _showTapFeedback(context, '点击了 Flat 卡片'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('扁平卡片', style: m.textSection),
                const SizedBox(height: 4),
                Text(
                  '仅有边框无阴影，同样支持 onPressed 点击。',
                  style: m.textMuted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTapFeedback(BuildContext context, String message) {
    McFeedback.showInfo(context, message: message);
  }
}

Widget _sectionTitle(String text, McTheme m) {
  return Text(text, style: m.textSection);
}
