import 'package:flutter/material.dart';
import 'package:weather_app/weather_details.dart';
import 'api_service.dart';
import 'models/location_model.dart';
import 'models/location_weather.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controller = new TextEditingController();
  ApiService _api = new ApiService();

  Future<List<Location>> _getLocation;
  // Future<LocationWeather> _getWeather;
  LocationWeather _locationWeather;

  void searchLocation() {
    setState(() {
      _getLocation = _api.fetchLocation(_controller.text);
    });
  }

  void getWeather(int woeid) {
    _api.fetchWeather(woeid.toString()).then((value) {
      setState(() {
        _locationWeather = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather App')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter a location...',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // TODO: Navigate to new screen when a user taps on any list item
              if (_locationWeather != null) ...[
                WeatherDetails(locationWeather: _locationWeather),
              ],
              SizedBox(height: 20),
              FutureBuilder<List<Location>>(
                future: _getLocation,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Error while fetching location(s)'));
                  } else if (snapshot?.data == null) {
                    return Center(child: Text('Error fetching location(s)'));
                  }
                  return Column(
                    children: <Widget>[
                      Text(
                        'Select a country',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      for (var location in snapshot.data)
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => getWeather(location.woeid),
                            child: Text(location.title),
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
        onPressed: () => searchLocation(),
        child: Icon(Icons.search_rounded),
      ),
    );
  }
}
