// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:preny/core/navigator/app_navigator_observer.dart';
import 'package:preny/core/navigator/app_routes.dart';
import 'package:preny/core/navigator/app_scaffold.dart';
import 'package:preny/features/home/presentation/screens/home_screen.dart';

class AppNavigator extends RouteObserver<PageRoute<dynamic>> {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static GlobalKey<NavigatorState> navigatorHomeKey = GlobalKey();

  Route<dynamic> getRoute(RouteSettings settings) {
    // final Map<String, dynamic>? arguments = _getArguments(settings);

    switch (settings.name) {
      case Routes.rootRoute:
        return _buildRoute(
          settings,
          const HomeScreen(),
        );
      // Authenication
      case Routes.authenticationRoute:
        return _buildRoute(
          settings,
          const Scaffold(),
        );
      default:
        return _buildRoute(
          settings,
          const Scaffold(),
        );
    }
  }

  _buildRoute(
    RouteSettings routeSettings,
    Widget builder,
  ) {
    return MaterialPageRoute(
      builder: (context) => AppScaffold(
        child: builder,
      ),
      settings: routeSettings,
    );
  }

  Future? push<T>(
    String route, {
    Object? arguments,
    bool forceRootState = false,
  }) {
    final bool hasMatchConditions = _middlewareRouter(route, arguments);

    if (hasMatchConditions) return null;

    return _currentState(route).pushNamed(route, arguments: arguments);
  }

  static Future pushNamedAndRemoveUntil<T>(
    String route, {
    Object? arguments,
  }) {
    if (route == Routes.rootRoute) {
      AppNavigatorObserver.resetRoutes();
    }

    return _currentState(route).pushNamedAndRemoveUntil(
      route,
      (route) => false,
      arguments: arguments,
    );
  }

  static Future? replaceWith<T>(
    String route, {
    Map<String, dynamic>? arguments,
  }) {
    return _currentState(route)
        .pushReplacementNamed(route, arguments: arguments);
  }

  static void popUntil<T>(String routeName) {
    state.popUntil((route) {
      if (route.isFirst) return true;

      return route.settings.name == routeName;
    });
  }

  static void pop() {
    if (!canPop) return;

    _currentState(AppNavigatorObserver.currentRouteName).pop();
  }

  // _getArguments(RouteSettings settings) {
  //   return settings.arguments;
  // }

  static NavigatorState _currentState(String? route) {
    return state;
  }

  static bool get canPop =>
      _currentState(AppNavigatorObserver.currentRouteName).canPop();

  static String? currentRoute() => AppNavigatorObserver.currentRouteName;

  static BuildContext? get context => navigatorKey.currentContext;

  static NavigatorState get state => navigatorKey.currentState!;
}

extension AppNavigatorX on AppNavigator {
  bool _middlewareRouter(
    String route,
    Object? arguments,
  ) {
    if (shouldBeShowPopupInstrealOfScreen(route: route)) {
      // bool flagShowingDialog = false;
      // for (final String? routeName in AppNavigatorObserver.routeNames) {
      //   if (routeName != null && popupInstrealOfScreen.contains(routeName)) {
      //     flagShowingDialog = true;
      //     break;
      //   }
      // }

      // showDialogPrenybus(
      //   routeName: route,
      //   duration: 200.milliseconds.inMilliseconds,
      //   maxHeight: 100.h,
      //   maxWidth: 400.sp,
      //   barrierColor: flagShowingDialog ? Colors.transparent : null,
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(16.sp),
      //     child: SizedBox(
      //       height: !SizerUtil.isLandscape ? 80.h : 90.h,
      //       child: AppScaffold(
      //         child: getWidgetByRoute(
      //           route: route,
      //           arguments: arguments as Map<String, dynamic>?,
      //         ),
      //       ),
      //     ),
      //   ),
      // );

      return true;
    }

    return false;
  }

  bool shouldBeShowPopupInstrealOfScreen({required String route}) {
    // if (SizerUtil.isMobile) return false;

    return popupInstrealOfScreen.contains(route);
  }

  List<String> get popupInstrealOfScreen => [];

  Widget getWidgetByRoute({
    required String route,
    Map<String, dynamic>? arguments,
  }) {
    switch (route) {
      default:
        return const SizedBox();
    }
  }
}
