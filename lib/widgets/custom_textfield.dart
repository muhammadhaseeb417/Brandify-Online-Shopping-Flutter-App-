import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Icon prefixIcon;
  final bool obsureText;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.obsureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.06,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.02),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: TextFormField(
          obscureText: obsureText,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            prefixIcon: prefixIcon,
          ),
        ),
      ),
    );
  }
}
