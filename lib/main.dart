import 'package:flutter/material.dart';
import 'package:mobile/features/welcome/views/welcome_screen.dart' show WelcomeScreen;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await dotenv.load(fileName: ".env");
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ActiveZone',
      theme: ThemeData(
        brightness: Brightness.dark, 
        scaffoldBackgroundColor: Color(0xFF1A1A1A), 
        primaryColor: Color(0xFFFF3B30),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFFF3B30),
          secondary: Color(0xFFFF3B30),
        ),
        useMaterial3: true,
      ),
      home: WelcomeScreen(),
    );
  }
}