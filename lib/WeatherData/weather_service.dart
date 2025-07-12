import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WeatherService {
  static Future<Map<String, dynamic>?> fetchWeather(
      String city, String apiKey, BuildContext context) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('City not found')),
      );
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> fetch5DayForecast(
      String city, String apiKey) async {
    final forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';
    final res = await http.get(Uri.parse(forecastUrl));

    if (res.statusCode != 200) throw Exception('Failed to load forecast');

    final data = jsonDecode(res.body);
    final List<Map<String, dynamic>> filteredForecast = [];

    final List list = data['list'];
    for (int i = 0; i < list.length; i += 8) {
      final item = list[i];
      final date = DateTime.parse(item['dt_txt']);
      final day = date.weekday == DateTime.now().weekday
          ? 'Today'
          : date.weekday == DateTime.now().add(Duration(days: 1)).weekday
          ? 'Tomorrow'
          : date.weekday == 7
          ? 'Sun'
          : date.weekday == 1
          ? 'Mon'
          : date.weekday == 2
          ? 'Tue'
          : date.weekday == 3
          ? 'Wed'
          : date.weekday == 4
          ? 'Thu'
          : date.weekday == 5
          ? 'Fri'
          : 'Sat';
      final temp = item['main']['temp'].round();
      final main = item['weather'][0]['main'];
      filteredForecast.add({'day': day, 'temp': temp, 'main': main});
    }

    return filteredForecast;
  }

  static String getPrecipitation(Map<String, dynamic> data) {
    if (data.containsKey('rain')) {
      if (data['rain'] is Map && data['rain'].containsKey('1h')) {
        return '${data['rain']['1h']} mm';
      }
      if (data['rain'] is Map && data['rain'].containsKey('3h')) {
        return '${data['rain']['3h']} mm';
      }
    }
    if (data.containsKey('snow')) {
      if (data['snow'] is Map && data['snow'].containsKey('1h')) {
        return '${data['snow']['1h']} mm';
      }
      if (data['snow'] is Map && data['snow'].containsKey('3h')) {
        return '${data['snow']['3h']} mm';
      }
    }
    return '0 mm';
  }
}