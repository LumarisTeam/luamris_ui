import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:luamris_ui/luamris_ui.dart';

class BottomSheetDemo extends StatelessWidget {
  const BottomSheetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return McPageScaffold(
      title: '弹出层 & 反馈',
      navigationBarStyle: McNavigationBarStyle.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('BottomSheet 底部弹出层', m),
          const SizedBox(height: 10),
          McButton.primary(
            onPressed: () => _showBottomSheet(context),
            child: const Text('打开底部弹出层'),
          ),

          const SizedBox(height: 28),
          _sectionTitle('Toast 消息提示', m),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              McButton.secondary(
                onPressed: () =>
                    McFeedback.showInfo(context, message: '这是一条信息提示'),
                child: const Text('Info'),
              ),
              McButton.secondary(
                onPressed: () =>
                    McFeedback.showSuccess(context, message: '操作成功！'),
                child: const Text('Success'),
              ),
              McButton.secondary(
                onPressed: () =>
                    McFeedback.showError(context, message: '操作失败，请重试'),
                child: const Text('Error'),
              ),
            ],
          ),

          const SizedBox(height: 28),
          _sectionTitle('Confirm 确认对话框', m),
          const SizedBox(height: 10),
          McButton.danger(
            onPressed: () => _showConfirm(context),
            child: const Text('删除确认'),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showMcBottomSheet(
      context: context,
      contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      builder: (ctx) {
        final m = ctx.mc;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('分享到', style: m.textSection),
            const SizedBox(height: 16),
            McCard.grouped(
              child: Column(
                children: [
                  McListTile(
                    leading: Icon(
                      CupertinoIcons.paperplane,
                      color: m.primary,
                    ),
                    title: const Text('发送给好友'),
                    onTap: () => Navigator.of(ctx).pop(),
                  ),
                  Container(
                    height: 0.5,
                    color: m.separator.withValues(alpha: 0.5),
                  ),
                  McListTile(
                    leading: Icon(CupertinoIcons.link, color: m.primary),
                    title: const Text('复制链接'),
                    onTap: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            McButton.secondary(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showConfirm(BuildContext context) async {
    final result = await McFeedback.confirm(
      context,
      title: '确认删除',
      message: '此操作无法撤销，确定要删除该项吗？',
      confirmText: '删除',
      cancelText: '取消',
      destructive: true,
    );
    if (result == true && context.mounted) {
      McFeedback.showSuccess(context, message: '已删除');
    }
  }
}

Widget _sectionTitle(String text, McTheme m) {
  return Text(text, style: m.textSection);
}
