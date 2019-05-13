import 'package:face_avatar/ClickPage.dart';
import 'package:flutter/material.dart';
import 'package:avataaar_image/avataaar_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SharedPreferences mshared;
  @override
  void initState() {
    // TODO: implement initState
    getprefs();
    super.initState();
  }

  getprefs() async {
    mshared = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Opacity(
              opacity: 0.9,
              child: Container(
                // Add box decoration
                decoration: BoxDecoration(
                  // Box decoration takes a gradient
                  gradient: LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      // Colors are easy thanks to Flutter's Colors class.
                      Colors.indigo[800],
                      Colors.indigo[700],
                      Colors.indigo[600],
                      Colors.indigo[400],
                    ],
                  ),
                ),
                child: Center(
                  child: Container(),
                ),
              ),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "Get Cartooned.",
                  style: new TextStyle(
                      color: Colors.white, fontSize: 74, fontFamily: "little"),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 50.0),
                    child: new Text(
                      "Select Gender",
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontFamily: "little"),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          mshared.setString("gender", "female");
                          next();
                        },
                        child: AvataaarImage(
                          avatar: new Avataaar(
                              clothes: Clothes.graphicShirt(
                                  ClotheColor.Blue02, GraphicType.Diamond)),
                          width: 100.0,
                          placeholder: new CircularProgressIndicator(),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          mshared.setString("gender", "male");
                          next();
                        },
                        child: AvataaarImage(
                          avatar: new Avataaar(
                              clothes: Clothes.graphicShirt(
                                  ClotheColor.Blue02, GraphicType.Pizza),
                              top: Top.shortHairDreads01(
                                  accessoriesType:
                                      AccessoriesType.Prescription02)),
                          width: 100.0,
                          placeholder: new CircularProgressIndicator(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
      onWillPop: () {},
    );
  }

  next() {
    Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => ClickPage()));
  }
}
