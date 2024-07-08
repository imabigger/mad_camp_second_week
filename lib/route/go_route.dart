import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaist_summer_camp_second_week/auth/provider/auth_provider.dart';
import 'package:kaist_summer_camp_second_week/auth/screen/my_login.dart';
import 'package:kaist_summer_camp_second_week/auth/screen/my_pagebeforelogin.dart';
import 'package:kaist_summer_camp_second_week/home_screen.dart';
import 'package:kaist_summer_camp_second_week/search/model/plant_model.dart';
import 'package:kaist_summer_camp_second_week/search/screen/search.dart';
import 'package:kaist_summer_camp_second_week/search/screen/search_detail.dart';
import 'package:kaist_summer_camp_second_week/search/screen/search_result.dart';
import 'package:kaist_summer_camp_second_week/user/screen/my_accountsetting.dart';
import 'package:kaist_summer_camp_second_week/user/screen/my_communityrecord.dart';
import 'package:kaist_summer_camp_second_week/user/screen/my_pageafterlogin.dart';
import 'package:kaist_summer_camp_second_week/user/screen/my_privateinfosetting.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
      routes: [
// home screen --> search page
        GoRoute(
          path: 'search',
          builder: (context, state) => SearchPage(),
          redirect: (context, GoRouterState state) {
            return null;
          },
        ),
        GoRoute(
            path: 'search/:label',
            builder: (context, state) {
              if (state.pathParameters['label'] == null) {
                throw ('label is required');
              }

              return SearchResultPage(label: state.pathParameters['label']!);
            },
            redirect: (context, GoRouterState state) {
              return null;
            },
            routes: [
              GoRoute(
                  path: 'detail/:index',
                  builder: (context, state) {
                    final label = state.pathParameters['label'];
                    if (state.pathParameters['index'] == null) {
                      throw ('index is required');
                    }
                    if (state.pathParameters['label'] == null) {
                      throw ('label is required');
                    }

                    final index = int.parse(state.pathParameters['index']!);
                    return SearchDetailPage(
                      plant: plants[label]!.values.elementAt(index),
                    );
                  }),
            ]),

// home screen --> user my page
        GoRoute(
            path: 'user',
            builder: (context, state) {
              return MyPageAfterLogin();
            },
            redirect: (context, GoRouterState state) {
              final authState =
                  ProviderScope.containerOf(context).read(authProvider);
              if (authState.isLoggedIn == false) {
                return '/auth';
              }
              return null;
            },
            routes: [
              GoRoute(
                  path: 'setting',
                  builder: (context, state) {
                    return MyAccountSettingPage();
                  },
                routes: [
                  GoRoute(
                    path: 'private',
                    builder: (context, state) {
                      return MyPrivateInfoSettingPage();
                    },
                  ),
                ]
              ),
              GoRoute(
                path: 'posts',
                builder: (context, state) {
                  return MyCommunityRecordPage();
                },
              ),
            ]),

// home screen --> auth page
        GoRoute(
          path: 'auth',
          builder: (context, state) {
            return MyPageBeforeLogin();
          },
          routes: [
            GoRoute(
                path: 'login',
                builder: (context, state) {
                  return MyLoginPage();
                },
                redirect: (context, GoRouterState state) {
                  final authState =
                      ProviderScope.containerOf(context).read(authProvider);
                  if (authState.isLoggedIn == true) {
                    return '/user';
                  }
                  return null;
                }),
            GoRoute(
                path: 'signup',
                builder: (context, state) {
                  return MyLoginPage();
                }),
          ],
        ),
      ],
    ),
  ],
);