import 'package:flutter/material.dart';
import '../../core/services/storage_service.dart';
import '../welcome/views/welcome_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../home/views/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    await Future.delayed(Duration(seconds: 2));

    String? token = await _storageService.getToken();

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => HomeScreen())
      );
    } else {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => WelcomeScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bolt, color: AppColors.primary, size: 80), 
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}