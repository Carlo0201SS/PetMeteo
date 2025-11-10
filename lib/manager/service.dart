import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // Ottiene la posizione corrente
  Future<Position> getCurrentPosition() async {
  
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled)
      throw Exception('Servizi di localizzazione disattivati.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permessi di localizzazione negati.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permessi di localizzazione negati permanentemente.');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );
    
    
  }

  // Converte coordinate in nome città
  Future<String> getCityName(Position position) async {
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      final city = placemarks.first.locality;
      return city ?? 'Sconosciuta';
    }
    return 'Sconosciuta';
  }
}
