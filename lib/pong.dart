import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pong2/anime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/ball.dart';
import 'utils/player.dart';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  final String imgPath;
  Pong({required this.imgPath});

  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  late double width;
  late double height;
  late double posX;
  late double posY;
  late double batWidth;
  late double batHeight;
  late double batPosition = 0;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  late Animation<double> animation;
  late AnimationController controller;
  double increment = 5;
  double randX = 1;
  double randY = 1;
  int score = 0;
  var highscore=0;


  //sound controller
  final assetsAudioPlayer = AssetsAudioPlayer();


  @override
  void initState() {
    super.initState();
    getValue();
    posX = 0;
    posY = 0;
    controller = AnimationController(
      duration: const Duration(minutes: 10),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      setState(() {
        checkBorders();
        (hDir == Direction.right)
            ? posX += ((increment * randX).round())
            : posX -= ((increment * randX).round());
        (vDir == Direction.down)
            ? posY += ((increment * randY).round())
            : posY -= ((increment * randY).round());
      });

      checkBorders();
    });

    controller.forward();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      height = constraints.maxHeight;
      width = constraints.maxWidth;
      batWidth = width / 3;
      batHeight = height / 16;
      var _colr = Colors.grey[200];
      return Stack(
        children: [
          Positioned(
            left: MediaQuery.of(context).size.width / 10,
            top: MediaQuery.of(context).size.height / 15,
            child: Container(
              height: MediaQuery.of(context).size.height / 10 * 8,
              width: MediaQuery.of(context).size.width / 10 * 8,
              child:FadeInImage(
                image:NetworkImage(widget.imgPath),
                placeholder: const AssetImage('assets/images/Loading_Bar.gif'),
                imageErrorBuilder:(context, error, stackTrace) {
                  return Image.asset('assets/images/no_internet.png',
                      fit: BoxFit.fitWidth
                  );
                },
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          if (score <= 2)
            Positioned(
              left: MediaQuery.of(context).size.width / 10,
              top: MediaQuery.of(context).size.height / 15,
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                height: MediaQuery.of(context).size.height / 10 * 8 / 4,
                width: MediaQuery.of(context).size.width / 10 * 8,
                color: _colr,
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 10,
              top: MediaQuery.of(context).size.height / 15 +
                  MediaQuery.of(context).size.height / 10 * 8 / 4,
              child: Container(
                height: MediaQuery.of(context).size.height / 10 * 8 / 4,
                width: MediaQuery.of(context).size.width / 10 * 8,
                color: score<=2?(Colors.grey[200]):Color(0x00000000),
              ),
            ),
          if (score <= 6)
            Positioned(
              left: MediaQuery.of(context).size.width / 10,
              top: MediaQuery.of(context).size.height / 15 +
                  MediaQuery.of(context).size.height / 10 * 8 / 4 * 2,
              child: Container(
                height: MediaQuery.of(context).size.height / 10 * 8 / 4,
                width: MediaQuery.of(context).size.width / 10 * 8,
                color: Colors.grey[200],
              ),
            ),
          if (score <= 8)
            Positioned(
              left: MediaQuery.of(context).size.width / 10,
              top: MediaQuery.of(context).size.height / 15 +
                  MediaQuery.of(context).size.height / 10 * 8 / 4 * 3,
              child: Container(
                height: MediaQuery.of(context).size.height / 10 * 8 / 4,
                width: MediaQuery.of(context).size.width / 10 * 8,
                color: Colors.grey[200],
              ),
            ),
          Positioned(
            top: MediaQuery.of(context).size.height / 50,
            left: MediaQuery.of(context).size.width /15,
            child: Text(
              'HighScore: ' + highscore.toString(),
              style: GoogleFonts.pacifico(fontSize: 30),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 50,
            right: MediaQuery.of(context).size.width / 15,
            child: Text(
              'Score: ' + score.toString(),
              style: GoogleFonts.pacifico(fontSize: 30),
            ),
          ),
          Positioned(
            child: Ball(),
            top: posY,
            left: posX,
          ),
          Positioned(
              bottom: 20,
              left: batPosition,
              child: GestureDetector(
                  onHorizontalDragUpdate: (DragUpdateDetails update) {
                    moveBat(update, context);
                    setState(() {
                      _colr=Color(0x00000000);
                    });
                  },
                  child: Bat(batWidth, batHeight))),
        ],
      );
    });
  }

  void checkBorders() {
    double diameter = 35;
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }
    if (posY >= height - diameter - batHeight && vDir == Direction.down) {
      if (posX >= (batPosition - diameter) &&
          posX <= (batPosition + batWidth + diameter)) {
        vDir = Direction.up;
        try
        {
          AssetsAudioPlayer.playAndForget(
              Audio("assets/images/jellybounce.mp3")
          );
          assetsAudioPlayer.play();
        }
        catch(error)
        {
          print(error);
        }
        randY = randomNumber();
        setState(() {
          score++;
        });
      } else {
        AssetsAudioPlayer.playAndForget(
            Audio("assets/images/thend.mp3")
        );
        assetsAudioPlayer.play();
        controller.stop();
        setHighscore();
        showMessage(context);
        assetsAudioPlayer.stop();
      }
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randX = randomNumber();
    }
  }

  void moveBat(DragUpdateDetails update, BuildContext context) {
    setState(() {
      batPosition += update.delta.dx;
    });
  }

  double randomNumber() {
    // var ran = new Random();
    // int myNum = ran.nextInt(1000);

    if (score >= 0 && score <= 10)
      return 1.1;
    else if (score > 10 && score <= 15) return 1.2;
    else if (score > 15 && score <= 20) return 1.4;
    else if (score > 20 && score <= 25) return 1.6;
    else if (score > 25 && score <= 35) return 1.8;
    else if (score > 35 && score <= 45) return 2.0;
    else if (score > 45 && score <= 55) return 2.2;
    else if (score > 55 && score <= 65) return 2.4;
    else if (score > 70 && score <= 75) return 2.6;
    else if (score > 80 && score <= 85) return 2.8;
     return 3;
  }

  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over',style: GoogleFonts.pacifico(fontSize: 18)),
            content: Text('Would you like to play again?',style: GoogleFonts.pacifico(fontSize: 18)),
            actions: [
              ElevatedButton(
                child: Text('Yes',style: GoogleFonts.pacifico(fontSize: 18)),
                onPressed: () {
                  setState(()  {
                    posX = 0;
                    posY = 0;
                    score = 0;
                  });
                  Navigator.of(context).pop();
                  controller.repeat();
                },
              ),
              ElevatedButton(
                child: Text('No',style: GoogleFonts.pacifico(fontSize: 18)),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context) => AnimeType()), (Route route) => false);
                  dispose();
                },
              )
            ],
          );
        });
  }

  Future<void> getValue() async {
    var prefs = await SharedPreferences.getInstance();
    var getScore=prefs.getInt('highscore');
    setState(() {
      highscore=getScore??0;
      print(highscore);
    });
  }

  Future<void> setHighscore() async {
    final prefs = await SharedPreferences.getInstance();
    if(highscore<score||highscore==0)
      await prefs.setInt('highscore', score);
  }
}
