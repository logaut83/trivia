import 'package:flutter/material.dart';
import 'package:rogueteam/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:rogueteam/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
          primaryColor: Colors.green.shade800,
          accentColor: Colors.green.shade600),
      home: NumberTriviaPage(),
    );
  }
}
