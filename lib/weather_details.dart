import 'package:flutter/material.dart';
import 'package:weather_app/models/location_weather.dart';

class WeatherDetails extends StatefulWidget {
  const WeatherDetails({
    Key key,
    @required LocationWeather locationWeather,
  })  : _locationWeather = locationWeather,
        super(key: key);

  final LocationWeather _locationWeather;

  @override
  _WeatherDetailsState createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget._locationWeather.title,
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          widget._locationWeather.consolidatedWeather.first.weatherStateName,
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
                  widget._locationWeather.consolidatedWeather.first.maxTemp
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
                  widget._locationWeather.consolidatedWeather.first.minTemp
                      .round()
                      .toString(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
