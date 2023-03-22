import 'package:flutter/material.dart';

import 'pong.dart';
import 'pong2.dart';

class DoublePlayerScreen extends StatelessWidget {
  const DoublePlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: PongDouble(),
      ),
    );
  }
}
