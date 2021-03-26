import 'package:flutter/material.dart';

class StickOutlineButton extends StatelessWidget {

  final Widget child;
  final VoidCallback onPressed;

  StickOutlineButton({
    @required this.child,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      textColor: Colors.white,
      highlightedBorderColor: Colors.white,
      borderSide: BorderSide(
        color: Colors.white.withOpacity(0.5),
        style: BorderStyle.solid,
        width: 3.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: child,
      onPressed: onPressed,
    );
  }
}
