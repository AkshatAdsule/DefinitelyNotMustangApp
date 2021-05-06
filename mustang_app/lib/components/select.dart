import 'package:flutter/material.dart';

class Select<T> extends StatelessWidget {
  final T value;
  final void Function(T val) onChanged;
  final List<DropdownMenuItem<T>> items;

  Select(
      {@required this.value, @required this.onChanged, @required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<T>(
        value: value,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(
          fontSize: 14,
          color: Colors.green[300],
          fontWeight: FontWeight.bold,
        ),
        underline: Container(
          height: 2,
          color: Colors.grey[500],
        ),
        onChanged: (T val) {
          onChanged(val);
        },
        items: items,
      ),
    );
  }
}
