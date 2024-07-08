import 'package:go_router/go_router.dart';
import 'package:kaist_summer_camp_second_week/community/screen/community_written.dart';
import 'package:kaist_summer_camp_second_week/find/screen/my_findemailinit.dart';
import 'package:kaist_summer_camp_second_week/find/screen/my_findemailnext.dart';
import 'package:kaist_summer_camp_second_week/find/screen/my_findpwdinit.dart';
import 'package:kaist_summer_camp_second_week/find/screen/my_findpwdnext.dart';
import 'package:kaist_summer_camp_second_week/home_screen.dart';
import 'package:kaist_summer_camp_second_week/search/model/plant_model.dart';
import 'package:kaist_summer_camp_second_week/search/screen/search.dart';
import 'package:kaist_summer_camp_second_week/search/screen/search_detail.dart';
import 'package:kaist_summer_camp_second_week/search/screen/search_result.dart';
import 'package:kaist_summer_camp_second_week/user/screen/my_pageafterlogin.dart';
import 'package:kaist_summer_camp_second_week/weather/screen/weather.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => WeatherPage(),
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
              throw('label is required');
            }

            return SearchResultPage(label: state.pathParameters['label']!);
          },
          redirect: (context, GoRouterState state) {
            return null;
          },
          routes: [
            GoRoute(path: 'detail/:index', builder: (context, state) {
              final label = state.pathParameters['label'];
              if (state.pathParameters['index'] == null) {
                throw('index is required');
              }
              if (state.pathParameters['label'] == null) {
                throw('label is required');
              }

              final index = int.parse(state.pathParameters['index']!);
              return SearchDetailPage(plant: plants[label]!.values.elementAt(index),);
            }),
          ]
        ),

// home screen --> user my page
        GoRoute(path: 'user', builder: (context, state) {
          return MyPageAfterLogin();
        }),
      ],
    ),
  ],
);
