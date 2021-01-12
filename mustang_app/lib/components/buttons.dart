import 'package:flutter/material.dart';

class TextButton extends StatelessWidget {
  ButtonStyle style;
  ButtonType type;
  void Function() onPressed;
  String text = '';

  TextButton({this.style, this.type, this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.green;
    Color borderColor = Colors.black;
    double borderWidth = 2;
    switch (type) {
      case ButtonType.MAKE:
        if (this.text == 'In') {
          borderColor = Colors.white;
          borderWidth = 3;
        }
        break;
      case ButtonType.MISS:
        color = Colors.deepPurple;
        break;
      case ButtonType.PAGEBUTTON:
        color = Colors.white;
        break;
      default:
        break;
    }
    switch (style) {
      case ButtonStyle.RAISED:
        return RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderWidth),
              side: BorderSide(color: borderColor, width: borderWidth)),
          color: color,
          onPressed: this.onPressed,
          child: Text(text),
        );
        break;
      case ButtonStyle.OUTLINED:
        return OutlineButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderWidth),
              side: BorderSide(color: borderColor, width: borderWidth)),
          color: color,
          onPressed: this.onPressed,
          child: Text(text),
        );
        break;
      case ButtonStyle.FLAT:
        return FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderWidth),
              side: BorderSide(color: borderColor, width: borderWidth)),
          color: color,
          onPressed: this.onPressed,
          child: Text(text),
        );
        break;
      default:
        return null;
    }
  }
}

enum ButtonStyle { RAISED, OUTLINED, FLAT }

enum ButtonType { MAKE, MISS, PAGEBUTTON, ELEMENT, TOGGLE }
