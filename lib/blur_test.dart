import 'dart:ui';

import 'package:flutter/material.dart';

class BlurTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212121),
      body: Center(
        child: Container(
          width: 400.0,
          height: 400.0,
          child: Stack(
            children: <Widget>[
              Text(
                "0" * 1000
              ),
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaY: 8.0,
                  sigmaX: 8.0,
                ),
                child: Container(
                  child: Text(
                    "Hello World",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
