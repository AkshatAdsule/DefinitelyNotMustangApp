import 'package:flutter/material.dart';

class TextButton extends StatelessWidget {
  ButtonType type;
  Color color;
  void Function() onPressed;
  String text;
  double borderRadius;

  TextButton(
      {this.type, this.color, this.onPressed, this.text, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.RAISED:
        return RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          color: this.color,
          onPressed: this.onPressed,
          child: Text(text),
        );
        break;
      case ButtonType.OUTLINED:
        return OutlineButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          color: this.color,
          onPressed: this.onPressed,
          child: Text(text),
        );
        break;
      case ButtonType.FLAT:
        return FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          color: this.color,
          onPressed: this.onPressed,
          child: Text(text),
        );
        break;
      default:
        return null;
    }
  }
}

enum ButtonType {
  RAISED,
  OUTLINED,
  FLAT,
}
