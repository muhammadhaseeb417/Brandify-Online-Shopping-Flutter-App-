import 'package:flutter/material.dart';

class SettingContainor extends StatelessWidget {
  final String conainorText;
  final Color textColor;

  const SettingContainor({
    super.key,
    required this.conainorText,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.07,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            color: Colors.black26,
            blurRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              conainorText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: textColor,
              ),
            ),
            Opacity(
              opacity: 0.2,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
