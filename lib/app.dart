import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routemaster/routemaster.dart';
import 'package:user_tracking_flutter/blocs/auth/auth_bloc.dart';
import 'package:user_tracking_flutter/repositories/auth_repository.dart';
import 'package:user_tracking_flutter/routes/route_config.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(context.read<AuthRepository>()),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return MaterialApp.router(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData.light(
                // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              routerDelegate: RoutemasterDelegate(
                  routesBuilder: (context) => state.isAuth
                      ? RouteConfig.protected
                      : RouteConfig.public),
              routeInformationParser: const RoutemasterParser(),
            );
          },
        ),
      ),
    );
  }
}
