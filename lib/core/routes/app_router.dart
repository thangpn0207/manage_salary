import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_salary/core/observers/go_router_observer.dart';
import 'package:manage_salary/ui/home/home_screen.dart';
import 'package:manage_salary/ui/main/main_screen.dart';
import 'package:manage_salary/ui/travel_note/trip_detail_screen.dart';

import '../../ui/travel_note/trip_list_screen.dart';

// Import your screens here
// import 'package:lotus_cex/presentation_layer/screens/home_screen.dart';
// import 'package:lotus_cex/presentation_layer/screens/login_screen.dart';

// Define route names as constants for easier reference
class AppRoutes {
  static const home = '/home';
  static const main = '/';
  static const trips = '/trips';
  static const tripDetail = '$trips/:id';
  static const addAction = '$tripDetail/add-action';
  static const summaryTrip = '$tripDetail/summary';
}

final navigatorKey = GlobalKey<NavigatorState>();
final walletShellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterObserver = GoRouterObserver();

// Custom transition builder that provides instant transitions with no animations
CustomTransitionPage<T> _noTransitionPage<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Return the child directly with no animation
      return child;
    },
    transitionDuration: Duration.zero,
  );
}

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    observers: [goRouterObserver],

    routerNeglect: true,

    routes: [
      // Main route
      GoRoute(
        path: AppRoutes.main,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const MainScreen(),
        ),
      ),
      // Home route
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.trips,
        builder: (context, state) => TripListScreen(),
      ),
      GoRoute(
        path: AppRoutes.tripDetail,
        builder: (context, state) =>
            TripDetailScreen(tripId: int.parse(state.pathParameters['id']!)),
      ),
    ],

    // Error page without transitions
    errorPageBuilder: (context, state) => _noTransitionPage(
      context: context,
      state: state,
      child: Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Text('No route found for ${state.uri.path}'),
        ),
      ),
    ),

    // Redirect logic
    redirect: (context, state) {
      // Example: check authentication and redirect if needed
      // final isAuthenticated = AuthService.isAuthenticated();
      // if (!isAuthenticated &&
      //     ![AppRoutes.login, AppRoutes.signup, AppRoutes.home].contains(state.path)) {
      //   return AppRoutes.login;
      // }
      return null; // No redirect
    },
  );
}
