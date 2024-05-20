import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:user_tracking_flutter/routes/routes.dart';
import 'package:user_tracking_flutter/views/home_view.dart';
import 'package:user_tracking_flutter/views/login_view.dart';
import 'package:user_tracking_flutter/views/register_view.dart';

class RouteConfig {
  static RouteMap public = RouteMap(
      onUnknownRoute: (path) =>
          path == '/' ? const Redirect(Routes.login) : const NotFound(),
      routes: {
        Routes.login: (data) => const MaterialPage(child: LoginView()),
        Routes.register: (_) => const MaterialPage(child: RegisterView()),
      });

  static RouteMap protected = RouteMap(
    onUnknownRoute: (path) => const Redirect(Routes.home),
    routes: {
      Routes.home: (_) => const MaterialPage(child: HomeView()),
    },
  );
}
