import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_salary/core/observers/go_router_observer.dart';
import 'package:manage_salary/ui/home/home_screen.dart';
import 'package:manage_salary/ui/main/main_screen.dart';

// Import your screens here
// import 'package:lotus_cex/presentation_layer/screens/home_screen.dart';
// import 'package:lotus_cex/presentation_layer/screens/login_screen.dart';

// Define route names as constants for easier reference
class AppRoutes {
  static const home = '/home';
  static const main = '/';
  static const market = '/market';
  static const buyCrypto = '/buy-crypto';
  static const trade = '/trade';
  static const tradeSpot = '/trade/spot';
  static const tradeMargin = '/trade/margin';
  static const tradeP2p = '/trade/p2p';
  static const derivatives = '/derivatives';
  static const derivativesFutures = '/derivatives/futures';
  static const derivativesOptions = '/derivatives/options';
  static const finance = '/finance';
  static const financeSavings = '/finance/savings';
  static const financeStaking = '/finance/staking';
  static const financeLoans = '/finance/loans';
  static const earn = '/earn';
  static const announcement = '/announcement';
  static const login = '/login';
  static const signup = '/signup';
  static const profile = '/profile';
  static const settings = '/settings';
  static const downloads = '/downloads';
  static const exchangeCrypto = '/exchange/:cryptoName';
  static const money = '/money';
  static const swapAssets = '/swap-assets';
  static const coinSwapAssets = '/coin-swap-assets';
  static const secondAssets = '/setup-assets';
  static const financeAssets = '/finance-assets';
  static const walletHistory = '/wallet-history';
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

    // Disable GoRouter transitions
    routerNeglect: true,

    // Define routes without transitions for better web performance
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

      // Exchange route
      GoRoute(
        path: AppRoutes.exchangeCrypto,
        pageBuilder: (context, state) {
          final cryptoName = state.pathParameters['cryptoName'] ?? 'BTC';
          return _noTransitionPage(
            context: context,
            state: state,
            child: Scaffold(),
          );
        },
      ),

      // Buy Crypto route
      GoRoute(
        path: AppRoutes.buyCrypto,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Buy Crypto Screen'),
            ),
          ),
        ),
      ),

      // Trade routes
      GoRoute(
        path: AppRoutes.trade,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Trade Screen'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.tradeSpot,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Spot Trading Screen'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.tradeMargin,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Margin Trading Screen'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.tradeP2p,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('P2P Trading Screen'),
            ),
          ),
        ),
      ),

      // Derivatives routes
      GoRoute(
        path: AppRoutes.derivatives,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Derivatives Screen'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.derivativesFutures,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Futures Trading Screen'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.derivativesOptions,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Options Trading Screen'),
            ),
          ),
        ),
      ),

      // Finance routes
      GoRoute(
        path: AppRoutes.finance,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Finance Screen'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.financeSavings,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Savings Screen'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.financeStaking,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Staking Screen'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.financeLoans,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Loans Screen'),
            ),
          ),
        ),
      ),

      // Earn route
      GoRoute(
        path: AppRoutes.earn,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Earn Screen'),

            ),
          ),
        ),
      ),

      // Announcement route
      GoRoute(
        path: AppRoutes.announcement,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Announcement Screen'),
            ),
          ),
        ),
      ),

      // Authentication routes
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(),
        ),
      ),
      GoRoute(
        path: AppRoutes.signup,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Sign Up Screen'),
            ),
          ),
        ),
      ),

      // Profile route
      GoRoute(
        path: AppRoutes.profile,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: const Center(child: Text('Profile Screen')),
          ),
        ),
      ),

      // Settings route
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) {
          // Example of handling query parameters
          final tab = state.uri.queryParameters['tab'] ?? 'general';
          return _noTransitionPage(
            context: context,
            state: state,
            child: Scaffold(
              appBar: AppBar(title: const Text('Settings')),
              body: Center(child: Text('Settings Tab: $tab')),
            ),
          );
        },
      ),

      // Downloads route
      GoRoute(
        path: AppRoutes.downloads,
        pageBuilder: (context, state) => _noTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Downloads Screen'),
            ),
          ),
        ),
      ),
      ShellRoute(
        navigatorKey: walletShellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return Container(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.money,
            builder: (BuildContext context, GoRouterState state) {
              return const Text("Screen A");
            },
          ),
          GoRoute(
            path: AppRoutes.swapAssets,
            builder: (BuildContext context, GoRouterState state) {
              return const Text("Screen B");
            },
          ),
          GoRoute(
            path: AppRoutes.coinSwapAssets,
            builder: (BuildContext context, GoRouterState state) {
              return const Text("Screen C");
            },
          ),
        ],
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
