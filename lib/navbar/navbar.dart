import 'dart:math';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_solution_challenge/controller/controller.dart';
import 'package:google_solution_challenge/screens/home_screens/building_risk/building_risk.dart';
import 'package:google_solution_challenge/screens/home_screens/earthquaker/home_page.dart';
import 'package:google_solution_challenge/screens/home_screens/image_classification/image_classification.dart';
import 'package:google_solution_challenge/screens/home_screens/maps/map_custom.dart';
import 'package:google_solution_challenge/screens/home_screens//camera/CameraHome.dart';
import 'package:google_solution_challenge/screens/profile/sos_rev.dart';
import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../screens/home_screens/camera/ar_camera.dart';


class NavBar extends StatefulWidget {
  const NavBar({super.key});
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  double _latitude = 36.2025833;
  double _longitude = 36.1604033, distance = 0, _earthltt = 0, _earthlgt = 0;
  List<CameraDescription>? cameras;

  late LatLng _currentPostion = const LatLng(38.9637, 35.2433);
  late GeoPoint _EarthPostion = const GeoPoint(36.2025833, 36.1604033);

  FirebaseDocument() async {  // Yakında bir deprem olduysa bir pop up olarak gösterebiliriz hemen.
    var document = await db
        .collection('EarthquakeLocation')
        .doc("mpQ3qaUnmo54pPKPu30W")
        .get();

    Map<String, dynamic>? value = document.data();
    if (mounted && value != null) {
      setState(() {
        _EarthPostion = value['Hatay'];
        _earthltt = _EarthPostion.latitude;
        _earthlgt = _EarthPostion.longitude;
        distance = EvalDistance(_latitude, _longitude, _earthltt, _earthlgt);
      });
      // Eğer belirli bir mesafenin altındaysa (örneğin 0.1 derece), uyarı göster
      if (distance < 10) {
        _showEarthquakeAlert();
      }
    }
  }


  void _showEarthquakeAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Earthquake warning!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('There is an earthquake happened nearby!'), // locale keys kısmına eklenecek
                Text('Please go to a safe zone and follow the instructions.'), // locale keys kısmına eklenecek
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay.'), // locale keys kısmına eklenecek.
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double EvalDistance(latitude, longitude, earthltt, earthlgt) {
    double dst = sqrt((earthltt - latitude) * (earthltt - latitude) +
        (earthlgt - longitude) * (earthlgt - longitude));
    print(
        "$latitude $longitude $earthltt $earthlgt $dst *********************************");
    return dst;
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));

    setState(() {
      _currentPostion = LatLng(position.latitude, position.longitude);
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  @override
  void initState() {
    _getUserLocation();
    FirebaseDocument();
    super.initState();
    availableCameras().then((availableCameras) {
      setState(() {
        cameras = availableCameras;
      });
    });
  }

  final controller = Get.put(NavBarController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavBarController>(builder: (context) {
        return Scaffold(
          body: IndexedStack(
            index: controller.tabIndex,
            children: [
              EarthquakerPage(), // Home page
              SOSButton(), // SOS button page
              ObjectsOnPlanesWidget(), // AR page
              CameraHomePage(cameras!), // Object detection page
              MapUIcustom(), // Map page
              BuildingInfoForm(), // Building risk page
              ImageClassification(), // Building photo classification page
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: (Colors.blueGrey[300])!,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: GNav(
                selectedIndex: controller.tabIndex,
                onTabChange: controller.changeTabIndex,
                backgroundColor: (Colors.blueGrey[300])!,
                color: Colors.black,
                activeColor: Colors.white,
                tabBackgroundColor: const Color.fromARGB(43, 233, 125, 71),
                gap: 10.0,
                padding: const EdgeInsets.all(0.0),
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: "Home",
                  ),
                  GButton(
                    icon: Icons.add_alert,
                    text: "SOS",
                  ),
                  GButton(
                    icon: Icons.vrpano,
                    text: "AR",
                  ),
                  GButton(
                    icon: Icons.camera_alt,
                    text: "Cam",
                  ),
                  GButton(
                    icon: Icons.map,
                    text: "Maps",
                  ),
                  GButton(
                    icon: Icons.grade,
                    text: "Risk",
                  ),
                  GButton(
                    icon: Icons.house_outlined,
                    text: "Clf",
                  ),
                ],
              ),
            ),
          ),
        );
    });
  }
}
