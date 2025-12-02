import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/token/app_tokens.dart';
import '../../ui/button.dart';
import '../../ui/layouts/app_wrap_tags.dart';
import '../../ui/search_bar.dart';
import 'search_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _searchController;
  late final StateController<String> _queryController;

  @override
  void initState() {
    super.initState();
    _queryController = ref.read(searchQueryProvider.notifier);
    _searchController = TextEditingController(text: _queryController.state);
  }

  @override
  void dispose() {
    _queryController.state = '';
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _queryController.state = value;
    setState(() {});
  }

  void _clearQuery() {
    _searchController.clear();
    _onQueryChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final query = ref.watch(searchQueryProvider);

    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          _queryController.state = '';
        }
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.only(right: tokens.gapSmall),
            child: AppSearchBar(
              controller: _searchController,
              hintText: '검색어를 입력하세요',
              padding: EdgeInsets.symmetric(horizontal: tokens.gapSmall),
              onChanged: _onQueryChanged,
              trailing:
                  _searchController.text.isEmpty
                      ? null
                      : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _clearQuery,
                      ),
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.only(
            left: tokens.gapMedium,
            right: tokens.gapMedium,
            top: tokens.gapMedium,
            bottom: tokens.gapXLarge,
          ),
          children: [
            if (query.isEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: '최근 검색어',
                    controlLabel: '모두삭제',
                    onControlTap: () {},
                  ),
                  AppWrapTags(
                    items: const ['셔링 봄버', 'Wmc 경량패딩', '러프사이드 봄버', '코듀로이 봄버'],
                    spacing: tokens.gapSmall,
                    chipBuilder:
                        (context, text, index) => Chip(
                          label: Text(text),
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          side: BorderSide.none,
                        ),
                  ),
                  SizedBox(height: tokens.gapSmall),
                  _SectionHeader(
                    title: '최근 방문한 브랜드',
                    controlLabel: '모두삭제',
                    onControlTap: () {},
                  ),
                  AppWrapTags(
                    items: const ['어반디타입', '오프닝프로젝트', '돈포겟미', '인사일런스'],
                    spacing: tokens.gapSmall,
                    chipBuilder:
                        (context, text, index) => Chip(
                          avatar: CircleAvatar(
                            radius: 12,
                            backgroundColor:
                                Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                            child: Text(
                              text.characters.first,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          label: Text(text),
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          side: BorderSide.none,
                        ),
                  ),
                  SizedBox(height: tokens.gapSmall),
                  _RankingSection(
                    title: '인기 검색어',
                    reference: '11.26 21:00, 기준',
                    items: const [
                      '니트',
                      '패딩',
                      '후드티',
                      '맨투맨',
                      '경량패딩',
                      '어그',
                      '무진장',
                      '무스탕',
                      '바지',
                      '코트',
                    ],
                  ),
                  SizedBox(height: tokens.gapLarge),
                  _RankingSection(
                    title: '급상승 검색어',
                    reference: '11.26 21:00, 기준',
                    items: const [
                      '츄리닝',
                      '버버리',
                      '긴팔',
                      '목티',
                      '자라',
                      '펜필드',
                      '데님 팬츠',
                      '제로',
                      '탄산마그네슘',
                      '남자 맨투맨',
                    ],
                  ),
                ],
              ),

            if (query.isNotEmpty) ...[
              SizedBox(height: tokens.gapSmall),
              _SectionHeader(title: '추천 키워드', onControlTap: () {}),
              AppWrapTags(
                items: const ['셔링 봄버', 'Wmc 경량패딩', '러프사이드 봄버', '코듀로이 봄버'],
                spacing: tokens.gapSmall,
                chipBuilder:
                    (context, text, index) => Chip(
                      label: Text(text),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      side: BorderSide.none,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.controlLabel,
    this.onControlTap,
  });

  final String title;
  final String? controlLabel;
  final VoidCallback? onControlTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.bodyMedium),
        if (controlLabel != null)
          AppButton.text(
            label: controlLabel!,
            onPressed: onControlTap,
            textStyle: theme.textTheme.bodyMedium,
          ),
      ],
    );
  }
}

class _RankingSection extends StatelessWidget {
  const _RankingSection({
    required this.title,
    required this.items,
    required this.reference,
  });

  final String title;
  final List<String> items;
  final String reference;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final half = (items.length / 2).ceil();
    final first = items.take(half).toList();
    final second = items.skip(half).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            Text(reference, style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _RankingList(items: first)),
            const SizedBox(width: 24),
            Expanded(child: _RankingList(items: second, offset: first.length)),
          ],
        ),
      ],
    );
  }
}

class _RankingList extends StatelessWidget {
  const _RankingList({required this.items, this.offset = 0});

  final List<String> items;
  final int offset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '${i + 1 + offset}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          i + offset < 3
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                      fontWeight:
                          i + offset < 3 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                Text(items[i], style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
      ],
    );
  }
}
