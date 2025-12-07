import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base_app/ui/app_box.dart';
import 'package:go_router/go_router.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Column(
          children: [
            ListTile(
              leading: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(41, 43, 47, 1),
                  borderRadius: BorderRadius.circular(90),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color.fromRGBO(79, 85, 93, 1),
                  size: 35,
                ),
              ),
              title: Text(
                '사용자 이름',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '프로필 및 계정 설정',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Color.fromRGBO(120, 120, 128, 1),
                ),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {},
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              child: Column(
                children: [
                  // 기본 설정
                  AppBox(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Text(
                            '언어',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Color.fromRGBO(79, 85, 93, 1),
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Text(
                            '알림',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Color.fromRGBO(79, 85, 93, 1),
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Text(
                            '화면 테마',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Color.fromRGBO(79, 85, 93, 1),
                          ),
                          onTap: () => context.push('/setting/theme'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
