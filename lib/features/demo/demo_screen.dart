import 'package:flutter/material.dart';

import '../../app/responsive/app_responsive.dart';
import '../../ui/layouts/app_grid_view.dart';
import '../../ui/layouts/app_list_view.dart';
import '../../ui/layouts/app_page_carousel.dart';
import '../../ui/layouts/app_wrap_tags.dart';

/// 공통 레이아웃 컴포넌트를 한 번에 확인할 수 있는 데모 탭.
class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final breakpoint = breakpointOf(context);
    final showCarousel = breakpoint != BreakpointKind.desktop;
    final tabs = <Tab>[
      const Tab(text: 'List'),
      const Tab(text: 'Grid'),
      const Tab(text: 'Wrap'),
      if (showCarousel) const Tab(text: 'Carousel'),
    ];
    final views = <Widget>[
      _buildListTab(context),
      _buildGridTab(context),
      _buildWrapTab(context),
      if (showCarousel) _buildCarouselTab(context),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('공통 UI Demo'),
          bottom: TabBar(
            isScrollable: true,
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: views,
        ),
      ),
    );
  }

  Widget _buildListTab(BuildContext context) {
    return AppListView(
      items: List.generate(12, (index) => '아이템 ${index + 1}'),
      itemBuilder: (ctx, item, index) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(item),
          subtitle: const Text('ListView 공통 컴포넌트'),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  Widget _buildGridTab(BuildContext context) {
    return AppGridView(
      items: List.generate(16, (index) => index + 1),
      itemBuilder: (ctx, item, index) => Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Center(
            child: Text(
              '카드 $item',
              style: Theme.of(ctx).textTheme.titleMedium,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWrapTab(BuildContext context) {
    return AppWrapTags(
      items: List.generate(28, (index) => '태그 ${index + 1}'),
      chipBuilder: (ctx, item, index) => Chip(
        label: Text(item),
        backgroundColor: Theme.of(ctx).colorScheme.surfaceContainerHighest,
      ),
    );
  }

  Widget _buildCarouselTab(BuildContext context) {
    return AppPageCarousel(
      items: const [Colors.indigo, Colors.teal, Colors.deepOrange],
      pageBuilder: (ctx, color, index) => Card(
        color: color,
        child: Center(
          child: Text(
            '페이지 ${index + 1}',
            style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
