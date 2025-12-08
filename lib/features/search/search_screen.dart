import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/token/app_tokens.dart';
import '../../ui/button.dart';
import '../../ui/layouts/app_wrap_tags.dart';
import '../../ui/navigation/app_destinations.dart';
import '../../ui/scaffold.dart';
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

    return AppScaffold(
      title: '',
      destinations: appDestinations,
      currentIndex: 0,
      showNavigation: false,
      showDefaultSearchAction: false,
      showDefaultSettingsAction: false,
      useSearchBar: true,
      searchController: _searchController,
      searchHintText: '검색어를 입력하세요',
      searchPadding: EdgeInsets.symmetric(horizontal: tokens.gapSmall),
      searchTrailing:
          _searchController.text.isEmpty
              ? null
              : IconButton(
                icon: const Icon(Icons.close),
                onPressed: _clearQuery,
              ),
      onSearchChanged: _onQueryChanged,
      onDestinationSelected: (_) {},
      child: PopScope(
        onPopInvoked: (didPop) {
          if (didPop) _queryController.state = '';
        },
        child: ListView(
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
                scrollDirection: Axis.horizontal,
                items: kRecommendedKeywords,
                spacing: tokens.gapSmall,
                chipBuilder:
                    (context, text, index) => Chip(
                      label: Text(text),
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.4),
                      side: BorderSide.none,
                    ),
              ),
              SizedBox(height: tokens.gapLarge),
              _ServiceSection(tokens: tokens),
              SizedBox(height: tokens.gapLarge),
              _TipsSection(tokens: tokens),
              SizedBox(height: tokens.gapLarge),
              _FaqSection(tokens: tokens),
              SizedBox(height: tokens.gapMedium),
              _FeedbackCard(tokens: tokens),
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

class _ServiceSection extends StatelessWidget {
  const _ServiceSection({required this.tokens});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('서비스', style: theme.textTheme.titleSmall),
        SizedBox(height: tokens.gapSmall),
        for (final item in kServiceItems) ...[
          Theme(
            data: theme.copyWith(
              splashFactory: InkRipple.splashFactory,
              splashColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              highlightColor: theme.colorScheme.primary.withValues(alpha: 0.05),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: item.color.withValues(alpha: 0.2),
                child: Icon(item.icon, color: item.color),
              ),
              title: Text.rich(
                TextSpan(
                  children: [
                    if (item.highlight != null)
                      TextSpan(
                        text: item.highlight,
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    TextSpan(
                      text: item.title,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
              onTap: () {},
            ),
          ),
          Divider(height: tokens.gapSmall),
        ],
      ],
    );
  }
}

class _TipsSection extends StatelessWidget {
  const _TipsSection({required this.tokens});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('오늘의 팁', style: theme.textTheme.titleMedium),
        SizedBox(height: tokens.gapSmall),
        for (final tip in kTipItems)
          Container(
            margin: EdgeInsets.only(bottom: tokens.gapSmall),
            padding: EdgeInsets.all(tokens.gapSmall),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.35,
              ),
              borderRadius: tokens.radiusMedium,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: tip.color.withValues(alpha: 0.2),
                  child: Icon(tip.icon, color: tip.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tip.title, style: theme.textTheme.titleSmall),
                      const SizedBox(height: 4),
                      Text(tip.description, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
      ],
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection({required this.tokens});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('자주 묻는 질문', style: theme.textTheme.titleMedium),
        SizedBox(height: tokens.gapSmall),
        for (final faq in kFaqItems) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.question_mark),
            ),
            title: Text(faq.question, style: theme.textTheme.bodyLarge),
            subtitle: faq.subtitle != null ? Text(faq.subtitle!) : null,
          ),
          Divider(height: tokens.gapSmall),
        ],
        Align(
          alignment: Alignment.center,
          child: TextButton(onPressed: () {}, child: const Text('더보기')),
        ),
      ],
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.tokens});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(tokens.gapLarge),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: tokens.radiusLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('원하는 검색결과가 없나요?', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('의견을 보내주시면 빠르게 살펴볼게요.', style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          AppButton.primary(label: '의견 보내기', onPressed: () {}),
        ],
      ),
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final String? highlight;
  const _ServiceItem({
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
    this.highlight,
  });
}

class _TipItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  const _TipItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _FaqItem {
  final String question;
  final String? subtitle;
  const _FaqItem(this.question, {this.subtitle});
}

const kRecommendedKeywords = ['예약', '예약 송금', '예약 이체', '약 알림 받기', '페이 결제'];

const kServiceItems = [
  _ServiceItem(
    icon: Icons.gamepad,
    color: Color(0xFF0080FF),
    highlight: '아이언 앤 ',
    title: '블러드',
    subtitle: '게임 바로가기',
  ),
  _ServiceItem(icon: Icons.public, color: Color(0xFF26C6DA), title: '해외여행 홈'),
  _ServiceItem(
    icon: Icons.search,
    color: Color(0xFF00BFA5),
    title: '아유워크',
    subtitle: '실시간 AI 검색',
  ),
  _ServiceItem(
    icon: Icons.school,
    color: Color(0xFFFFB74D),
    highlight: '영화진흥위원회 ',
    title: '국가기술자격 취득사항 확인서 발급',
    subtitle: '증명서 발급하기',
  ),
  _ServiceItem(
    icon: Icons.star_rate,
    color: Color(0xFFFFD54F),
    highlight: '토스뱅크 ',
    title: '아이와 용돈 미션하기',
  ),
];

const kTipItems = [
  _TipItem(
    title: '○○페이도 현금영수증 발급되나요?',
    description: '네, 발급돼요. 단, 결제수단이 \'계좌\'여야 해요.',
    icon: Icons.receipt_long,
    color: Color(0xFF4FC3F7),
  ),
  _TipItem(
    title: '해킹 사고, 피해를 막으려면?',
    description: '약 3,370만개 계정의 개인정보가 유출됐어요.',
    icon: Icons.lock_outline,
    color: Color(0xFF9575CD),
  ),
];

const kFaqItems = [
  _FaqItem('토스뱅크 굴비적금은 어떻게 만드나요?'),
  _FaqItem('토스뱅크의 거래중지(휴면)계좌는 어떻게 해제할 수 있나요?'),
  _FaqItem('토스뱅크 통장의 잔액 증명서는 어떻게 발급받나요?'),
];
