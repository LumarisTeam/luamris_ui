import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:luamris_ui/luamris_ui.dart';

class ResponsiveDemo extends StatelessWidget {
  const ResponsiveDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return McPageScaffold(
      title: '响应式布局',
      navigationBarStyle: McNavigationBarStyle.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('当前断点信息', m),
          const SizedBox(height: 10),
          McCard.elevated(
            child: _BreakpointInfo(m: m),
          ),

          const SizedBox(height: 24),
          _sectionTitle('McTwoPane 双栏布局', m),
          const SizedBox(height: 10),
          Text(
            '宽屏时左右并排，窄屏时上下堆叠。调整窗口宽度查看效果。',
            style: m.textMuted,
          ),
          const SizedBox(height: 12),
          McCard.flat(
            child: SizedBox(
              height: 180,
              child: McTwoPane(
                primary: Container(
                  decoration: BoxDecoration(
                    color: m.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(m.radiusMd),
                  ),
                  child: Center(
                    child: Text('主内容区域', style: m.textMuted),
                  ),
                ),
                secondary: Container(
                  decoration: BoxDecoration(
                    color: m.secondary,
                    borderRadius: BorderRadius.circular(m.radiusMd),
                  ),
                  child: Center(
                    child: Text('侧边栏', style: m.textMuted),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          _sectionTitle('响应式数值', m),
          const SizedBox(height: 10),
          McCard.elevated(
            child: _ResponsiveValues(m: m),
          ),
        ],
      ),
    );
  }
}

class _BreakpointInfo extends StatelessWidget {
  const _BreakpointInfo({required this.m});

  final McTheme m;

  @override
  Widget build(BuildContext context) {
    final isPhone = McResponsive.isPhone(context);
    final isTablet = McResponsive.isTablet(context);
    final isDesktop = McResponsive.isDesktop(context);

    String deviceLabel() {
      if (isDesktop) return 'Desktop / 宽屏';
      if (isTablet) return 'Tablet / 平板';
      return 'Phone / 手机';
    }

    return Column(
      children: [
        Row(
          children: [
            _chip(context, '当前设备', deviceLabel(), m.primary),
            const SizedBox(width: 8),
            _chip(context, 'Phone', isPhone ? '✓' : '—', m.primary),
            _chip(context, 'Tablet', isTablet ? '✓' : '—', m.primary),
            _chip(context, 'Desktop', isDesktop ? '✓' : '—', m.primary),
          ],
        ),
      ],
    );
  }

  Widget _chip(BuildContext context, String label, String value, Color color) {
    final m = context.mc;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(m.radiusMd),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 2),
            Text(label, style: m.textLabel),
          ],
        ),
      ),
    );
  }
}

class _ResponsiveValues extends StatelessWidget {
  const _ResponsiveValues({required this.m});

  final McTheme m;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(context, 'contentMaxWidth', McResponsive.contentMaxWidth(context).toStringAsFixed(0)),
        _divider(context),
        _row(context, 'formMaxWidth', McResponsive.formMaxWidth(context).toStringAsFixed(0)),
        _divider(context),
        _row(context, 'readableMaxWidth', McResponsive.readableMaxWidth(context).toStringAsFixed(0)),
        _divider(context),
        _row(context, 'sheetMaxWidth', McResponsive.sheetMaxWidth(context).toStringAsFixed(0)),
        _divider(context),
        _row(context, 'sidePaneWidth', McResponsive.sidePaneWidth(context).toStringAsFixed(0)),
        _divider(context),
        _row(context, 'horizontalPadding', McResponsive.horizontalPadding(context).toStringAsFixed(0)),
        _divider(context),
        _row(context, 'listColumnCount', McResponsive.listColumnCount(context).toString()),
      ],
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: m.textBody)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: m.primary)),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(height: 1, color: context.mc.border.withValues(alpha: 0.4));
  }
}

Widget _sectionTitle(String text, McTheme m) {
  return Text(text, style: m.textSection);
}
