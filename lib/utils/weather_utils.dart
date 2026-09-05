import 'dart:ui';

import 'package:intl/intl.dart';

class WeatherUtils {
  WeatherUtils._();

  static List<Color> getGradientColors(String iconCode) {
    if (iconCode.endsWith('n')) {
      return const [Color(0xFF0F172A), Color(0xFF020617)];
    }
    if (iconCode.startsWith('01')) {
      return const [Color(0xFF7DD3FC), Color(0xFF60A5FA)];
    }
    if (iconCode.startsWith('02') || iconCode.startsWith('03') || iconCode.startsWith('04')) {
      return const [Color(0xFFB9C7D4), Color(0xFF7C8FA4)];
    }
    if (iconCode.startsWith('09') || iconCode.startsWith('10') || iconCode.startsWith('11')) {
      return const [Color(0xFF1D4ED8), Color(0xFF0F172A)];
    }
    return const [Color(0xFF67E8F9), Color(0xFF2563EB)];
  }

  static String getWindDirection(int degrees) {
    const directions = ['N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'];
    final index = ((degrees + 11.25) ~/ 22.5) % 16;
    return directions[index];
  }

  static String getWeatherEmoji(String iconCode) {
    if (iconCode.startsWith('01')) return '☀️';
    if (iconCode.startsWith('02')) return '🌤️';
    if (iconCode.startsWith('03') || iconCode.startsWith('04')) return '☁️';
    if (iconCode.startsWith('09') || iconCode.startsWith('10')) return '🌧️';
    if (iconCode.startsWith('11')) return '⛈️';
    if (iconCode.startsWith('13')) return '❄️';
    if (iconCode.startsWith('50')) return '🌫️';
    if (iconCode.endsWith('n')) return '🌙';
    return '🌡️';
  }

  static String formatTemp(double temp) => '${temp.round()}°C';

  static String formatTime(DateTime dt) => DateFormat.Hm('fr_FR').format(dt);

  static String formatDate(DateTime dt) => DateFormat('EEEE d MMMM y', 'fr_FR').format(dt);

  static String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
