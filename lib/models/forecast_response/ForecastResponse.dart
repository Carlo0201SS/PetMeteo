class ForecastResponse {
  final double? latitude;
  final double? longitude;
  final double? generationtime;
  final int? offset;
  final String? timezone;
  final String? timezonebrev;
  final double? elevation;
  final ForecastCurrent? current;
  final ForecastHourly? hourly;
  final ForecastDaily? daily;

  ForecastResponse({
    this.latitude,
    this.longitude,
    this.generationtime,
    this.offset,
    this.timezone,
    this.timezonebrev,
    this.elevation,
    this.current,
    this.hourly,
    this.daily,
  });

  factory ForecastResponse.fromJson(Map<String, dynamic> json) {
    return ForecastResponse(
      latitude: json['latitude'],
      longitude: json['longitude'],
      generationtime: json['generationtime_ms'],
      offset: json['utc_offset_seconds'],
      timezone: json['timezone'],
      timezonebrev: json['timezone_abbreviation'],
      elevation: json['elevation'],
      current: ForecastCurrent.fromJson(json['current']),
      hourly: ForecastHourly.fromJson(json['hourly']),
      daily: ForecastDaily.fromJson(json['daily']),
    );
  }
}

class ForecastCurrent {
  final String? time;
  final int? interval;
  final double? temperature;
  final int? relativehumidity;
  final double? apparenttemperature;
  final double? windspeed;

  ForecastCurrent({
    this.time,
    this.interval,
    this.temperature,
    this.relativehumidity,
    this.apparenttemperature,
    this.windspeed,
  });

  factory ForecastCurrent.fromJson(Map<String, dynamic> json) {
    return ForecastCurrent(
      time: json['time'],
      interval: json['interval'],
      temperature: json['temperature_2m'],
      relativehumidity: json['relative_humidity_2m'],
      apparenttemperature: json['apparent_temperature'],
      windspeed: json['wind_speed_10m'],
    );
  }
}

class ForecastHourly {
  final List<DateTime>? time;
  final List<int>? probprecipitation;
  final List<double>? temperature;
  final List<int>? weathercode;

  ForecastHourly({
    this.time,
    this.probprecipitation,
    this.weathercode,
    this.temperature,
  });

  factory ForecastHourly.fromJson(Map<String, dynamic> json) {
    return ForecastHourly(
      time: (json['time'] as List)
          .map((item) => DateTime.parse(item as String))
          .toList(),
      probprecipitation:
          List<int>.from(json['precipitation_probability'] as List),
      weathercode: List<int>.from(json['weather_code'] as List),
      temperature: List<double>.from(json['temperature_2m'] as List),
    );
  }
}

class ForecastDaily {
  final List<DateTime>? time;
  final List<int>? temperaturemax;
  final List<int>? weathercode;

  ForecastDaily({
    this.time,
    this.temperaturemax,
    this.weathercode,
  });

  factory ForecastDaily.fromJson(Map<String, dynamic> json) {
    return ForecastDaily(
      time: (json['time'] as List)
          .map((item) => DateTime.parse(item as String))
          .toList(),
      temperaturemax: List<int>.from((json['temperature_2m_max'] as List)
          .map((item) => (item as num).round())
          .toList()),
      weathercode: List<int>.from(json['weather_code'] as List),
    );
  }
}
