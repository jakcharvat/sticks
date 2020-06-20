import 'package:flutter/material.dart';
import 'package:sticky_game/blur_test.dart';
import 'package:sticky_game/home_page.dart';
import 'package:sticky_game/options_page.dart';
import 'package:sticky_game/results_page.dart';
import 'package:sticky_game/sticky_game_board.dart';

import 'game_management/sticky_game_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NIM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF3a3735)
//        primaryColor: Colors.white,
      ),
      routes: {
        "/": (BuildContext context) => StickyGameHome(),
//        "/": (_) => BlurTest()
      },
    );
  }
}

class StickyGameHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: StickyGameBoard(),
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

