import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:petmeteo/models/forecast_response/ForecastResponse.dart';


class Backend {
  final Dio dio = Dio(BaseOptions(
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
  ));


  Future<ForecastResponse> getWeatherData(Position position) async {
    try { 
      final Response<Map<String, dynamic>> response = await dio.get(
          'https://api.open-meteo.com/v1/forecast?latitude=${position.latitude}&longitude=${position.longitude}&daily=temperature_2m_max,weather_code&hourly=precipitation_probability,weather_code,temperature_2m&current=temperature_2m,relative_humidity_2m,apparent_temperature,wind_speed_10m&timezone=Europe%2FBerlin');
      //print('Stato HTTP: ${response.statusCode}');
      
      //print(response);
      //print("---");
      //print(ForecastResponse.fromJson(response.data!));

      return ForecastResponse.fromJson(response.data!);
    } catch (e) {
      //print("errore:");
      //print(e);
      throw Exception('Failed to load weather: $e');
    }
  }

}
