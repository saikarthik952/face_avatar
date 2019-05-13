import 'dart:async';
import 'package:avataaar_image/avataaar_image.dart';
import 'package:face_avatar/Detect_Face.dart';
import 'package:face_avatar/LoginScreen.dart';
import 'package:flutter/material.dart';

class ClickPage extends StatefulWidget {
  @override
  _ClickPageState createState() => _ClickPageState();
}

class _ClickPageState extends State<ClickPage> {
  @override
  void initState() {
    super.initState();
    _randomizeAvatar();
    randomize();
  }

  Avataaar _avatar;
  void _randomizeAvatar() {
    _avatar = Avataaar.random();
  }

  randomize() async {
    Duration oneSec = const Duration(seconds: 5);
    Timer.periodic(
        oneSec,
        (Timer t) => setState(() {
              _randomizeAvatar();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            new Container(
              height: 150,
              color: Colors.indigo,
              child: Center(
                child: new Text(
                  "Get Cartooned.",
                  style: new TextStyle(
                      color: Colors.white, fontSize: 60, fontFamily: "little"),
                ),
              ),
            ),
            new SizedBox(
              height: 20.0,
            ),
            Container(
              height: 150.0,
              child: Center(
                child: AvataaarImage(
                  avatar: _avatar,
                  errorImage: Icon(Icons.error),
                  placeholder: CircularProgressIndicator(),
                  width: 128.0,
                ),
              ),
            ),
            new Container(
              margin: EdgeInsets.all(10.0),
              child: new RaisedButton(
                color: Colors.indigoAccent[200],
                padding: EdgeInsets.all(10.0),
                splashColor: Colors.tealAccent,
                onPressed: () {
                  print("rey");
                  Navigator.pushNamed(context, '/face');
                },
                child: Container(
                  margin: EdgeInsets.only(top: 15.0),
                  child: new Text(
                    "CREATE NOW",
                    style: new TextStyle(
                        color: Colors.white,
                        fontFamily: "little",
                        fontSize: 64.0),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 50.0, right: 50.0, top: 10.0, bottom: 10.0),
              child: RaisedButton(
                color: Colors.indigoAccent,
                child: new Text(
                  "Change Gender",
                  style: new TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/');
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: new ListView(shrinkWrap: true, children: <Widget>[
                const Text(
                    '1) Firstly, click a close selfie with good lighting'),
                new SizedBox(
                  height: 5.0,
                ),
                const Text(
                    '2) Try different facial expressions like sad, wink and offcourse Laugh'),
                new SizedBox(
                  height: 5.0,
                ),
                const Text(
                    '3) It also detects glasses, caps, hat and much more'),
                new SizedBox(
                  height: 5.0,
                ),
              ]),
            ),
          ],
        ),
      ),
      onWillPop: () {},
    );
  }
}
