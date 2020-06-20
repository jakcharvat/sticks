import 'package:flutter/material.dart';
import 'package:sticky_game/components/cupertino_pull_down_button.dart';
import 'package:sticky_game/components/option_description.dart';

class OptionsPage extends StatefulWidget {
  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {

  String _opponentType = "🤖 Computer";
  bool _aiGoesFirst = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          height: 80.0,
          child: Container(
            color: Colors.white.withOpacity(0.1),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  left: 16.0,
                  child: IconButton(
                    highlightColor: Colors.white.withOpacity(0.05),
                    splashColor: Colors.white.withOpacity(0.15),
                    hoverColor: Colors.white.withOpacity(0.05),
                    focusColor: Colors.transparent,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Text(
                  "NIM Options",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: "Roboto Slab",
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Spacer(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _buildDescriptions(),
                  ),
                  SizedBox(width: 16.0,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _buildControls(),
                  ),
                  Spacer(),
                ],
              ),
            )
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDescriptions() {
    return <Widget>[
      OptionDescription("Opponent Type:"),
      SizedBox(height: 10.0,),
      OptionDescription("Would you like to play first or second?")
    ];
  }

  List<Widget> _buildControls() {
    return <Widget>[
      CupertinoPullDownButton<String>(
        options: ["🤖 Computer", "🙋‍♂️ A Friend"],
        currentOption: _opponentType,
        onChanged: (dynamic newValue) {
          setState(() {
            _opponentType = newValue;
          });
        },
      ),
      SizedBox(height: 10.0,),
      CupertinoPullDownButton<String>(
        options: ["First", "Second"],
        currentOption: _aiGoesFirst ? "Second" : "First",
        onChanged: (dynamic newValue) => setState(() => _aiGoesFirst = newValue == "Second"),
        disabled: _opponentType == "🙋‍♂️ A Friend",
      ),
    ];
  }
}
