import 'package:flutter/material.dart';

class HourlyForecastCard extends StatelessWidget {
  final String time;
  final String temp;
  final String weather;

  const HourlyForecastCard(
      {super.key,
      required this.time,
      required this.temp,
      required this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        width: 100,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          elevation: 6,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white, Color.fromARGB(255, 227, 244, 74)],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft),
            ),
            width: 98,
            child: Column(
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Icon(
                  weather == 'Clouds' || weather == 'Mist' || weather == 'Rain'
                      ? Icons.cloud
                      : Icons.wb_sunny,
                  size: 30,
                  color: weather == 'Clouds' ||
                          weather == 'Mist' ||
                          weather == 'Rain'
                      ? Colors.blueGrey
                      : Colors.orange,
                ),
                const SizedBox(height: 10),
                Text(
                  temp,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
