import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../translations/locale_keys.g.dart'; // Update the import path according to your project structure

class IntroScreen2 extends StatefulWidget {
  const IntroScreen2({Key? key}) : super(key: key);

  @override
  State<IntroScreen2> createState() => _IntroScreen2State();
}

class _IntroScreen2State extends State<IntroScreen2> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blueGrey[100], // Updated background color for a new look
      body: SingleChildScrollView( // Added SingleChildScrollView for better responsiveness
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.1), // Adjusted padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Changed alignment for better layout control
            children: [
              Image.asset(
                'assets/images/AR.jpg', // Updated image asset
                height: screenHeight * 0.4, // Adjusted size
                width: double.infinity,
                fit: BoxFit.contain, // Changed BoxFit to 'contain' for a different effect
              ),
              const SizedBox(height: 20.0),
              Text(
                LocaleKeys.openingCards2Title.tr(),
                textAlign: TextAlign.center, // Added text alignment for better readability
                style: const TextStyle(
                    fontFamily: "Lobster", // Changed font family for a new style
                    fontSize: 28.0,
                    color: Color(0xFF3A5160), // Updated color for a fresh look
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15.0),
              Padding( // Added padding for the text for better layout
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  LocaleKeys.openingCards2.tr(),
                  textAlign: TextAlign.center, // Ensured text is centered
                  style: const TextStyle(
                    fontFamily: "Roboto", // Changed font family
                    fontSize: 16.0,
                    color: Colors.black54, // Softened color for better readability
                    fontWeight: FontWeight.w400, // Adjusted font weight
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05), // Adjusted spacing
            ],
          ),
        ),
      ),
    );
  }
}
