import 'package:flutter/material.dart';
import 'package:sticky_game/components/stick_outline_button.dart';

import 'main.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "NIM",
            style: TextStyle(
              fontSize: 50.0,
              fontFamily: "Roboto Slab",
              color: Colors.white,
            ),
          ),
          SizedBox(height: 40.0,),
          Text(
            "Let's play",
            style: TextStyle(
              fontSize: 30.0,
              fontFamily: "Roboto Slab",
              color: Colors.white,
            ),
          ),
          SizedBox(height: 40.0,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StickOutlineButton(
                child: Text(
                  "OPTIONS",
                  style: TextStyle(
                    fontSize: 20.0
                  ),
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => StickyGameOptions()
                )),
              ),
              SizedBox(width: 8.0,),
              RaisedButton(
                color: Colors.white,
                child: Text(
                  "PLAY",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => StickyGamePage()
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
