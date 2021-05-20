import 'package:flutter/material.dart';

class ModeToggleChild extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final Color selectedColor, unselectedColor;

  ModeToggleChild({
    @required this.icon,
    @required this.isSelected,
    this.selectedColor = Colors.white,
    this.unselectedColor = Colors.green,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(
        icon,
        color: isSelected ? selectedColor : unselectedColor,
      ),
    );
  }
}

class ModeToggle extends StatelessWidget {
  final void Function(int) onPressed;
  final List<bool> isSelected;
  final List<ModeToggleChild> children;
  final Key key;
  final bool isDisabled, renderBorder;
  final Color selectedColor,
      disabledColor,
      disabledBorderColor,
      fillColor,
      borderColor,
      selectedBorderColor;
  final Axis direction;
  final double borderWidth;
  final BorderRadius borderRadius;

  ModeToggle({
    @required this.children,
    @required this.onPressed,
    @required this.isSelected,
    this.key,
    this.isDisabled = false,
    @required this.direction,
    this.borderWidth = 3,
    this.borderRadius,
    this.selectedColor = Colors.green,
    this.disabledBorderColor = Colors.green,
    this.disabledColor = Colors.green,
    this.borderColor = Colors.green,
    this.fillColor = Colors.green,
    this.renderBorder = true,
    this.selectedBorderColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ToggleButtons(
        key: key,
        children: children,
        onPressed: isDisabled
            ? null
            : (int val) {
                onPressed(val);
              },
        isSelected: isSelected,
        selectedColor: selectedColor,
        disabledColor: disabledColor,
        disabledBorderColor: disabledBorderColor,
        renderBorder: renderBorder,
        direction: direction,
        borderRadius: borderRadius ?? BorderRadius.circular(30),
        borderColor: borderColor,
        borderWidth: borderWidth,
        selectedBorderColor: selectedBorderColor,
        fillColor: fillColor,
      ),
    );
  }
}
