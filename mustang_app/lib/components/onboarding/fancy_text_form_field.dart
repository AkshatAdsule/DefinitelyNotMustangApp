import 'package:flutter/material.dart';

class FancyTextFormField extends FormField<String> {
  FancyTextFormField({
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    String initialValue = "",
    bool autovalidate = false,
    bool obscureText = false,
    TextEditingController controller,
    String hintText = "",
    String title = "",
    Widget prefixIcon,
    Widget suffixIcon,
    FocusNode focusNode,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<String> state) {
            return Column(
              children: [
                Visibility(
                  visible: !title.isEmpty,
                  child: Container(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 5, left: 5),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green.shade400,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    focusNode: focusNode,
                    obscureText: obscureText,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    controller: controller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 14),
                      hintText: hintText,
                      border: InputBorder.none,
                      prefixIcon: prefixIcon,
                      suffixIcon: suffixIcon,
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: state.hasError,
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.flag_outlined,
                            color: Colors.redAccent.shade400,
                            size: 20,
                          ),
                        ),
                        Text(
                          state.errorText ?? "",
                          style: TextStyle(
                            color: Colors.redAccent.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 5, left: 13),
                  ),
                ),
              ],
            );
          },
        );
}
