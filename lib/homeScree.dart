import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/WeatherData/weather_info_grid.dart';
import 'WeatherData/weather_info_card.dart';
import 'WeatherData/weather_forecast_card.dart';
import 'daylight_chart.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final TextEditingController _controller = TextEditingController();
  String _cityName = 'Peshawar';
  Map<String, dynamic>? _weatherData;
  final String _apiKey = 'c50102759fdcd0dac529ebc857a9dda6';

  @override
  void initState() {
    super.initState();
    fetchWeather(_cityName);
  }

  void fetchWeather(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        _weatherData = jsonDecode(response.body);
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('City not found')));
    }
  }

  Future<List<Map<String, dynamic>>> fetch5DayForecast(String city) async {
    final forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$_apiKey&units=metric';
    final res = await http.get(Uri.parse(forecastUrl));

    if (res.statusCode != 200) throw Exception('Failed to load forecast');

    final data = jsonDecode(res.body);
    final List<Map<String, dynamic>> filteredForecast = [];

    final List list = data['list'];
    for (int i = 0; i < list.length; i += 8) {
      final item = list[i];
      final date = DateTime.parse(item['dt_txt']);
      final day = DateFormat('E').format(date);
      final temp = item['main']['temp'].round();
      final main = item['weather'][0]['main'];
      filteredForecast.add({'day': day, 'temp': temp, 'main': main});
    }

    return filteredForecast;
  }

  String formatTime(int timestamp) {
    final time = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
    ).toLocal();
    return DateFormat('hh:mm a').format(time);
  }

  Icon _getWeatherIcon(String main) {
    switch (main.toLowerCase()) {
      case 'clouds':
        return const Icon(Icons.cloud, size: 64, color: Colors.grey);
      case 'rain':
        return const Icon(Icons.water_drop, size: 64, color: Colors.blue);
      case 'clear':
        return const Icon(Icons.wb_sunny, size: 64, color: Colors.orange);
      case 'snow':
        return const Icon(Icons.ac_unit, size: 64, color: Colors.lightBlue);
      case 'thunderstorm':
        return const Icon(Icons.flash_on, size: 64, color: Colors.yellow);
      default:
        return const Icon(Icons.wb_cloudy, size: 64, color: Colors.grey);
    }
  }

  IconData _getIconFromMain(String main) {
    switch (main.toLowerCase()) {
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.water_drop;
      case 'clear':
        return Icons.wb_sunny;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      default:
        return Icons.wb_cloudy;
    }
  }

  String _getPrecipitation(Map<String, dynamic> data) {
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

  @override
  Widget build(BuildContext context) {
    final currentTime = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(26, 55, 52, 52),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.only(left: 12, top: 6, right: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.black),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Search Location',
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              _cityName = value.trim();
                              fetchWeather(_cityName);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (_weatherData != null) ...[
                  WeatherInfoCard(
                    city: _weatherData!['name'],
                    temperature: _weatherData!['main']['temp'].round(),
                    mainWeather: _weatherData!['weather'][0]['main'],
                    weatherIcon: _getWeatherIcon(
                      _weatherData!['weather'][0]['main'],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        WeatherInfoGrid(
                          currentTime: currentTime,
                          humidity: '${_weatherData!['main']['humidity']}%',
                          feelsLike:
                              '${_weatherData!['main']['feels_like'].round()}°',
                          wind: '${_weatherData!['wind']['speed']} m/s',
                          pressure: '${_weatherData!['main']['pressure']} hPa',
                          visibility:
                              '${(_weatherData!['visibility'] / 1000).toStringAsFixed(1)} km',
                          clouds: '${_weatherData!['clouds']['all']}%',
                          precipitation: _getPrecipitation(_weatherData!),
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Sunrise',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatTime(_weatherData!['sys']['sunrise']),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Sunset',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatTime(_weatherData!['sys']['sunset']),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _daylightInfo(),
                        const SizedBox(height: 16),
                        DaylightChart(
                          sunrise: DateTime.fromMillisecondsSinceEpoch(
                            _weatherData!['sys']['sunrise'] * 1000,
                          ),
                          sunset: DateTime.fromMillisecondsSinceEpoch(
                            _weatherData!['sys']['sunset'] * 1000,
                          ),
                          now: DateTime.now(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Weather Forecast',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: fetch5DayForecast(_cityName),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Failed to load forecast');
                      } else {
                        final List forecast = snapshot.data!;
                        return WeatherForecastCard(
                          forecast: forecast,
                          getIconFromMain: _getIconFromMain,
                        );
                      }
                    },
                  ),
                ] else
                  const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _daylightInfo() {
    final sunrise = DateTime.fromMillisecondsSinceEpoch(
      _weatherData!['sys']['sunrise'] * 1000,
    );
    final sunset = DateTime.fromMillisecondsSinceEpoch(
      _weatherData!['sys']['sunset'] * 1000,
    );
    final now = DateTime.now();

    final totalDuration = sunset.difference(sunrise);
    final remainingDuration = sunset.difference(now);

    String formatDuration(Duration d) => '${d.inHours}H ${(d.inMinutes % 60)}M';

    return Column(
      children: [
        Text('Length of day: ${formatDuration(totalDuration)}'),
        Text('Remaining daylight: ${formatDuration(remainingDuration)}'),
      ],
    );
  }
}
