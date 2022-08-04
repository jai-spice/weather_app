import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // deferred import

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Weather App',
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final TextEditingController queryController = TextEditingController();

  String _currentTemperature = '';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  Future<void> search(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      final uri = Uri.parse(
          'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$query?unitGroup=metric&key=9JKGUSYZW2RMRYDJBRM9L83ZH&contentType=json');
      final response = await http.get(uri);
      final data = json.decode(response.body);

      setState(() {
        _currentTemperature = '${data["currentConditions"]["temp"]} °C';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather API Demo'),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
              controller: queryController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Query'),
              ),
            ),
          ),
          TextButton(
            child: const Text('Search'),
            onPressed: () {
              search(queryController.text);
            },
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Text(
              _currentTemperature,
              style: Theme.of(context).textTheme.headline1,
            ),
        ],
      )),
    );
  }
}
