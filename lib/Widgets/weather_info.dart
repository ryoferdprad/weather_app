import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeatherInfo extends StatelessWidget {
  final String weatherInfo;

  const WeatherInfo({Key? key, required this.weatherInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final infoParts = weatherInfo.split('\n');
    if (infoParts.length < 4) {
      return Container(); // Return an empty container if the info is incomplete
    }
    final temperature = infoParts[0].split(': ')[1];
    final humidity = infoParts[1].split(': ')[1];
    final windSpeed = infoParts[2].split(': ')[1];
    final precipitation = infoParts[3].split(': ')[1];

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(FontAwesomeIcons.thermometerHalf, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                'Temperature: $temperature',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              FaIcon(FontAwesomeIcons.tint, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Humidity: $humidity',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              FaIcon(FontAwesomeIcons.wind, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                'Wind Speed: $windSpeed',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              FaIcon(FontAwesomeIcons.cloudRain, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Precipitation: $precipitation',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}