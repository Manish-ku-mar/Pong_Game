import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pong2/opening_screen.dart';
import 'utils/ball.dart';
import 'utils/player.dart';

enum Direction { up, down, left, right }

class PongDouble extends StatefulWidget {
  const PongDouble({Key? key}) : super(key: key);

  @override
  State<PongDouble> createState() => _PongDoubleState();
}

class _PongDoubleState extends State<PongDouble>
    with SingleTickerProviderStateMixin {
  late double width;
  late double height;
  late double posX;
  late double posY;
  late double batWidth;
  late double batHeight;
  late double bat1Position = 0;
  late double bat2Position = 0;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  late Animation<double> animation;
  late AnimationController controller;
  double increment = 5;
  double randX = 1;
  double randY = 1;
  int score1 = 0;
  int score2 = 0;
  late final  ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController=ConfettiController(duration: const Duration(seconds: 10));
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
    _confettiController.dispose();
    controller.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      height = constraints.maxHeight;
      width = constraints.maxWidth;
      batWidth = width / 3;
      batHeight = height / 16;
      return Stack(
        children: [
          Positioned(
            top: 200,
            left: MediaQuery.of(context).size.width / 3.5,
            child: Text(
              'Player 2: ' + score2.toString(),
              style: GoogleFonts.pacifico(fontSize: 30),
            ),
          ),
          Positioned(
            bottom: 200,
            left: MediaQuery.of(context).size.width / 3.5,
            child: Text('Player 1: ' + score1.toString(),
                style: GoogleFonts.pacifico(fontSize: 30)),
          ),
          Positioned(
              bottom: 10,
              left: bat1Position,
              child: GestureDetector(
                  onHorizontalDragUpdate: (DragUpdateDetails update1) =>
                      moveBat1(update1, context),
                  child: Bat(batWidth, batHeight))),
          Positioned(
            child: Ball(),
            top: posY,
            left: posX,
          ),
          Positioned(
              top: 10,
              left: bat2Position,
              child: GestureDetector(
                  onHorizontalDragUpdate: (DragUpdateDetails update) =>
                      moveBat2(update, context),
                  child: Bat(batWidth, batHeight))),

        ],
      );
    });
  }

  void checkBorders() {
    double diameter = 35;

    //left
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    //right
    if (posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }

    //down score opposite person
    if (posY >= height - diameter - batHeight && vDir == Direction.down) {
      if (posX >= (bat1Position - diameter) &&
          posX <= (bat1Position + batWidth + diameter)) {
        //hit just move the ball

        randY = randomNumber();
      } else {
        //ball dunk other player score
        setState(() {
          score2++;
        });
        if (score2 + score1 == 5)
          stopGame();
        else
          controller.repeat();
      }
      vDir = Direction.up;
    }
    //up
    if (posY <= batHeight && vDir == Direction.up) {
      if (posX >= (bat2Position - diameter) &&
          posX <= (bat2Position + batWidth + diameter)) {
        //hit just move the ball

        randY = randomNumber();
      } else {
        //ball dunk other player score
        setState(() {
          score1++;
        });
        if (score2 + score1 == 10)
          stopGame();
        else
          controller.repeat();
      }
      vDir = Direction.down;
    }

    // if (posY <= height - diameter - batHeight && vDir == Direction.up) {
    //   if (posX >= (bat2Position - diameter) &&
    //       posX <= (bat2Position + batWidth + diameter)) {
    //     //hit just move the ball
    //     vDir = Direction.down;
    //     randY = randomNumber();
    //   } else {
    //     //ball dunk other player score
    //     setState(() {
    //       score2++;
    //     });
    //     controller.stop();
    //     showMessage(context);
    //   }
    // }
  }

  void stopGame() {
    controller.stop();
    _confettiController.play();
    showMessage(context);
  }

  void moveBat1(DragUpdateDetails update, BuildContext context) {
    setState(() {
      bat1Position += update.delta.dx;
    });
  }

  void moveBat2(DragUpdateDetails update, BuildContext context) {
    setState(() {
      bat2Position += update.delta.dx;
    });
  }

  double randomNumber() {
    var ran = new Random();
    int myNum = ran.nextInt(100);
    return 2;
  }

  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over', style: GoogleFonts.pacifico(fontSize: 28)),
            content: (score1 > score2)
                ? Text(
                    'Player 1 won. Play Again?',
                    style: GoogleFonts.pacifico(fontSize: 18),
                  )
                : Text('Player 2 won. Play Again?',
                    style: GoogleFonts.pacifico(fontSize: 18)),
            actions: [
              ElevatedButton(
                child: Text('Yes', style: GoogleFonts.pacifico(fontSize: 18)),
                onPressed: () {
                  setState(() {
                    posX = 0;
                    posY = 0;
                    score1 = 0;
                    score2 = 0;
                  });
                  Navigator.of(context).pop();
                  controller.repeat();
                },
              ),
              ElevatedButton(
                child: Text('No', style: GoogleFonts.pacifico(fontSize: 18)),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => OpeningScreen()),
                      (Route route) => false);
                  _confettiController.stop();
                  dispose();
                },
              ),
              ConfettiWidget(confettiController: _confettiController),
            ],
          );
        });
  }
}
