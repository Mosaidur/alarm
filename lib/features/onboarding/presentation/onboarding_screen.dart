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
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        child: Image.asset(
                          _onboardingData[index]['image']!,
                          height: 300,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        _onboardingData[index]['title']!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          _onboardingData[index]['description']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _skip,
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      _onboardingData.length,
                          (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentPage ? 8 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? Colors.white
                              : Colors.white38,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  CustomButton(
                    onPressed: _nextPage,
                    label: _currentPage == _onboardingData.length - 1
                        ? 'Get Started'
                        : 'Next',
                    backgroundColor: const Color(0xFFAB47BC), // Purple accent
                  ),
                ],
              ),
            ),
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