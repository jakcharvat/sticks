import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_game/bloc/bloc.dart';
import 'package:sticky_game/home_page.dart';
import 'package:sticky_game/options_page.dart';
import 'package:sticky_game/results_page.dart';
import 'package:sticky_game/simulation_page.dart';
import 'package:sticky_game/sticky_game_board.dart';
import 'package:sticky_game/game_management/sticky_game_manager.dart';
import 'package:sticky_game/alternate_sticky_game_board.dart';


void main() {  _setTargetPlatformForDesktop();

  runApp(MyApp());
}

void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;

  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.fuchsia;
  } else if (Platform.isWindows || Platform.isLinux) {
    targetPlatform = TargetPlatform.android;
  }

  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PrefsBloc bloc = PrefsBloc();

    bloc.dispatch(GetPrefs());

    return BlocProvider<PrefsBloc>(
      builder: (context) => bloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NIM',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color(0xFF343435),
        ),
        routes: {
          "/": (BuildContext context) => StickyGameHome(),
//        "/": (_) => BlurTest()
        },
      ),
    );
  }
}

class StickyGameHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Simulate", style: TextStyle(color: Theme.of(context).primaryColor),),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SimulationPage()));
        },
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 0.0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: HomePage(),
    );
  }
}

class StickyGameOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: OptionsPage(),
    );
  }
}

class StickyGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: BlocBuilder<PrefsBloc, PrefsState>(
          builder: (context, state) {
            if (state is PrefsSetState) {
              return state.autoRemove.shouldAutomaticallyRemoveSticks ? StickyGameBoard() : AlternateStickyGameBoard();
            }

            return Container();
          },
        ),
      ),
    );
  }
}

class StickyGameResults extends StatelessWidget {

  final Player winner;
  final bool isAiPlaying;
  final Player aiPlayer;

  StickyGameResults({
    @required this.winner,
    @required this.isAiPlaying,
    this.aiPlayer,
  }) : assert(
    !isAiPlaying || (isAiPlaying && aiPlayer != null),
    "You must specify which player the AI was representing if AI is playing."
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ResultsPage(
        winner: winner,
        isAiPlaying: isAiPlaying,
        aiPlayer: aiPlayer,
      )
    );
  }
}

