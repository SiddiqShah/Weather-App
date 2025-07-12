import 'package:flutter/material.dart';

class WeatherForecastCard extends StatelessWidget {
  final List forecast;
  final IconData Function(String) getIconFromMain;

  const WeatherForecastCard({
    super.key,
    required this.forecast,
    required this.getIconFromMain,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecast.length,
        itemBuilder: (context, index) {
          final day = forecast[index];
          return Container(
            width: 90,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day['day'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Icon(
                  getIconFromMain(day['main']),
                  color: Colors.blueAccent,
                  size: 32,
                ),
                const SizedBox(height: 6),
                Text('${day['temp']}°C'),
              ],
            ),
          );
        },
      ),
    );
  }
}