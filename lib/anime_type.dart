import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pong2/utils/button.dart';
import 'package:http/http.dart' as http;
import '1player.dart';
class AnimeType extends StatefulWidget {
  AnimeType({Key? key}) : super(key: key);

  @override
  State<AnimeType> createState() => _AnimeTypeState();
}

class _AnimeTypeState extends State<AnimeType> {
  var urlData;
  List<String> dragonBall = [];
  List<String> naruto = [];
  List<String> luffy = [];
  List<String> pokemon = [];

  Future getApidata(String Url, List<String> listName) async {
    try {
      var url = Uri.parse(Url);
      final res = await http.get(url);
      urlData = jsonDecode(res.body);
      print(urlData);
      setState(() {
        for (int i = 0; i < urlData['results'].length; i++)
          listName.insert(i, urlData['results'][i]['urls']['full']);
      });
    } catch (error) {
      print(error);
    }
  }

  late Random rnd;

  String img(List<String> listName) {
    if (listName.isEmpty) return 'assets/images/luffy_loading.gif';

    int min = 1;
    int max = listName.length - 1;
    rnd = new Random();
    int r = min + rnd.nextInt(max - min);
    String image_name = listName[r == 0 ? 1 : r].toString();
    // print(image_name);
    return image_name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Choose Any Anime",
              style: GoogleFonts.pacifico(fontSize: 30),
            ),
          ),
          GestureDetector(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Image.asset("assets/images/pokemon_loading.gif"),
                      );
                    });
                await getApidata(
                    "https://api.unsplash.com/search/photos?page=1&query=pokemon&&client_id=zbUqCe7S0VG6b8lxTy7UALUTsIsnqx9d3zSaqZkB4sQ",
                    pokemon);
                Navigator.of(context).pop();
                String final_img=(pokemon.isNotEmpty)?img(pokemon):'';
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SinglePlayerScreen(imgPath: final_img,)));

              },
              child: MyButton(
                txt: 'Pokemon',
              )),
          GestureDetector(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Image.asset("assets/images/naruto_loading.gif"),
                      );
                    });
                await getApidata(
                    "https://api.unsplash.com/search/photos?page=1&query=naruto&&client_id=zbUqCe7S0VG6b8lxTy7UALUTsIsnqx9d3zSaqZkB4sQ",
                    naruto);
                Navigator.of(context).pop();
                String final_img=(naruto.isNotEmpty)?img(naruto):'';
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SinglePlayerScreen(imgPath: final_img)));
              },
              child: MyButton(
                txt: 'Naruto',
              )),
          GestureDetector(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Image.asset("assets/images/luffy_loading.gif"),
                      );
                    });
                await getApidata(
                    "https://api.unsplash.com/search/photos?page=1&query=luffy&&client_id=zbUqCe7S0VG6b8lxTy7UALUTsIsnqx9d3zSaqZkB4sQ",
                    luffy);
                Navigator.of(context).pop();
                String final_img=(luffy.isNotEmpty)?img(luffy):'';
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SinglePlayerScreen(imgPath: final_img)));
              },
              child: MyButton(
                txt: 'One Piece',
              )),
          GestureDetector(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Image.asset("assets/images/goku_loading.gif"),
                      );
                    });
                await getApidata(
                    "https://api.unsplash.com/search/photos?page=1&query=goku&&client_id=zbUqCe7S0VG6b8lxTy7UALUTsIsnqx9d3zSaqZkB4sQ",
                    dragonBall);
                Navigator.of(context).pop();
                String final_img=(dragonBall.isNotEmpty)?img(dragonBall):'';
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SinglePlayerScreen(imgPath: final_img)));
              },
              child: MyButton(
                txt: 'Dragon Ball',
              )),
        ],
      ),
    );
  }
}
