import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:avataaar_image/avataaar_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class Detect_Face extends StatefulWidget {
  String gender;
  @override
  _Detect_FaceState createState() => _Detect_FaceState();
}

class _Detect_FaceState extends State<Detect_Face> {
  SharedPreferences mshared;
  String gender;

  bool smile = false, wink = false, sad = false;
  bool cap = false,
      noglass = false,
      glasses = false,
      sunglasses = false,
      beard = false,
      moustache = false,
      eyesclosed = false,
      noface = false;
  bool load = false;
  Avataaar avatar;
  bool normal = false;
  double glass = 0.0, sun = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    getprefs();
    super.initState();
    getImage();
  }

  getprefs() async {
    mshared = await SharedPreferences.getInstance();
    gender = mshared.getString("gender");
  }

  final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
          enableClassification: true, mode: FaceDetectorMode.accurate));
  final ImageLabeler labeler = FirebaseVision.instance
      .imageLabeler(ImageLabelerOptions(confidenceThreshold: 0.7));
  File _image;
  Future getImage() async {
    smile = false;
    wink = false;
    sad = false;
    cap = false;
    glasses = false;
    beard = false;
    moustache = false;
    eyesclosed = false;
    normal = false;
    noface = false;
    sunglasses = false;
    // load = false;
    noface = false;
    glass = 0.0;
    sun = 0.0;
    noglass = false;
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(_image);
    final List<Face> faces = await faceDetector.processImage(visionImage);
    final List<ImageLabel> labels = await labeler.processImage(visionImage);
    print(faces.length);
    if (faces.length == 0 || faces.length > 1) {
      print("No Faces Detected");
      //dailog
      noface = true;
    } else {
      for (Face face in faces) {
        // final Rect boundingBox = face.boundingBox;

        // If classification was enabled with FaceDetectorOptions:
        if (face.smilingProbability != null) {
          final double smileProb = face.smilingProbability;
          print(smileProb.toString() + " Smile");
          if (smileProb > 0.75)
            smile = true;
          else if (smileProb < 0.2) {
            sad = true;
          } else {
            normal = true;
          }
          final double right = face.rightEyeOpenProbability;
          print(right.toString() + " r");

          final double left = face.leftEyeOpenProbability;
          print(left.toString() + " l");

          if (right < 0.5 && left < 0.5) {
            eyesclosed = true;
          } else if (right < 0.5 || left < 0.5) {
            wink = true;
          }
        }
      }
      for (ImageLabel label in labels) {
        final String text = label.text;
        final String entityId = label.entityId;
        final double confidence = label.confidence;
        print("Text : $text  id $entityId confidence $confidence");
        if (text == "Beard") {
          beard = true;
        }
        if (text == "Moustache") {
          moustache = true;
        }
        if (text == "Hair") {
          cap = false;
        }
        if (text == "Glasses") {
          glass = confidence;
        }
        if (text == "Sunglasses") {
          sun = confidence;
        }
        if (text == "Hat" || text == "Cap") {
          cap = true;
        }
      }
      if (sun == 0.0 && glass == 0.0) noglass = true;
    }
    startprocessing();
  }

  startprocessing() {
    if (gender == "male") {
      avatar = new Avataaar(top: Top.shortHairShortWaved());
    } else {
      avatar = new Avataaar(top: Top.longHairStraight2());
    }
    String url;

    //  AvataaarsApi a = new AvataaarsApi();

    // url = a.getUrl(avatar, 100.0);

    //  print(url);

    if (smile && eyesclosed) {
      avatar.eyes = Eyes.happy;
      avatar.mouth = Mouth.smile;
    } else if (smile && wink) {
      avatar.eyes = Eyes.winkWacky;
      avatar.mouth = Mouth.smile;
    } else if (wink) {
      avatar.mouth = Mouth.defaultMouth;
      avatar.eyes = Eyes.wink;
      avatar.eyebrow = Eyebrow.upDownNatural;
    } else if (sad & eyesclosed) {
      avatar.eyes = Eyes.cry;
      avatar.mouth = Mouth.sad;
    } else if (normal) {
      if (gender == "male") {
        avatar = new Avataaar(top: Top.shortHairShortWaved());
      } else {
        avatar = new Avataaar(top: Top.longHairStraight2());
      }
    }
    bool sunx = false;
    if (!noglass) {
      if (sun < glass) {
        sunx = false;
      } else if (sun > glass) {
        sunx = true;
      }
    }
    if (beard) {
      if (gender == "male") {
        if (cap)
          avatar.top = Top.hat(
              facialHair: FacialHair.beardLight(
                  facialHairColor: FacialHairColor.Black));
        if (sunx && cap && !noglass) {
          avatar.top = Top.hat(
              accessoriesType: AccessoriesType.Sunglasses,
              facialHair: FacialHair.beardLight(
                  facialHairColor: FacialHairColor.Black));
        }
        if (!sunx && cap && !noglass) {
          avatar.top = Top.hat(
              accessoriesType: AccessoriesType.Sunglasses,
              facialHair: FacialHair.beardLight(
                  facialHairColor: FacialHairColor.Black));
        } else if (sunx && !noglass) {
          avatar.top = Top.shortHairShortWaved(
              accessoriesType: AccessoriesType.Sunglasses,
              facialHair: FacialHair.beardLight(
                  facialHairColor: FacialHairColor.Black));
        } else if (!sunx && !noglass) {
          avatar.top = Top.shortHairShortWaved(
              accessoriesType: AccessoriesType.Prescription02,
              facialHair: FacialHair.beardLight(
                  facialHairColor: FacialHairColor.Black));
        } else
          avatar.top = Top.shortHairShortRound(
              facialHair: FacialHair.beardLight(
                  facialHairColor: FacialHairColor.Black));
      }
    } else if (moustache) {
      if (gender == "male") {
        avatar.top = Top.shortHairShortRound(
            facialHair: FacialHair.moustacheFancy(
                facialHairColor: FacialHairColor.Black));
      } else {
        if (gender == "male") {
          avatar = new Avataaar(top: Top.shortHairShortWaved());
        } else {
          avatar = new Avataaar(top: Top.longHairStraight2());
        }
      }
    }

    setState(() {
      load = true;
      avatar;
    });
  }

  getdown() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);

    AvataaarsApi a = new AvataaarsApi();
    String directory = await (await getExternalStorageDirectory()).path;
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    File f = await File('$directory/DCIM/$timestamp.png').create();
    f.writeAsBytes(await a.getImage(avatar, 240.0));
    print(f.path + "rey");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.indigoAccent,
        title: new Text(
          "Create Cartoon",
          style: new TextStyle(
              color: Colors.white, fontFamily: "little", fontSize: 40.0),
        ),
      ),
      body: Center(
        child: load == false
            ? Center(
                child: new CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AvataaarImage(
                    avatar: avatar,
                    width: 200.0,
                  ),
                  new Container(
                    margin: EdgeInsets.all(10.0),
                    child: new RaisedButton(
                      color: Colors.indigoAccent[200],
                      padding: EdgeInsets.all(10.0),
                      splashColor: Colors.tealAccent,
                      onPressed: () {
                        print("rey");
                        getImage();
                        setState(() {
                          load = false;
                        });
                        //Navigator.pushNamed(context, '/face');
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 15.0),
                        child: new Text(
                          "TRY AGAIN",
                          style: new TextStyle(
                              color: Colors.white,
                              fontFamily: "little",
                              fontSize: 64.0),
                        ),
                      ),
                    ),
                  ),
                  noface == false
                      ? new Container(
                          margin: EdgeInsets.all(10.0),
                          child: new RaisedButton(
                            color: Colors.indigoAccent[200],
                            padding: EdgeInsets.all(10.0),
                            splashColor: Colors.tealAccent,
                            onPressed: () {
                              //Navigator.pushNamed(context, '/face');
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 15.0),
                              child: new Text(
                                "CUSTOMIZE MORE",
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontFamily: "little",
                                    fontSize: 48.0),
                              ),
                            ),
                          ),
                        )
                      : new Container(),
                  noface == false
                      ? new Container(
                          margin: EdgeInsets.all(10.0),
                          child: new RaisedButton(
                            color: Colors.indigoAccent[200],
                            padding: EdgeInsets.all(10.0),
                            splashColor: Colors.tealAccent,
                            onPressed: () {
                              //Navigator.pushNamed(context, '/face');

                              getdown();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 15.0),
                              child: new Text(
                                "DOWNLOAD",
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontFamily: "little",
                                    fontSize: 48.0),
                              ),
                            ),
                          ),
                        )
                      : new Container(),
                  noface == true
                      ? Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 50.0),
                            child: new Text(
                              "Please Try Again ! There was an Error detecting your Face",
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 36,
                                  fontFamily: "little"),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : new Container(),
                ],
              ),
      ),
    );
  }
}
