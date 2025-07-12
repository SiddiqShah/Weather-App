import 'package:flutter/material.dart';

class WeatherInfoGrid extends StatelessWidget {
  final String currentTime;
  final String humidity;
  final String feelsLike;
  final String wind;
  final String pressure;
  final String visibility;
  final String clouds;
  final String precipitation;

  const WeatherInfoGrid({
    super.key,
    required this.currentTime,
    required this.humidity,
    required this.feelsLike,
    required this.wind,
    required this.pressure,
    required this.visibility,
    required this.clouds,
    required this.precipitation,
  });

  Widget _infoTile(String label, String value) {
    return SizedBox(
      width: 75,
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _infoTile('Time', currentTime),
            _infoTile('Humidity', humidity),
            _infoTile('Feels Like', feelsLike),
            _infoTile('Wind', wind),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _infoTile('Pressure', pressure),
            _infoTile('Visibility', visibility),
            _infoTile('Clouds', clouds),
            _infoTile('Precipitation', precipitation),
          ],
        ),
      ],
    );
  }
}