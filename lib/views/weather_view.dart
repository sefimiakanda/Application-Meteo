import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/weather_controller.dart';
import '../models/weather_model.dart';
import '../utils/weather_utils.dart';
import '../widgets/weather_widgets.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> with TickerProviderStateMixin {
  final TextEditingController _cityController = TextEditingController();
  late final AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _searchWeather(WeatherController controller) {
    final city = _cityController.text;
    if (city.trim().isNotEmpty) {
      controller.fetchWeather(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherController>(
      builder: (context, controller, child) {
        final weather = controller.weather;
        final colors = weather != null ? WeatherUtils.getGradientColors(weather.iconCode) : const [Color(0xFF0F172A), Color(0xFF1D4ED8)];

        if (controller.status == WeatherStatus.success && weather != null) {
          _fadeController.forward(from: 0);
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WeatherSearchBar(
                      controller: _cityController,
                      onSearch: () => _searchWeather(controller),
                      suggestions: controller.searchHistory,
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: _buildStatusContent(controller, weather),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusContent(WeatherController controller, WeatherModel? weather) {
    switch (controller.status) {
      case WeatherStatus.initial:
        return const WeatherInitialWidget();
      case WeatherStatus.loading:
        return const WeatherLoadingWidget();
      case WeatherStatus.error:
        return WeatherErrorWidget(
          message: controller.errorMessage,
          onRetry: () => _searchWeather(controller),
        );
      case WeatherStatus.success:
        if (weather == null) {
          return const WeatherInitialWidget();
        }
        return FadeTransition(
          opacity: _fadeController,
          child: _WeatherDataView(weather: weather),
        );
    }
  }
}

class _WeatherDataView extends StatelessWidget {
  final WeatherModel weather;

  const _WeatherDataView({required this.weather});

  @override
  Widget build(BuildContext context) {
    final sunrise = WeatherUtils.formatTime(weather.sunrise);
    final sunset = WeatherUtils.formatTime(weather.sunset);
    final visibilityKm = (weather.visibility / 1000).toStringAsFixed(1);
    final windDirection = WeatherUtils.getWindDirection(weather.windDegree);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                '${weather.cityName}, ${weather.country}',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            WeatherUtils.formatDate(DateTime.now()),
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  WeatherUtils.getWeatherEmoji(weather.iconCode),
                  style: const TextStyle(fontSize: 52),
                ),
                const SizedBox(width: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      WeatherUtils.formatTemp(weather.temperature),
                      style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      WeatherUtils.capitalize(weather.description),
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _InfoPill(label: 'Ressentie', value: WeatherUtils.formatTemp(weather.feelsLike)),
              _InfoPill(label: 'Min', value: WeatherUtils.formatTemp(weather.tempMin)),
              _InfoPill(label: 'Max', value: WeatherUtils.formatTemp(weather.tempMax)),
            ],
          ),
          const SizedBox(height: 30),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.9,
            children: [
              WeatherDetailCard(icon: Icons.water_drop_rounded, label: 'Humidité', value: '${weather.humidity} %', iconColor: Colors.lightBlueAccent),
              WeatherDetailCard(icon: Icons.air_rounded, label: 'Vent', value: '${weather.windSpeed.toStringAsFixed(1)} m/s • $windDirection', iconColor: Colors.cyan),
              WeatherDetailCard(icon: Icons.speed_rounded, label: 'Pression', value: '${weather.pressure} hPa', iconColor: Colors.amber),
              WeatherDetailCard(icon: Icons.visibility_rounded, label: 'Visibilité', value: '$visibilityKm km', iconColor: Colors.deepPurpleAccent),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SunInfo(label: 'Lever', time: sunrise, icon: Icons.wb_sunny_outlined),
                _SunInfo(label: 'Coucher', time: sunset, icon: Icons.mode_night_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final String value;

  const _InfoPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SunInfo extends StatelessWidget {
  final String label;
  final String time;
  final IconData icon;

  const _SunInfo({required this.label, required this.time, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 26),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(time, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
