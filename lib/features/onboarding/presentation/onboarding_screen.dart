import 'package:flutter/material.dart';
import '../../../common_widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Welcome to Sunset Alarm',
      'description': 'Set alarms to unwind during sunset.',
      'image': 'assets/images/onboarding1.gif',
    },
    {
      'title': 'Location-Based Alarms',
      'description': 'Get notified based on your location.',
      'image': 'assets/images/onboarding2.gif',
    },
    {
      'title': 'Relax & Unwind',
      'description': 'Hope to take the courage to pursue your dreams.',
      'image': 'assets/images/onboarding3.gif',
    },
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/location');
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, '/location');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1B20), // Dark background
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.5, // Half of screen height
                              child: Image.asset(
                                _onboardingData[index]['image']!,
                                fit: BoxFit.cover, // Maintain aspect ratio, no stretching
                                width: double.infinity, // Ensure image takes full width
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextButton(
                              onPressed: _skip,
                              child: const Text(
                                'Skip',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,top: 0,right: 20,bottom: 0),
                        child: Text(
                          _onboardingData[index]['title']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,top: 0,right: 20 ,bottom: 0),
                        child: Text(
                          _onboardingData[index]['description']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),


            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                    (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: index == _currentPage ? 15 : 6,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == _currentPage
                        ? Colors.purple
                        : Colors.white38,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                onPressed: _nextPage,
                label: _currentPage == _onboardingData.length - 1
                    ? 'Next'
                    : 'Next',
                backgroundColor: const Color(0xFFAB47BC), // Purple accent
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}