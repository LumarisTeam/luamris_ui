import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:luamris_ui/luamris_ui.dart';

class SkeletonDemo extends StatefulWidget {
  const SkeletonDemo({super.key});

  @override
  State<SkeletonDemo> createState() => _SkeletonDemoState();
}

class _SkeletonDemoState extends State<SkeletonDemo> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    return McPageScaffold(
      title: '骨架屏 McSkeleton',
      navigationBarStyle: McNavigationBarStyle.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('基础形状', style: m.textSection),
          const SizedBox(height: 8),
          Text('圆形、矩形和文本行可自由组合。', style: m.textMuted),
          const SizedBox(height: 12),
          const Row(
            children: [
              McSkeletonCircle(size: 48),
              SizedBox(width: 16),
              McSkeletonBox(width: 80, height: 48),
              SizedBox(width: 16),
              Expanded(child: McSkeletonLine()),
            ],
          ),
          const SizedBox(height: 28),
          Text('加载状态切换', style: m.textSection),
          const SizedBox(height: 8),
          Text('切换按钮可查看骨架屏和加载完成的内容。', style: m.textMuted),
          const SizedBox(height: 12),
          McButton.secondary(
            onPressed: () => setState(() => _isLoading = !_isLoading),
            child: Text(_isLoading ? '显示加载完成' : '重新显示骨架屏'),
          ),
          const SizedBox(height: 24),
          Text('列表预设', style: m.textSection),
          const SizedBox(height: 10),
          McCard.grouped(
            child: McShimmerLoading(
              isLoading: _isLoading,
              skeleton: const Column(
                children: [
                  McListItemSkeleton(hasTrailing: true),
                  McListItemSkeleton(lines: 3),
                ],
              ),
              child: const Column(
                children: [
                  McListTile(title: Text('课程通知'), subtitle: Text('今天 10:30')),
                  McListTile(title: Text('校园活动'), subtitle: Text('明天 14:00')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('卡片预设', style: m.textSection),
          const SizedBox(height: 10),
          McCard.grouped(
            child: McShimmerLoading(
              isLoading: _isLoading,
              skeleton: const McCardSkeleton(),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('本周安排', style: m.textSection),
                    const SizedBox(height: 12),
                    Text('课程和活动已准备就绪。', style: m.textMuted),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
