import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:triviaapp/core/constants/strings.dart';
import 'package:triviaapp/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:triviaapp/features/number_trivia/presentation/widgets/trivia_widgets.dart';
import 'package:triviaapp/features/theme_select/presentation/widgets/theme_widgets.dart';
import 'package:triviaapp/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.TRIVIA_PAGE_TITLE),
        actions: <Widget>[
          Padding(padding: EdgeInsets.only(right: 20.0), child: ThemeSwitch()),
        ],
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top Half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is NumberTriviaIntitalState) {
                    return MessageDisplay(
                        message: Strings.TRIVIA_PAGE_SEARCHING);
                  } else if (state is ErrorState) {
                    return MessageDisplay(message: state.message);
                  } else if (state is LoadingState) {
                    return LoadingWidget();
                  } else if (state is LoadedState) {
                    return TriviaDisplay(trivia: state.trivia);
                  }
                  return Container(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Placeholder());
                },
              ),
              SizedBox(height: 20),
              // Bottom Half
              TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}

class TriviaControls extends StatefulWidget {
  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String inputStr;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: Strings.TRIVIA_PAGE_INPUT),
          onChanged: (value) {
            inputStr = value;
          },
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                  child: Text(Strings.TRIVIA_PAGE_GET_TRIVIA),
                  color: Theme.of(context).accentColor,
                  textTheme: ButtonTextTheme.primary,
                  onPressed: dispatchConrete),
            ),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                  child: Text(Strings.TRIVIA_PAGE_GET_RANDOM),
                  textTheme: ButtonTextTheme.primary,
                  onPressed: dispatchRandom),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConrete() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumberEvent(inputStr));
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForRandomNumberEvent());
  }
}
