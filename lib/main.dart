import 'package:flutter/material.dart';
import 'package:pong2/anime_type.dart';
import 'package:pong2/opening_screen.dart';
import 'pong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pong Demo',
        debugShowCheckedModeBanner: false,
        color: Colors.grey,
        theme: ThemeData(
          backgroundColor: Colors.grey,
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: OpeningScreen(),
        ));
  }
}