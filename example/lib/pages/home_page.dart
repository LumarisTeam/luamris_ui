import 'package:flutter/cupertino.dart';
import 'package:luamris_ui/luamris_ui.dart';

import 'buttons_demo.dart';
import 'cards_demo.dart';
import 'list_tiles_demo.dart';
import 'badges_demo.dart';
import 'avatars_demo.dart';
import 'fields_demo.dart';
import 'empty_demo.dart';
import 'bottom_sheet_demo.dart';
import 'responsive_demo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return McPageScaffold(
      title: 'Luamris UI',
      navigationBarStyle: McNavigationBarStyle.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Apple 风格 Flutter UI 组件库',
            style: m.textMuted,
          ),
          const SizedBox(height: 24),
          _SectionCard(
            icon: CupertinoIcons.circle_grid_3x3_fill,
            title: '按钮 McButton',
            subtitle: 'primary · secondary · ghost · danger',
            onTap: () => _navigate(context, const ButtonsDemo()),
          ),
          _SectionCard(
            icon: CupertinoIcons.square_on_square,
            title: '卡片 McCard',
            subtitle: 'glass · elevated · flat',
            onTap: () => _navigate(context, const CardsDemo()),
          ),
          _SectionCard(
            icon: CupertinoIcons.list_bullet,
            title: '列表 McListTile',
            subtitle: 'leading · title · subtitle · trailing',
            onTap: () => _navigate(context, const ListTilesDemo()),
          ),
          _SectionCard(
            icon: CupertinoIcons.tag_fill,
            title: '标签 & 统计',
            subtitle: 'McBadge · McStatChip',
            onTap: () => _navigate(context, const BadgesDemo()),
          ),
          _SectionCard(
            icon: CupertinoIcons.person_crop_circle_fill,
            title: '头像 McAvatar',
            subtitle: 'network · SVG · initials fallback',
            onTap: () => _navigate(context, const AvatarsDemo()),
          ),
          _SectionCard(
            icon: CupertinoIcons.pencil,
            title: '表单 McField',
            subtitle: 'text · password · validation',
            onTap: () => _navigate(context, const FieldsDemo()),
          ),
          _SectionCard(
            icon: CupertinoIcons.tray,
            title: '空状态 McEmpty',
            subtitle: 'placeholder · retry',
            onTap: () => _navigate(context, const EmptyDemo()),
          ),
          _SectionCard(
            icon: CupertinoIcons.rectangle_stack,
            title: '弹出层 & 反馈',
            subtitle: 'BottomSheet · Toast · Confirm',
            onTap: () => _navigate(context, const BottomSheetDemo()),
          ),
          _SectionCard(
            icon: CupertinoIcons.square_grid_2x2,
            title: '响应式布局',
            subtitle: 'McResponsive · McTwoPane',
            onTap: () => _navigate(context, const ResponsiveDemo()),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, Widget page) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (_) => page));
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: McCard.elevated(
        onPressed: onTap,
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: m.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(m.radiusMd),
              ),
              child: Icon(icon, color: m.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: m.textSection),
                  const SizedBox(height: 2),
                  Text(subtitle, style: m.textMuted),
                ],
              ),
            ),
            Icon(CupertinoIcons.chevron_right, color: m.mutedForeground, size: 18),
          ],
        ),
      ),
    );
  }
}
