import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/location_model.dart';
import 'models/location_weather.dart';

class ApiService {
  Future<List<Location>> fetchLocation(String location) async {
    try {
      final response = await http.get(
          'https://www.metaweather.com/api/location/search/?query=$location');

      if (response.statusCode == 200) {
        // return locationFromJson(response.body);
        print(response.body);
        return locationFromJson(response.body);
      } else {
        throw Exception('Could not fetch location');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<LocationWeather> fetchWeather(String woeId) async {
    try {
      final response =
          await http.get('https://www.metaweather.com/api/location/$woeId');

      if (response.statusCode == 200) {
        // return countryFromJson(jsonDecode(response.body));
        // return locationWeatherFromJson(response.body);
        return LocationWeather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Could not fetch weather');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
