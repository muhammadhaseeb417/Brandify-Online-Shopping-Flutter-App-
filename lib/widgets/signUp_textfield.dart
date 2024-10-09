import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUpTextFIeld extends StatelessWidget {
  final Icon icon;
  final bool obsurceText;
  final RegExp textFieldValidator;
  final String hintText;
  final void Function(String?) onSaved;

  const SignUpTextFIeld({
    super.key,
    required this.icon,
    this.obsurceText = false,
    required this.textFieldValidator,
    required this.hintText,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      validator: (value) {
        if (value != null && textFieldValidator.hasMatch(value)) {
          return null;
        } else {
          print("Enter a valid ${hintText}");
        }
      },
      obscureText: obsurceText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        prefixIcon: icon,
      ),
    );
  }
}
