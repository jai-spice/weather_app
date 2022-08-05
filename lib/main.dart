import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/weather.dart'; // deferred import

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

  Weather? _weather;

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
    setState(() {
      _isLoading = true;
    });
    http.Response? response;
    try {
      final uri = Uri.parse(
          'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$query?unitGroup=metric&key=9JKGUSYZW2RMRYDJBRM9L83ZH&contentType=json');
      response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        final data = json.decode(response.body);
        setState(() {
          _weather = Weather.fromJson(data); // Weather /// TYPE SAFE
        }); // Map<String, dynamic> !!! NOT TYPE SAFE

      } else {
        throw Exception("Status: ${response.statusCode}");
      }
    } on FormatException catch (_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response?.body}')));
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No Internet Connection!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
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
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Search'),
            onPressed: () {
              search(queryController.text);
            },
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Temperature at ${_weather?.resolvedAddress ?? "-"} is ',
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text(
                  '${_weather?.currentConditions.temp ?? "-"}°C',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
        ],
      )),
    );
  }
}
