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
        value:  _getThemeState(),
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
        
          bool  _getThemeState() {return BlocProvider.of<ThemeCubit>(context).state.themeMode == ThemeMode.light ? false : true;}
}
