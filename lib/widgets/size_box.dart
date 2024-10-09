import 'package:flutter/material.dart';

class CustomSizeBox extends StatelessWidget {
  final int sizeList;
  final bool isSelected;

  CustomSizeBox({super.key, required this.sizeList, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15, // Increase the width
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color:
            isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
        border: isSelected ? null : Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(15),
      ),

      alignment: Alignment.center, // Center the text
      child: Text(
        sizeList.toString(),
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }
}
