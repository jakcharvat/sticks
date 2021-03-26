import 'package:flutter/material.dart';

class OptionDescription extends StatelessWidget {

  final String text;

  OptionDescription(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.0,
      alignment: Alignment.centerRight,
      child: Text(
        "$text",
        style: TextStyle(
            color: Colors.white,
          fontFamily: "Roboto Slab",
            fontSize: 16.0,
//        fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
