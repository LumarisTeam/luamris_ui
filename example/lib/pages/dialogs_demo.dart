import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:luamris_ui/luamris_ui.dart';

class DialogsDemo extends StatelessWidget {
  const DialogsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return McPageScaffold(
      title: '对话框',
      navigationBarStyle: McNavigationBarStyle.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('确认对话框', m),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              McButton.primary(
                onPressed: () => _confirm(context),
                child: const Text('普通确认'),
              ),
              McButton.danger(
                onPressed: () => _destructiveConfirm(context),
                child: const Text('危险确认'),
              ),
            ],
          ),

          const SizedBox(height: 28),
          _sectionTitle('输入框对话框', m),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              McButton.secondary(
                onPressed: () => _input(context),
                child: const Text('文本输入'),
              ),
              McButton.secondary(
                onPressed: () => _passwordInput(context),
                child: const Text('密码输入'),
              ),
            ],
          ),

          const SizedBox(height: 28),
          _sectionTitle('多操作对话框', m),
          const SizedBox(height: 10),
          McCard.flat(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('3 个操作会纵向排列', style: m.textBody),
                const SizedBox(height: 4),
                Text(
                  '每个操作可以返回任意类型的值，或使用 autoPop: false 保持弹窗打开。',
                  style: m.textMuted,
                ),
                const SizedBox(height: 12),
                McButton.primary(
                  onPressed: () => _multiAction(context),
                  child: const Text('打开多操作对话框'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
          _sectionTitle('旧版入口', m),
          const SizedBox(height: 10),
          McButton.secondary(
            onPressed: () => _legacyConfirm(context),
            child: const Text('McFeedback.confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final result = await showMcConfirmDialog(
      context: context,
      title: '保存修改',
      message: '确定要保存当前修改吗？',
      cancelText: '取消',
      confirmText: '保存',
    );
    if (!context.mounted) return;
    if (result == true) {
      McFeedback.showSuccess(context, message: '已保存');
    }
  }

  Future<void> _destructiveConfirm(BuildContext context) async {
    final result = await showMcConfirmDialog(
      context: context,
      title: '删除确认',
      message: '此操作无法撤销，确定要删除该项吗？',
      cancelText: '取消',
      confirmText: '删除',
      destructive: true,
    );
    if (!context.mounted) return;
    if (result == true) {
      McFeedback.showSuccess(context, message: '已删除');
    }
  }

  Future<void> _input(BuildContext context) async {
    final value = await showMcInputDialog(
      context: context,
      title: '修改昵称',
      message: '请输入新的昵称',
      hintText: '昵称',
      initialValue: '张三',
      cancelText: '取消',
      confirmText: '保存',
    );
    if (!context.mounted || value == null) return;
    McFeedback.showInfo(context, message: '新昵称：$value');
  }

  Future<void> _passwordInput(BuildContext context) async {
    final value = await showMcInputDialog(
      context: context,
      title: '身份验证',
      message: '请输入查询密码',
      hintText: '密码',
      obscureText: true,
      keyboardType: TextInputType.number,
      cancelText: '取消',
      confirmText: '确定',
    );
    if (!context.mounted || value == null) return;
    McFeedback.showInfo(context, message: '已输入 ${value.length} 位密码');
  }

  Future<void> _multiAction(BuildContext context) async {
    final result = await showMcDialog<String>(
      context: context,
      title: '选择操作',
      message: '这个对话框有三个纵向排列的操作。',
      actions: [
        McDialogAction<String>(label: '稍后提醒', value: 'later'),
        McDialogAction<String>(label: '查看详情', value: 'details'),
        McDialogAction<String>(
          label: '保持打开并提示',
          value: 'stay',
          autoPop: false,
          onPressed: () {
            if (context.mounted) {
              McFeedback.showInfo(context, message: '弹窗仍然打开');
            }
          },
        ),
      ],
    );
    if (!context.mounted || result == null) return;
    McFeedback.showInfo(context, message: '选择了 $result');
  }

  Future<void> _legacyConfirm(BuildContext context) async {
    final result = await McFeedback.confirm(
      context,
      title: '退出登录',
      message: '确定要退出当前账号吗？',
      cancelText: '取消',
      confirmText: '退出',
      destructive: true,
    );
    if (!context.mounted) return;
    if (result == true) {
      McFeedback.showInfo(context, message: '已退出');
    }
  }
}

Widget _sectionTitle(String text, McTheme m) {
  return Text(text, style: m.textSection);
}
