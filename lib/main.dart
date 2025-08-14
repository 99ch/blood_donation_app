import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app_export.dart';
import 'core/navigation_helper.dart';
import 'widgets/auth_guard.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser la configuration depuis le fichier .env
  await AppConfig.initialize();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Don de Sang',
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: globalMessengerKey,
          // Route initiale déterminée dynamiquement
          home: FutureBuilder<String>(
            future: NavigationHelper.getInitialRoute(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Initialisation...'),
                      ],
                    ),
                  ),
                );
              }

              final initialRoute =
                  snapshot.data ?? AppRoutes.gettingStartedScreen;
              final screenWidget = AppRoutes.routes[initialRoute]!(context);

              // Appliquer ProtectedRoute seulement si nécessaire
              if (NavigationHelper.isProtectedRoute(initialRoute)) {
                return ProtectedRoute(
                  routeName: initialRoute,
                  child: screenWidget,
                );
              }

              return screenWidget;
            },
          ),
          routes: _buildSelectiveProtectedRoutes(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }

  /// Construit les routes avec protection sélective d'authentification
  Map<String, WidgetBuilder> _buildSelectiveProtectedRoutes() {
    final Map<String, WidgetBuilder> routes = {};

    AppRoutes.routes.forEach((routeName, builder) {
      routes[routeName] = (context) {
        final widget = builder(context);

        // Protéger seulement les routes qui en ont besoin
        if (NavigationHelper.isProtectedRoute(routeName)) {
          return ProtectedRoute(
            routeName: routeName,
            child: widget,
          );
        }

        return widget;
      };
    });

    return routes;
  }
}
