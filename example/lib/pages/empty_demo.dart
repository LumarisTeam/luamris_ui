import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:luamris_ui/luamris_ui.dart';

class EmptyDemo extends StatelessWidget {
  const EmptyDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return McPageScaffold(
      title: '空状态 McEmpty',
      navigationBarStyle: McNavigationBarStyle.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Placeholder 占位空状态', m),
          const SizedBox(height: 10),
          McEmpty.placeholder(
            icon: CupertinoIcons.tray,
            title: '暂无数据',
            description: '这里还没有任何内容，稍后再来看看吧。',
          ),

          const SizedBox(height: 24),
          _sectionTitle('Retry 错误重试', m),
          const SizedBox(height: 10),
          McEmpty.retry(
            title: '加载失败',
            description: '请检查网络连接后重试。',
            onRetry: () async {
              await Future<void>.delayed(const Duration(seconds: 1));
              if (context.mounted) {
                McFeedback.showSuccess(context, message: '加载成功！');
              }
            },
          ),

          const SizedBox(height: 24),
          _sectionTitle('自定义操作按钮', m),
          const SizedBox(height: 10),
          McEmpty.placeholder(
            icon: CupertinoIcons.calendar_badge_plus,
            title: '还没有课表',
            description: '点击下方按钮创建你的第一份课表。',
            action: McButton.primary(
              onPressed: () {
                McFeedback.showInfo(context, message: '跳转到创建页面...');
              },
              child: const Text('创建课表'),
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
