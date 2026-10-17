import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:luamris_ui/luamris_ui.dart';

class ButtonsDemo extends StatelessWidget {
  const ButtonsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return McPageScaffold(
      title: '按钮 McButton',
      navigationBarStyle: McNavigationBarStyle.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Primary 主按钮', m),
          const SizedBox(height: 10),
          McButton.primary(
            onPressed: () {},
            child: const Text('确认提交'),
          ),
          const SizedBox(height: 8),
          McButton.primary(
            onPressed: null,
            child: const Text('禁用状态'),
          ),

          const SizedBox(height: 24),
          _sectionTitle('Secondary 次要按钮', m),
          const SizedBox(height: 10),
          McButton.secondary(
            onPressed: () {},
            child: const Text('取消'),
          ),
          const SizedBox(height: 8),
          McButton.secondary(
            onPressed: null,
            child: const Text('禁用状态'),
          ),

          const SizedBox(height: 24),
          _sectionTitle('Ghost 透明按钮', m),
          const SizedBox(height: 10),
          McButton.ghost(
            onPressed: () {},
            child: const Text('了解更多'),
          ),
          const SizedBox(height: 8),
          McButton.ghost(
            onPressed: null,
            child: const Text('禁用状态'),
          ),

          const SizedBox(height: 24),
          _sectionTitle('Danger 危险按钮', m),
          const SizedBox(height: 10),
          McButton.danger(
            onPressed: () {},
            child: const Text('删除账户'),
          ),
          const SizedBox(height: 8),
          McButton.danger(
            onPressed: null,
            child: const Text('禁用状态'),
          ),
        ],
      ),
    );
  }
}

Widget _sectionTitle(String text, McTheme m) {
  return Text(text, style: m.textSection);
}
