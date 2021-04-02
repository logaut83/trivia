import 'package:flutter/material.dart';
import 'package:triviaapp/features/login/presentation/pages/login_page.dart';
import 'package:triviaapp/features/number_trivia/presentation/pages/number_trivia_page.dart';

class AppRouter {
  static const String home = "/";
  static const String trivia = "/trivia";

  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case trivia:
        return MaterialPageRoute(builder: (_) => NumberTriviaPage());
      default:
        return MaterialPageRoute(builder: (_) => NumberTriviaPage());
    }
  }
}
