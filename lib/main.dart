import 'package:avataaar_image/avataaar_image.dart';
import 'package:face_avatar/Detect_Face.dart';
import 'package:face_avatar/LoginScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(AvataaarExample());

class AvataaarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/face': (context) => Detect_Face(),
      },
    );
  }
}
