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
    Widget prefixIcon,
    Widget suffixIcon,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<String> state) {
            return Column(
              children: [
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
                )
              ],
            );
          },
        );
}
