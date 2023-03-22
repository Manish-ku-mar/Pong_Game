import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Ball extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double diam = 35;
    return Container(
      width: diam,
      height: diam,
      decoration:  BoxDecoration(
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
        ],
        shape: BoxShape.circle,
      ),
      //child: Lottie.network('https://assets7.lottiefiles.com/packages/lf20_ftw6w6vv.json'),
    );
  }
}