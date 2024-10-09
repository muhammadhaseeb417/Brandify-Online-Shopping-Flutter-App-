import 'package:flutter/material.dart';

class EditProfileTextfield extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  const EditProfileTextfield({
    Key? key,
    required this.labelText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText, // Placeholder above the input text
          labelStyle: TextStyle(
            color: Colors.grey, // Make the label light grey
            fontSize: 25,
            // Adjust size if needed
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Set grey underline
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black54), // Set black underline when focused
          ),
          isDense: true, // Reduce the padding inside the TextFormField
          contentPadding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height *
                  0.017), // Adjust the padding if necessary
        ),
        style: TextStyle(
          fontSize: 18, // Style of the text (Lonnie Murphy)
          color: Colors.black,
          fontWeight: FontWeight.bold, // Make the input text bold
        ),
      ),
    );
  }
}
