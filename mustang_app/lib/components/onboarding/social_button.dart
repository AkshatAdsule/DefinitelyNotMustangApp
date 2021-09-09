import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget icon;
  const SocialButton({Key key, this.onPressed, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        color: Colors.white,
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}
