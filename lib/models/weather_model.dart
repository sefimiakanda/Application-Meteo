class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int windDegree;
  final String description;
  final String iconCode;
  final int visibility;
  final DateTime sunrise;
  final DateTime sunset;

  const WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDegree,
    required this.description,
    required this.iconCode,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weatherList = json['weather'] as List<dynamic>? ?? const [];
    final weather = weatherList.isNotEmpty ? weatherList.first as Map<String, dynamic>? : null;
    final main = json['main'] as Map<String, dynamic>? ?? const {};
    final wind = json['wind'] as Map<String, dynamic>? ?? const {};
    final sys = json['sys'] as Map<String, dynamic>? ?? const {};

    return WeatherModel(
      cityName: json['name'] as String? ?? '',
      country: sys['country'] as String? ?? '',
      temperature: (main['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (main['feels_like'] as num?)?.toDouble() ?? 0.0,
      tempMin: (main['temp_min'] as num?)?.toDouble() ?? 0.0,
      tempMax: (main['temp_max'] as num?)?.toDouble() ?? 0.0,
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      pressure: (main['pressure'] as num?)?.toInt() ?? 0,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      windDegree: (wind['deg'] as num?)?.toInt() ?? 0,
      description: weather?['description'] as String? ?? '',
      iconCode: weather?['icon'] as String? ?? '',
      visibility: (json['visibility'] as num?)?.toInt() ?? 0,
      sunrise: DateTime.fromMillisecondsSinceEpoch(((sys['sunrise'] as num?) ?? 0).toInt() * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(((sys['sunset'] as num?) ?? 0).toInt() * 1000),
    );
  }
}
