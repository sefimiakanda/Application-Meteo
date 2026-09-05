import 'package:flutter/foundation.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

enum WeatherStatus { initial, loading, success, error }

class WeatherController extends ChangeNotifier {
  final WeatherService _service;

  WeatherStatus _status = WeatherStatus.initial;
  WeatherModel? _weather;
  String _errorMessage = '';
  final List<String> _searchHistory = [];

  WeatherController({WeatherService? service}) : _service = service ?? WeatherService();

  WeatherStatus get status => _status;
  WeatherModel? get weather => _weather;
  String get errorMessage => _errorMessage;
  List<String> get searchHistory => List.unmodifiable(_searchHistory);

  bool get isLoading => _status == WeatherStatus.loading;
  bool get hasData => _weather != null;
  bool get hasError => _status == WeatherStatus.error;

  Future<void> fetchWeather(String city) async {
    final query = city.trim();

    if (query.isEmpty) {
      _status = WeatherStatus.error;
      _errorMessage = 'Veuillez saisir le nom d’une ville.';
      notifyListeners();
      return;
    }

    _status = WeatherStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await _service.fetchWeather(query);
      _weather = result;
      _status = WeatherStatus.success;
      _addToHistory(query);
    } on WeatherApiException catch (error) {
      _weather = null;
      _status = WeatherStatus.error;
      _errorMessage = error.message;
    } catch (_) {
      _weather = null;
      _status = WeatherStatus.error;
      _errorMessage = 'Une erreur inattendue est survenue.';
    }

    notifyListeners();
  }

  void _addToHistory(String city) {
    final normalized = city.trim();
    if (normalized.isEmpty) {
      return;
    }

    _searchHistory.remove(normalized);
    _searchHistory.insert(0, normalized);
    if (_searchHistory.length > 5) {
      _searchHistory.removeRange(5, _searchHistory.length);
    }
  }
}
