import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/widgets/additional_info_card.dart';
import 'package:weather_app/widgets/hourly_forecast_card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool isLoading = true;
  double currentTemp = 0;
  String currentSkyCondition = '';
  TextEditingController cityController = TextEditingController();
  double currentWindSpeed = 0;
  double currentHumidity = 0;
  double currentPressure = 0;
  List<dynamic> hourlyForecast = [];

  String cityName = 'Kolkata';

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<void> getCurrentWeather() async {
    try {
      String apiKey = "c94a4c15801bdf899759e9b2c954464c";

      final response = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          currentTemp = (data["main"]["temp"] - 273.15);
          isLoading = false;
          currentSkyCondition = data["weather"][0]["main"];
          currentWindSpeed = data["wind"]["speed"];
          currentHumidity = data["main"]["humidity"].toDouble();
          currentPressure = data["main"]["pressure"] / 100;
        });
      } else {
        print("Error: ${response.statusCode}");
      }

      final hourlyResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey'));

      if (hourlyResponse.statusCode == 200) {
        final hourlyData = jsonDecode(hourlyResponse.body);
        setState(() {
          hourlyForecast = hourlyData['list'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          cityName[0].toUpperCase() + cityName.substring(1),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              getCurrentWeather();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 10,
                        child: Column(
                          children: [
                            Text(
                              '${currentTemp.toStringAsFixed(2)} ℃',
                              style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              currentSkyCondition == 'Clouds' ||
                                      currentSkyCondition == 'Mist' ||
                                      currentSkyCondition == 'Rain'
                                  ? Icons.cloud
                                  : Icons.wb_sunny,
                              size: 64,
                              color: currentSkyCondition == 'Clouds' ||
                                      currentSkyCondition == 'Mist' ||
                                      currentSkyCondition == 'Rain'
                                  ? Colors.blueGrey
                                  : Colors.orange,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              currentSkyCondition,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Hourly Forecast',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: hourlyForecast.take(8).map((forecast) {
                          final time = DateTime.parse(forecast['dt_txt']);
                          final temp = forecast['main']['temp'] - 273.15;
                          final weather = forecast['weather'][0]['main'];
                          return HourlyForecastCard(
                            time: '${time.hour}:00',
                            temp: '${temp.toStringAsFixed(2)} ℃',
                            weather: weather,
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Additional Info',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AdditionalInfo(
                          title: 'Wind',
                          value: currentWindSpeed.toStringAsFixed(2) + 'km/h',
                          icon: Icons.air,
                        ),
                        AdditionalInfo(
                          title: 'Humidity',
                          value: currentHumidity.toStringAsFixed(2) + '%',
                          icon: Icons.water,
                        ),
                        AdditionalInfo(
                          title: 'Pressure',
                          value: currentPressure.toStringAsFixed(1) + 'hPa',
                          icon: Icons.arrow_downward,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Change Location'),
                                  content: TextField(
                                    controller: cityController,
                                    onChanged: (value) {
                                      cityName = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Enter City Name',
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp('[a-zA-Z]'),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          cityName = cityController.text;
                                          isLoading = true;
                                        });
                                        getCurrentWeather();
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Change Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
