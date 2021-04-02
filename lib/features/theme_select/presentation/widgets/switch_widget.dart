import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:triviaapp/features/theme_select/cubit/theme_cubit.dart';

/* context.read<ThemeCubit>().updateAppTheme() */
class ThemeSwitch extends StatefulWidget {
  ThemeSwitch({Key key}) : super(key: key);

  @override
  _ThemeSwitchState createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Switch(
        value: isSwitched,
        onChanged: (value) {
          setState(() {
            isSwitched = value;
            BlocProvider.of<ThemeCubit>(context).updateAppTheme();
          });
        },
        activeTrackColor: Colors.yellow,
        activeColor: Colors.orangeAccent,
      ),
    );
  }
}
