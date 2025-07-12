import 'package:flutter/material.dart';

class WeatherInfoCard extends StatelessWidget {
  final String city;
  final int temperature;
  final String mainWeather;
  final Icon weatherIcon;

  const WeatherInfoCard({
    super.key,
    required this.city,
    required this.temperature,
    required this.mainWeather,
    required this.weatherIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        weatherIcon,
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              city,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.location_on, size: 18),
          ],
        ),
        Text(
          '$temperature°',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          mainWeather,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}