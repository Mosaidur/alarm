import 'package:flutter/material.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/location/presentation/location_screen.dart';
import 'features/alarm/presentation/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sunset Alarm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/location': (context) => const LocationScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}