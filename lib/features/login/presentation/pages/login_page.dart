import 'package:flutter/material.dart';
import 'package:triviaapp/core/constants/strings.dart';
import 'package:triviaapp/features/theme_select/presentation/widgets/theme_widgets.dart';
import 'package:triviaapp/features/login/presentation/widgets/login_widget.Dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.LOGIN_PAGE_TITLE),
        actions: <Widget>[
          Padding(padding: EdgeInsets.only(right: 20.0), child: ThemeSwitch()),
        ],
      ),
      body: LoginWidget(),
    );
  }
}
