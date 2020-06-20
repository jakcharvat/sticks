import 'package:flutter/material.dart';
import 'package:sticky_game/components/stick_outline_button.dart';
import 'package:sticky_game/game_management/sticky_game_manager.dart';

class ResultsPage extends StatelessWidget {

  final Player winner;
  final bool isAiPlaying;
  final Player aiPlayer;

  ResultsPage({
    @required this.winner,
    @required this.isAiPlaying,
    this.aiPlayer
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            endText,
            style: TextStyle(
              fontSize: 30.0,
              fontFamily: "Roboto Slab",
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20.0,),
          StickOutlineButton(
            child: Text("RETURN HOME"),
            onPressed: () => Navigator.of(context).pushReplacementNamed("/"),
          ),
        ],
      ),
    );
  }

  String get endText {
    if (isAiPlaying) {
      print("============== $aiPlayer : $winner");

      if (aiPlayer == winner) {
        return "Oh no, you lost 😢";
      }
      else {
        return "Yay, you won! Congrats! 🎉";
      }
    } else {
      return "${winner == Player.first ? "First" : "Second"} Player Won! Congrats 🎉";
    }
  }
}
