// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:kht_gold/core/app/colors/app_colors.dart';
import 'package:kht_gold/core/navigator/app_routes.dart';
import 'package:kht_gold/features/home/presentation/screens/home_screen.dart';

part 'app_router.g.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "_rootNavigatorKey");

  late final GoRouter router;
  static final AppRouter instance = AppRouter._internal();

  bool isLoadingShown = false;

  AppRouter._internal() {
    router = GoRouter(
      routes: $appRoutes,
      navigatorKey: _rootNavigatorKey,
      initialLocation: Routes.rootRoute,
    );
  }

  void pop() {
    if (!canPop) return;

    if (isLoadingShown) {
      isLoadingShown = false;
    }

    router.pop();
  }

  bool get canPop => state.canPop();

  String get currentRoute => router.state.matchedLocation;

  static BuildContext? get context => _rootNavigatorKey.currentContext;

  static NavigatorState get state => _rootNavigatorKey.currentState!;

  void popLoading() {
    if (_rootNavigatorKey.currentState == null) return;

    if (!canPop || !isLoadingShown) {
      return;
    }

    isLoadingShown = false;
    _rootNavigatorKey.currentState?.pop();
  }

  void showLoading({String? title}) {
    if (isLoadingShown) {
      return;
    }

    isLoadingShown = true;

    try {
      Navigator.of(context!, rootNavigator: true).push(
        PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.black26,
          pageBuilder: (context, _, __) {
            return PopScope(canPop: false, child: CircleLoading(title: title));
          },
          transitionDuration: Duration.zero,
        ),
      );
    } catch (e) {
      isLoadingShown = false;
    }
  }
}

@TypedGoRoute<RootRoute>(path: Routes.rootRoute, name: Routes.rootRoute)
class RootRoute extends GoRouteData with $RootRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

class CircleLoading extends StatelessWidget {
  final String? title;
  const CircleLoading({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            title != null
                ? DefaultTextStyle(
                    style: TextStyle(fontSize: 13.sp, color: mCL),
                    child: Text(title!),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
