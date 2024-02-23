import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vector_math/vector_math_64.dart' as math;



//While creating this module, "https://github.com/CariusLars/ar_flutter_plugin/tree/main"
//We inspired by the examples in this repository but The code below is completely created by us.

class ObjectsOnPlanesWidget extends StatefulWidget {
  ObjectsOnPlanesWidget({Key? key}) : super(key: key);
  @override
  _ObjectsOnPlanesWidgetState createState() => _ObjectsOnPlanesWidgetState();
}

class _ObjectsOnPlanesWidgetState extends State<ObjectsOnPlanesWidget> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  double? scaleX;
  double? scaleY;
  double? scaleZ;

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Triangle of Life",
            style: GoogleFonts.albertSans(
              color: Colors.grey[900],
              fontSize: 29,
              fontWeight: FontWeight.bold,
              height: 1.355,
            )
        ),
      backgroundColor: Colors.blueGrey[300],
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context)=> SimpleDialog(
                    title: Text("Triangle of Life Info"),
                    contentPadding: const EdgeInsets.all(20.0),
                    backgroundColor: Colors.blueGrey,
                    children: [
                      Text("Displays triangle of life in your house."),
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
    ),
      body: Container(
        child: Stack(
          children: [
            ARView(
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: onRemoveEverything,
                    child: Text("Remove Everything"),
                  ),
                  ElevatedButton(
                    onPressed: () => _showBMIInputDialog(context),
                    child: Text("Update Height and Weight"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showBMIInputDialog(BuildContext context) async {
    double? height;
    double? weight;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Height and Weight"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Height (in meters)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  height = double.tryParse(value);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Weight (in kilograms)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  weight = double.tryParse(value);
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (height != null && weight != null) {
                  double bmi = calculateBMI(height!, weight!);
                  print('BMI: $bmi');
                  if (height! < 50) {
                    scaleX = 0.1;
                  } else if (height! >= 50 && height! < 100) {
                    scaleX = 0.2;
                  } else if (height! >= 100 && height! < 150) {
                    scaleX = 0.3;
                  } else if (height! >= 150 && height! < 200) {
                    scaleX = 0.4;
                  } else if (height! > 200 ) {
                    scaleX = 0.5;
                  };

                  if (weight! < 20) {
                    scaleY = 0.1;
                  } else if (weight! >= 20 && weight! < 40) {
                    scaleY = 0.2;
                  } else if (weight! >= 40 && weight! < 60) {
                    scaleY = 0.3;
                  } else if (weight! >= 60 && weight! < 80) {
                    scaleY = 0.4;
                  } else if (weight! >= 80 && weight! < 100) {
                    scaleY = 0.5;
                  };

                  if (bmi < 16) {
                    scaleZ = 0.3;
                  } else if (bmi >= 16 && bmi < 17) {
                    scaleZ = 0.5;
                  } else if (bmi >= 18.5 && bmi < 25) {
                    scaleZ = 0.6;
                  } else if (bmi >= 25 && bmi < 30) {
                    scaleZ = 0.7;
                  } else if (bmi >= 30 && bmi < 35) {
                    scaleZ = 0.8;
                  } else if (bmi >= 35 && bmi < 40) {
                    scaleZ = 0.9;
                  } else if (bmi > 40 ) {
                    scaleZ = 1.0;
                  };
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter valid height and weight values'),
                    ),
                  );
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  double calculateBMI(double height, double weight) {
    return weight / (height/100 * height/100);
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager,
      ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;
    this.arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "Images/triangle.png",
      showWorldOrigin: true,
      showAnimatedGuide: false,
    );
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager!.onNodeTap = onNodeTapped;
  }

  Future<void> onNodeTapped(List<String> nodes) async {
    var number = nodes.length;
    this.arSessionManager!.onError("Tapped $number node(s)");
  }

  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    if (scaleX == null && scaleY == null && scaleZ == null) {
      await _showBMIInputDialog(context);
    }

    var singleHitTestResult = hitTestResults.firstWhere(
          (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane,
      orElse: () => throw Exception("No plane found"),
    );
    if (singleHitTestResult != null) {
      var scale = math.Vector3(scaleX!, scaleY!, scaleZ!);
      var newAnchor = ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        this.anchors.add(newAnchor);
        var newNode = ARNode(
          type: NodeType.localGLTF2,
          uri: "assets/ar_models/Box.gltf",
          scale: scale,
          position: math.Vector3(0.0, 0.0, 0.0),
          rotation: math.Vector4(1.0, 0.0, 0.0, 0.0),
        );
        bool? didAddNodeToAnchor = await this.arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          this.nodes.add(newNode);
        } else {
          this.arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        this.arSessionManager!.onError("Adding Anchor failed");
      }
    }
  }

  Future<void> onRemoveEverything() async {
    anchors.forEach((anchor) {
      this.arAnchorManager!.removeAnchor(anchor);
    });
    anchors = [];
  }
}
