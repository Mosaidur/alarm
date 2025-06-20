import 'package:flutter/material.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/location/presentation/location_screen.dart';
import 'features/alarm/presentation/home_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'helpers/awsom_notficationa_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Add the navigator key here
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Initialize Awesome Notifications AFTER the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AwesomeNotificationHelper.initialize(MyApp.navigatorKey.currentContext!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sunset Alarm',
      debugShowCheckedModeBanner: false,
      navigatorKey: MyApp.navigatorKey, // Attach the navigator key
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
