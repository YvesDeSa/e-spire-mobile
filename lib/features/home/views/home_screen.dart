import 'package:flutter/material.dart';
import 'package:mobile/features/welcome/views/welcome_screen.dart' show WelcomeScreen;
import '../../../../core/services/storage_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("ActiveZone"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () async {
              await StorageService().clear();
              
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
                (route) => false
              );
            },
          )
        ],
      ),
      body: Center(
        child: Text("Você está logado!", style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }
}