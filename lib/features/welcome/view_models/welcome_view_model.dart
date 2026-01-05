import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WelcomeViewModel extends ChangeNotifier {
  String currentLocationTag = "Carregando local...";

  Future<void> fetchUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        currentLocationTag = "${place.subAdministrativeArea}, ${place.administrativeArea}";
        notifyListeners(); 
      }
    } catch (e) {
      print("Erro ao carregar local: $e");
      currentLocationTag = "Localização indisponível";
      notifyListeners();
    }
  }
}