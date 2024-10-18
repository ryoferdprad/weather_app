import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'widgets/weather_forecast_list.dart';
import 'widgets/weather_info.dart';
import 'widgets/favorite_locations.dart';

class WeatherHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const WeatherHomePage({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _weatherInfo = 'Enter a city name to get weather info';
  String _weatherAnimation = 'assets/sunny.json';
  String _errorMessage = '';
  List<Map<String, dynamic>> _forecast = [];
  List<String> _favoriteLocations = [];
  final String apiKey = 'e2f41a80b7663eb9c1f7d170414c8090';

  Future<void> _fetchWeather(String city) async {
    final weatherUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey';
    final forecastUrl = 'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&appid=$apiKey';

    final weatherResponse = await http.get(Uri.parse(weatherUrl));
    final forecastResponse = await http.get(Uri.parse(forecastUrl));

    if (weatherResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
      final weatherData = json.decode(weatherResponse.body);
      final forecastData = json.decode(forecastResponse.body);

      setState(() {
        _weatherInfo = '''
Temperature: ${weatherData['main']['temp']}°C
Humidity: ${weatherData['main']['humidity']}%
Wind Speed: ${weatherData['wind']['speed']} m/s
Precipitation: ${weatherData['weather'][0]['description']}
        ''';
        _weatherAnimation = _getWeatherAnimation(weatherData['weather'][0]['main']);
        _errorMessage = '';

        // Filter forecast data for the next 2 days
        final now = DateTime.now();
        _forecast = (forecastData['list'] as List)
            .map((item) {
              return {
                'date': item['dt_txt'],
                'temp': item['main']['temp'],
                'description': item['weather'][0]['description'],
                'icon': item['weather'][0]['icon'],
              };
            })
            .where((item) {
              final date = DateTime.parse(item['date']);
              return date.isAfter(now) && date.isBefore(now.add(Duration(days: 2)));
            })
            .toList();
      });
    } else {
      setState(() {
        _weatherInfo = '';
        _weatherAnimation = 'assets/sunny.json';
        _errorMessage = 'City not found. Please try again.';
        _forecast = [];
      });
    }
  }

  String _getWeatherAnimation(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return 'assets/sunny.json';
      case 'clouds':
        return 'assets/sunnycloudy.json';
      case 'rain':
      case 'drizzle':
        return 'assets/windy.json';
      case 'thunderstorm':
        return 'assets/thundering.json';
      case 'haze':
      case 'fog':
        return 'assets/haze.json';
      default:
        return 'assets/sunny.json';
    }
  }

  void _addFavoriteLocation(String city) {
    setState(() {
      if (!_favoriteLocations.contains(city)) {
        _favoriteLocations.add(city);
      }
    });
  }

  void _removeFavoriteLocation(String city) {
    setState(() {
      _favoriteLocations.remove(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      drawer: Drawer(
        child: FavoriteLocations(
          favoriteLocations: _favoriteLocations,
          onSelectLocation: (city) {
            Navigator.pop(context); // Close the drawer
            _fetchWeather(city);
          },
          onRemoveLocation: _removeFavoriteLocation,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Date and Time: ${DateTime.now()}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter city name',
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchWeather(_controller.text);
              },
              child: const Text('Get Weather'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            if (_weatherAnimation.isNotEmpty)
              Lottie.asset(_weatherAnimation, width: 150, height: 150),
            const SizedBox(height: 20),
            if (_weatherInfo.isNotEmpty && _weatherInfo != 'Enter a city name to get weather info')
              WeatherInfo(weatherInfo: _weatherInfo),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(fontSize: 18, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),
            if (_forecast.isNotEmpty)
              Expanded(
                child: WeatherForecastList(forecast: _forecast),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addFavoriteLocation(_controller.text);
        },
        child: Icon(Icons.favorite),
      ),
    );
  }
}