import 'package:flutter/material.dart';

// input type
// hint text
// input names
// callback for submit
// required
//

enum InputType {
  TEXTAREA,
  TEXT,
  CHECKBOX,
  SLIDER,
  RADIO,
  DROPDOWN,
  SWITCH,
}

class FormChild {
  InputType _inputType;
  String _placeholder;
  String _inputName;
  bool _required;
  List<List<String>> _multiSelectOptions;
  FormChild(this._inputType, this._inputName, this._placeholder, this._required,
      {List<List<String>> multiSelectOptions}) {
    _multiSelectOptions = multiSelectOptions;
  }
  String get placeholder => _placeholder;
  String get inputName => _inputName;
  InputType get inputType => _inputType;
  bool get isRequired => _required;
  List<List<String>> get multiSelectOptions => _multiSelectOptions;
}

class FormCreator extends StatefulWidget {
  List<FormChild> _children;
  void Function() _submitCallback;
  List<int> _struct;
  FormCreator(this._children, this._struct, this._submitCallback);

  @override
  _FormCreatorState createState() =>
      _FormCreatorState(this._children, this._struct, this._submitCallback);
}

class _FormCreatorState extends State<FormCreator> {
  GlobalKey _formKey = GlobalKey();
  List<FormChild> _children;
  List<int> _struct;

  void Function() _submitCallback;

  _FormCreatorState(this._children, this._struct, this._submitCallback);

  @override
  Widget build(BuildContext context) {
    List<Widget> formChildren = [];
    int current = 0;
    int multiSelectCounter = 0;
    for (int i = 0; i < _struct.length; i++) {
      int layout = _struct[i];
      double sizing = 12 / layout;
      List<Widget> rowChildren = [];
      for (int k = 0; k < layout; k++) {
        FormChild currentChild = _children[current];
        switch (currentChild.inputType) {
          case InputType.TEXT:
            {
              rowChildren.add(TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: currentChild.placeholder,
                ),
                validator: (String text) {
                  if (text.isEmpty && currentChild.isRequired) {
                    return 'Please enter a ' + currentChild.placeholder;
                  }
                  return null;
                },
              ));
              break;
            }
          case InputType.TEXTAREA:
            {
              rowChildren.add(TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: currentChild.placeholder,
                ),
                keyboardType: TextInputType.multiline,
                validator: (String text) {
                  if (text.isEmpty && currentChild.isRequired) {
                    return 'Please enter a ' + currentChild.placeholder;
                  }
                  return null;
                },
              ));
              break;
            }
          case InputType.CHECKBOX:
            {
              rowChildren.add(FormField<bool>(
                builder: (formFieldState) => CheckboxListTile(
                  value: null,
                  onChanged: (bool newVal) {},
                  title: Text(currentChild.placeholder),
                ),
                validator: (bool val) {
                  return null;
                },
              ));
              break;
            }
          case InputType.DROPDOWN:
            {
              rowChildren.add(
                FormField<String>(
                  builder: (formFieldState) => DropdownButton<String>(
                    value: null,
                    items: currentChild.multiSelectOptions[multiSelectCounter]
                        ?.map<DropdownMenuItem<String>>((String val) =>
                            DropdownMenuItem<String>(
                                value: null, child: Text(val))),
                    onChanged: (String newVal) {},
                  ),
                  validator: (String val) {
                    return null;
                  },
                ),
              );
              multiSelectCounter++;
              break;
            }
          case InputType.SWITCH:
            {
              rowChildren.add(
                FormField<bool>(
                  builder: (formFieldState) => SwitchListTile(
                    value: null,
                    onChanged: (bool newVal) {},
                    title: Text(currentChild.placeholder),
                  ),
                  validator: (bool newVal) {
                    return null;
                  },
                ),
              );
              break;
            }
          case InputType.RADIO:
            {
              rowChildren.add(FormField<String>(
                  builder: (formFieldState) => RadioListTile(
                      value: null, groupValue: null, onChanged: null)));
              break;
            }
          default:
            break;
        }
        current++;
      }
      formChildren.add(
        Row(
          children: rowChildren,
        ),
      );
    }
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          children: formChildren,
        ),
      ),
    );
  }
}
