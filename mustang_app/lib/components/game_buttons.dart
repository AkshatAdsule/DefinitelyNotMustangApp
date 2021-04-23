import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ScoutingButton extends StatelessWidget {
  ButtonStyle style;
  ButtonType type;
  void Function() onPressed;
  String text = '';

  ScoutingButton({this.style, this.type, this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.green;
    Color borderColor = Colors.black;
    double borderWidth = 1;
    switch (type) {
      case ButtonType.MAKE:
        break;
      case ButtonType.MISS:
        color = Colors.deepPurple;
        break;
      case ButtonType.PAGEBUTTON:
        color = Colors.white;
        break;
      case ButtonType.TOGGLE:
        color = Colors.green.shade700;
        break;
      case ButtonType.COUNTER:
        color = Colors.yellow;
        borderWidth = 2;
        borderColor = Colors.black45;
        break;
      default:
        break;
    }
    switch (style) {
      case ButtonStyle.RAISED:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: color,
            onPrimary:
                type == ButtonType.PAGEBUTTON ? Colors.black : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderWidth),
                side: BorderSide(color: borderColor, width: borderWidth)),
          ),
          onPressed: this.onPressed,
          child: Text(text),
        );
        break;
      case ButtonStyle.OUTLINED:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            primary: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderWidth),
                side: BorderSide(color: borderColor, width: borderWidth)),
          ),
          onPressed: this.onPressed,
          child: Text(text),
        );
        break;
      case ButtonStyle.FLAT:
        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: color,
            primary: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderWidth),
                side: BorderSide(color: borderColor, width: borderWidth)),
          ),
          onPressed: this.onPressed,
          child: Text(text),
          // minWidth: 20,
        );
        break;
      default:
        return null;
    }
  }
}

enum ButtonStyle { RAISED, OUTLINED, FLAT }

enum ButtonType { MAKE, MISS, PAGEBUTTON, ELEMENT, TOGGLE, COUNTER }
