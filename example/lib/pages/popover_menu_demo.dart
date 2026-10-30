import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:luamris_ui/luamris_ui.dart';

class PopoverMenuDemo extends StatefulWidget {
  const PopoverMenuDemo({super.key});

  @override
  State<PopoverMenuDemo> createState() => _PopoverMenuDemoState();
}

class _PopoverMenuDemoState extends State<PopoverMenuDemo> {
  static const List<String> _terms = <String>['第一学期', '第二学期', '第三学期'];

  int _term = 1;
  bool _termMenuOpen = false;

  String _density = 'standard';
  bool _densityMenuOpen = false;

  String get _densityLabel => switch (_density) {
    'compact' => '紧凑',
    'relaxed' => '宽松',
    _ => '标准',
  };

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return McPageScaffold(
      title: '下拉菜单 McPopoverMenu',
      navigationBarStyle: McNavigationBarStyle.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('下拉选择（跟随宽度 + 勾选）', m),
          const SizedBox(height: 10),
          McPopoverMenu<int>(
            items: [
              for (var i = 0; i < _terms.length; i++)
                McPopoverMenuItem<int>(value: i, label: _terms[i]),
            ],
            selectedValue: _term,
            matchTriggerWidth: true,
            onOpenChanged: (open) => setState(() => _termMenuOpen = open),
            onSelected: (value) => setState(() => _term = value),
            child: _DropdownTrigger(label: _terms[_term], open: _termMenuOpen),
          ),
          const SizedBox(height: 10),
          Text('当前选择：${_terms[_term]}', style: m.textMuted),

          const SizedBox(height: 28),
          _sectionTitle('操作菜单（图标 + 危险色）', m),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: McPopoverMenu<String>(
              width: 208,
              offset: const Offset(0, 6),
              items: const [
                McPopoverMenuItem(
                  value: 'edit',
                  label: '编辑',
                  icon: CupertinoIcons.pencil,
                ),
                McPopoverMenuItem(
                  value: 'share',
                  label: '分享',
                  icon: CupertinoIcons.share,
                ),
                McPopoverMenuItem(
                  value: 'delete',
                  label: '删除',
                  icon: CupertinoIcons.trash,
                  isDestructive: true,
                ),
              ],
              onSelected: (value) =>
                  McFeedback.showInfo(context, message: '选择了 $value'),
              child: _ActionTrigger(
                icon: CupertinoIcons.ellipsis_circle,
                label: '更多操作',
              ),
            ),
          ),

          const SizedBox(height: 28),
          _sectionTitle('自定义宽度 / 圆角 / 背景 / 动画', m),
          const SizedBox(height: 10),
          McPopoverMenu<String>(
            width: 244,
            radius: McRadii.tile,
            backgroundColor: m.card.withValues(alpha: 0.82),
            barrierColor: m.primary.withValues(alpha: 0.06),
            animationDuration: const Duration(milliseconds: 240),
            offset: const Offset(0, 10),
            alignment: McPopoverMenuAlignment.end,
            onOpenChanged: (open) => setState(() => _densityMenuOpen = open),
            items: const [
              McPopoverMenuItem(value: 'compact', label: '紧凑'),
              McPopoverMenuItem(value: 'standard', label: '标准'),
              McPopoverMenuItem(value: 'relaxed', label: '宽松'),
            ],
            selectedValue: _density,
            onSelected: (value) => setState(() => _density = value),
            child: _DropdownTrigger(
              label: _densityLabel,
              open: _densityMenuOpen,
            ),
          ),

          const SizedBox(height: 28),
          _sectionTitle('自动避让', m),
          const SizedBox(height: 10),
          Text(
            '菜单打开时会测量触发控件在屏幕中的位置：下方空间不足会自动翻到上方，'
            '左右越界会自动翻转或平移；两侧都放不下时菜单变为可滚动。',
            style: m.textMuted,
          ),
        ],
      ),
    );
  }
}

class _DropdownTrigger extends StatelessWidget {
  const _DropdownTrigger({required this.label, required this.open});

  final String label;
  final bool open;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: ShapeDecoration(
        color: m.cardBackground,
        shape: McSmoothCorners.shape(McRadii.navigationBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          AnimatedRotation(
            turns: open ? 0.5 : 0,
            duration: const Duration(milliseconds: 180),
            child: Icon(
              CupertinoIcons.chevron_down,
              size: 16,
              color: m.secondaryLabel,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTrigger extends StatelessWidget {
  const _ActionTrigger({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: ShapeDecoration(
        color: m.secondary,
        shape: McSmoothCorners.shape(McRadii.navigationBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: m.foreground),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: m.foreground,
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
