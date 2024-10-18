import 'package:flutter/material.dart';

class WeatherForecastList extends StatelessWidget {
  final List<Map<String, dynamic>> forecast;

  const WeatherForecastList({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: forecast.length,
      itemBuilder: (context, index) {
        final item = forecast[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network('http://openweathermap.org/img/wn/${item['icon']}@2x.png'),
                const SizedBox(height: 8),
                Text(
                  '${item['date']}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${item['temp']}°C',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  item['description'],
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}