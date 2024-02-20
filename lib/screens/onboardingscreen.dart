import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_solution_challenge/screens/intro_screens/intro_screen_1.dart'; // Update the import paths
import 'package:google_solution_challenge/screens/intro_screens/intro_screen_2.dart';
import 'package:google_solution_challenge/screens/intro_screens/intro_screen_3.dart';
import 'package:google_solution_challenge/screens/login/login_page.dart'; // Assuming LoginPage is renamed to MainPage
import 'package:google_solution_challenge/translations/locale_keys.g.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50], // Updated background color
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              IntroScreen1(),
              IntroScreen2(),
              IntroScreen3(),
            ],
          ),
          Positioned(
            bottom: 20, // Adjusted for better placement
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: ExpandingDotsEffect( // Changed effect for a fresh look
                    activeDotColor: Colors.blue.shade400,
                    dotColor: Colors.blue.shade100,
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 5,
                  ),
                ),
                const SizedBox(height: 20), // Added for spacing
                if (onLastPage)
                  buildButton(
                        () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()), // Ensure this matches your navigation destination
                    ),
                    LocaleKeys.OnBoarding_Done.tr(),
                    Colors.blue, // Updated button color for consistency
                    Colors.white,
                  )
                else
                  buildButton(
                        () => _controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                    LocaleKeys.OnBoarding_Next.tr(),
                    Colors.blue, // Consistent button color
                    Colors.white,
                  ),
                if (!onLastPage) // Only show skip on first two pages
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextButton(
                      onPressed: () => _controller.jumpToPage(2),
                      child: Text(
                        LocaleKeys.OnBoarding_Skip.tr(),
                        style: TextStyle(
                          color: Colors.blue.shade700, // Updated text color for visibility
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(Function() onTap, String text, Color buttonColor, Color textColor) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor, backgroundColor: buttonColor, // Text color
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Rounded corners
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
