import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

import 'main.dart';
import 'main.dart';
import 'main.dart';
import 'main.dart';
import 'weather_data.dart';

class HomePageHeaderContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LocationLabel(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  signOutGoogle().whenComplete(() {
                    localStorage.clear();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInScreen()));
                  });
                },
                color: Colors.red,
                child: Text(
                  'Log Out',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 30.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  LocationRichText(),
                ],
              ),
              CurrentWeatherInfo(),
            ],
          ),
        ),
      ],
    );
  }
}

//Text that shows the User's Country and Locality.
class LocationRichText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '${WeatherData.userLocality},\n ${WeatherData.userCountry}',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

//To show the User's current weather data
class CurrentWeatherInfo extends StatefulWidget {
  @override
  _CurrentWeatherInfoState createState() => _CurrentWeatherInfoState();
}

class _CurrentWeatherInfoState extends State<CurrentWeatherInfo>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        localStorage.getString('fName') != null
            ? Text(
                'Welcome: ${localStorage.getString('fName')}',
                style: TextStyle(color: Colors.white, fontSize: 30.0),
              )
            : SizedBox.shrink(),
        Row(
          children: <Widget>[
            SizedBox(width: 10.0),
            Text(
              '${WeatherData.temp}°C, ${WeatherData.tempDesc}',
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
              ),
            )
          ],
        ),
       
      ],
    );
  }
}

//To show the location tag at the top of the HomePage.
class LocationLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Card(
        margin: EdgeInsets.all(0.0),
        color: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Your current location',
            style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class WeatherExtrasContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          WeatherData.isCurrentWeatherLoading == true
              ? SpinKitHourGlass(
                  color: Colors.orange,
                )
              : WeatherExtras(
                  title: 'Humidity',
                  value: '${WeatherData.temp}%',
                  icon: FontAwesomeIcons.rainbow,
                ),
          WeatherData.isCurrentWeatherLoading == true
              ? SpinKitHourGlass(
                  color: Colors.orange,
                )
              : WeatherExtras(
                  title: 'Wind',
                  value: '${WeatherData.wind}mph',
                  icon: FontAwesomeIcons.wind,
                ),
          WeatherData.isCurrentWeatherLoading == true
              ? SpinKitHourGlass(
                  color: Colors.orange,
                )
              : WeatherExtras(
                  title: 'Feels Like',
                  value: '${WeatherData.feelsLike}°C',
                  icon: FontAwesomeIcons.coffee,
                ),
        ],
      ),
    );
  }
}

class WeatherExtras extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;

  WeatherExtras(
      {@required this.title, @required this.value, @required this.icon});

  @override
  _WeatherExtrasState createState() => _WeatherExtrasState();
}

class _WeatherExtrasState extends State<WeatherExtras> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: FaIcon(
            widget.icon,
            size: 18.0,
          ),
        ),
        SizedBox(width: 10.0),
        RichText(
          text: TextSpan(
            text: '${widget.title}\n',
            style: TextStyle(color: Color(0xff2B3E6C), fontSize: 18.0),
            children: <TextSpan>[
              TextSpan(
                text: widget.value,
                style: TextStyle(
                    color: Color(0xff2B3E6C),
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
