import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  String txt;
   MyButton({Key? key,required this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Container(
      height: size.height / 40 * 3,
      width: size.width / 12 * 5,
      margin: EdgeInsets.all(12),
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
      child: Center(child: Text(txt,style: GoogleFonts.pacifico(fontSize: 18),)),
    );
  }
}
