import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/country_model.dart';
import 'package:weather_app/location_weather.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controller = new TextEditingController();

  Future<List<Country>> _fetchCountry;
  Future<LocationWeather> _fetchWeather;
  LocationWeather _locationWeather;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter a location...',
                ),
              ),
              SizedBox(height: 20),
              if (_locationWeather != null) ...[
                Text(
                  _locationWeather.title,
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  _locationWeather.consolidatedWeather.first.weatherStateName,
                  style: Theme.of(context).textTheme.headline2,
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text('Max'),
                        Text(
                          _locationWeather.consolidatedWeather.first.maxTemp
                              .round()
                              .toString(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Min'),
                        Text(
                          _locationWeather.consolidatedWeather.first.minTemp
                              .round()
                              .toString(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              // FutureBuilder(
              //     future: _fetchWeather,
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Center(child: CircularProgressIndicator());
              //       }
              //       final country = snapshot.data;
              //       return Text(country.title);
              //     }),
              if (_locationWeather == null)
                FutureBuilder(
                    future: _fetchWeather,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Text('Could not get location');
                    }),
              SizedBox(height: 20),
              FutureBuilder(
                future: _fetchCountry,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot?.data == null) {
                    return Center(child: Text('Search a location'));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Location not found'));
                  }

                  return Column(
                    children: [
                      Text('Select a country',
                          style: Theme.of(context).textTheme.headline5),
                      for (var country in snapshot.data)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              fetchWeather(country.woeid.toString())
                                  .then((value) {
                                setState(() {
                                  _locationWeather = value;
                                });
                              });
                            },
                            child: Text(country.title),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _fetchCountry = fetchLocation(_controller.text);
          });
        },
        child: Icon(Icons.search_rounded),
      ),
    );
  }
}

Future<List<Country>> fetchLocation(String location) async {
  final response = await http
      .get('https://www.metaweather.com/api/location/search/?query=$location');

  if (response.statusCode == 200) {
    // return countryFromJson(jsonDecode(response.body));
    return countryFromJson(response.body);
  } else {
    throw Exception('Could not fetch weather for $location');
  }
}

Future<LocationWeather> fetchWeather(String woeId) async {
  final response =
      await http.get('https://www.metaweather.com/api/location/$woeId');

  if (response.statusCode == 200) {
    // return countryFromJson(jsonDecode(response.body));
    return locationWeatherFromJson(response.body);
  } else {
    throw Exception('Could not fetch weather');
  }
}
