import 'package:flutter/material.dart';
import 'package:pong2/pong.dart';

class SinglePlayerScreen extends StatelessWidget {
  String imgPath;
   SinglePlayerScreen({Key? key,required this.imgPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body:Pong(imgPath: imgPath,),
      ),
    );
  }
}
