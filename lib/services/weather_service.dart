import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherApiException implements Exception {
  final String message;
  const WeatherApiException(this.message);

  @override
  String toString() => message;
}

class WeatherService {
  static const String _apiKey = '721d3b7a5e66562478cac13c6b1c6f0d';

  final http.Client _client;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  Future<WeatherModel> fetchWeather(String city) async {
    final query = city.trim();
    if (query.isEmpty) {
      throw const WeatherApiException('Veuillez saisir le nom d’une ville.');
    }

    final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': query,
      'appid': _apiKey,
      'units': 'metric',
      'lang': 'fr',
    });

    try {
      final response = await _client.get(uri);

      switch (response.statusCode) {
        case 200:
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic>) {
            return WeatherModel.fromJson(decoded);
          }
          throw const WeatherApiException('Réponse invalide du serveur.');
        case 401:
          throw const WeatherApiException('Clé API invalide. Vérifiez votre configuration.');
        case 404:
          throw WeatherApiException('Ville "$query" introuvable. Vérifiez l’orthographe.');
        case 429:
          throw const WeatherApiException('Limite de requêtes atteinte. Réessayez plus tard.');
        default:
          throw WeatherApiException('Erreur serveur (${response.statusCode}).');
      }
    } on WeatherApiException {
      rethrow;
    } on SocketException {
      throw const WeatherApiException('Vérifiez votre connexion internet.');
    } on FormatException {
      throw const WeatherApiException('Réponse invalide du serveur.');
    } catch (_) {
      throw const WeatherApiException('Une erreur inattendue est survenue.');
    }
  }
}
