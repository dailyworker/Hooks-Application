
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/authentication/bloc/authentication_bloc.dart';
import 'package:frontend/home/home.dart';
import 'package:frontend/login/login.dart';
import 'package:frontend/splash/splash.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  const App({
    Key key,
    @required this.authenticationRepository,
    @required this.userRepository,
  }): assert(authenticationRepository != null),
      assert(userRepository != null),
      super(key : key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        ),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch(state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                    (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                LoginPage.route(),
                (route) => false
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}