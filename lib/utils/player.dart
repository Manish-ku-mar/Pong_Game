import 'package:flutter/material.dart';

class Bat extends StatelessWidget {
  final double width;
  final double height;

  Bat(this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.shade300,
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(4, 4)),
            BoxShadow(
                color: Colors.white,
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(-4, -4))
          ]),
    );
  }
}