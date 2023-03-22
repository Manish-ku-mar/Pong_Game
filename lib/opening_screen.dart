import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pong2/2player.dart';
import 'anime_type.dart';

class OpeningScreen extends StatefulWidget {
  OpeningScreen({Key? key}) : super(key: key);

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller1;
  late final AnimationController _controller2;

  bool singlePlayer = false;
  bool multiPlayer = false;
  late String activeButton = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller1 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    );
    _controller1.addListener(() {
      print(_controller1.value);
      if (_controller1.value > 0.1) {
        _controller1.value = 0.1;
      }
    });
    _controller2 =
        AnimationController(vsync: this, duration: Duration(seconds: 12));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        title: Center(
            child: Text(
          'Pong Game',
          style: GoogleFonts.pacifico(fontSize: 30, color: Colors.black),
        )),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Text(
                "Please choose the game ",
                style: GoogleFonts.pacifico(fontSize: 30),
              ),
            ),
            Text('type!!', style: GoogleFonts.pacifico(fontSize: 30)),
            if (singlePlayer == false && activeButton.isEmpty)
              SizedBox(
                height: 100,
              ),
            if (singlePlayer == false && activeButton.isEmpty)
              GestureDetector(
                onTap: () {
                  print("height${size.height}");
                  print("width${size.width}");
                  setState(() {
                    singlePlayer = true;
                    activeButton = "first";
                  });
                  _controller1.forward();
                  Timer(Duration(seconds: 3), () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => AnimeType()),
                        (Route route) => false);
                  });
                },
                child: Container(
                  height: size.height / 40 * 3,
                  width: size.width / 12 * 5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade300,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(4, 4)),
                        BoxShadow(
                            color: Colors.white,
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(-4, -4))
                      ]),
                  child: Center(
                      child: Text('1 Player',
                          style: GoogleFonts.pacifico(fontSize: 18))),
                ),
              ),
            if (multiPlayer == false && activeButton.isEmpty)
              SizedBox(
                height: 100,
              ),
            if (multiPlayer == false && activeButton.isEmpty)
              GestureDetector(
                onTap: () {
                  setState(() {
                    multiPlayer = true;
                    activeButton = "second";
                    print(activeButton);
                  });
                  _controller2.forward();
                  Timer(Duration(seconds: 4), () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => DoublePlayerScreen()),
                        (Route route) => false);
                  });
                },
                child: Container(
                  height: size.height / 40 * 3,
                  width: size.width / 12 * 5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade300,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(4, 4)),
                        BoxShadow(
                            color: Colors.white,
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(-4, -4))
                      ]),
                  child: Center(
                      child: Text('2 Player',
                          style: GoogleFonts.pacifico(fontSize: 18))),
                ),
              ),
            if (activeButton == "first")
              Container(
                height: size.height / 16 * 5,
                width: size.width / 6 * 5,
                child: Lottie.network(
                  'https://assets9.lottiefiles.com/packages/lf20_i9arxzcg.json',
                  controller: _controller1,
                ),
              )
            else if (activeButton == "second")
              Container(
                height: size.height / 16 * 5,
                width: size.width / 6 * 5,
                child: Lottie.network(
                    'https://assets9.lottiefiles.com/packages/lf20_i9arxzcg.json',
                    controller: _controller2),
              )
          ],
        ),
      ),
    );
  }
}
