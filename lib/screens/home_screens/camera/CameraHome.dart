import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'bindBox.dart';
//https://github.com/ravindu9701/Real-Time-Object-Detection-Mobile

// We inspired from this project to implement our project.

const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";

class CameraHomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraHomePage(this.cameras, {super.key});
  @override
  State<CameraHomePage> createState() => _CameraHomePageState();
}

class _CameraHomePageState extends State<CameraHomePage> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    String? res = await Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt");
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();

  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _model = "";
              });
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context)=> SimpleDialog(
                      title: Text("Object Detection"),
                      contentPadding: const EdgeInsets.all(20.0),
                      backgroundColor: Colors.blueGrey,
                      children: [
                        Text("Detect objects and see if they are dangerous in earthquake or not."),
                        TextButton(
                          onPressed:() {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Close",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],

                    )
                );
              },
              child: const Icon(
                Icons.info_outline,
                color: Colors.black87,
              ),
            ),
          )
        ],
        title:
          Text(
              "Object Detection",
              style: GoogleFonts.albertSans(
                color: Colors.grey[900],
                fontSize: 29,
                fontWeight: FontWeight.bold,
                height: 1.355,
              )
          ),
      ),
      backgroundColor: Colors.white,
      body: _model == ""
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // background
                foregroundColor: Colors.white, // foreground
              ),
              onPressed: () => onSelect(ssd),
              child: const Text(ssd),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // background
                foregroundColor: Colors.white, // foreground
              ),
              onPressed: () => onSelect(yolo),
              child: const Text(yolo),
            ),
          ],
        ),
      )
          : Stack(
        children: [
          Camera(
            widget.cameras,
            _model,
            setRecognitions,
          ),
          BindBox(
            _recognitions,
            math.max(_imageHeight, _imageWidth),
            math.min(_imageHeight, _imageWidth),
            screen.height,
            screen.width,
          ),
        ],
      ),
    );
  }
}