import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/FullDetailsWeatherPage.dart';
import 'package:weather_app/HomeHeaderContent.dart';
import 'package:weather_app/Weather/WeatherDetails.dart';

import 'Weather/WeatherListView.dart';
import 'weather_data.dart';

enum TabText { TODAY, TOMORROW, WEEK }

TabText selectedTab = TabText.TODAY;

const Color activeColor = Color(0xffEBF2FF);
const Color inActiveColor = Color(0xffffffff);

FontWeight todayFW;
FontWeight tomorrowFW;
FontWeight weekFW;

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  double height;
  double width;
  String selectedItem = '';

  List<String> _dayType = ["Today", "Tomorrow", "Week"];

  String currentTime() {
    String now;
    setState(() {
      now = DateFormat("HH:mm aa").format(DateTime.now());
    });
    return now;
  }

  void readTime() {
    Timer.periodic(Duration(seconds: 0), (Timer t) => {currentTime()});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    readTime();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: height * 0.02),
                height: height * 0.5,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 0.3,
                          spreadRadius: 0.3)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(height * 0.05))),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: WeatherExtrasContainer()),
              ),
              Container(
                child: SafeArea(child: HomePageHeaderContent()),
                height: height * 0.4,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(height * 0.05))),
              ),
            ],
          ),
          SizedBox(height: height * 0.04),
          _currentTime(),
          if (selectedTab == TabText.TODAY &&
              WeatherData.weatherForToday.length > 0)
            Center(child: Text('Double Click "Today" to view full screen.', style: TextStyle(color: Colors.red),)),
          if (selectedTab == TabText.TOMORROW)
            Center(child: Text('Double Click "Tomorrow" to view full screen.', style: TextStyle(color: Colors.red),)),
          if (selectedTab == TabText.WEEK)
            Center(child: Text('Double Click "Week" to view full screen.', style: TextStyle(color: Colors.red),)),
          SizedBox(
            height: height * 0.04,
          ),
          generateTab(),
          SizedBox(height: 20.0),
          if (selectedTab == TabText.TODAY)
            WeatherListView(
              weatherList: WeatherData.weatherForToday,
              weatherEnum: TabText.TODAY,
            )
          else if (selectedTab == TabText.TOMORROW)
            WeatherListView(
              weatherList: WeatherData.weatherForTomorrow,
              weatherEnum: TabText.TOMORROW,
            )
          else
            WeatherListView(
              weatherList: WeatherData.weatherForWeek,
              weatherEnum: TabText.WEEK,
            ),
        ],
      ),
    );
  }

  Widget _currentTime() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: '${currentTime()}\n',
          style: TextStyle(
              fontSize: 40.0,
               color: Colors.white,
              fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(
              text:
                  '             ${DateFormat('EEE, d MMM').format(DateTime.now())}',
              style: TextStyle(
                  height: 1.5,
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> tabWidgets() {
    List<Widget> listOfWidgets = [];

    for (int i = 0; i < _dayType.length; i++) {
      Widget widget;
      widget = GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = TabText.values[i];
            selectedItem = _dayType[i];
          });
        },
        onDoubleTap: () {
          setState(() {
            switch (selectedTab) {
              case TabText.TODAY:
                if (WeatherData.weatherForToday.isNotEmpty) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FullDetailsWeatherPage(WeatherDetails(
                        weatherMoment: 'TODAY',
                        weatherTime: WeatherData.listOfTodayTime,
                        weatherIcon: WeatherData.listOfWeatherIcon,
                        weatherHumidity: WeatherData.listOfWeatherHumidity,
                        weatherTemp: WeatherData.listOfWeatherTemp,
                    
                        weatherDetailsLength:
                            WeatherData.weatherForToday.length));
                  }));
                }
                break;
              case TabText.TOMORROW:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FullDetailsWeatherPage(
                            WeatherDetails(
                                weatherMoment: 'TOMORROW',
                                weatherTime: WeatherData.listOfTomorrowTime,
                                weatherIcon: WeatherData.listOfWeatherIcon,
                                weatherHumidity:
                                    WeatherData.listOfWeatherHumidity,
                                weatherTemp: WeatherData.listOfWeatherTemp,
                            
                                weatherDetailsLength:
                                    WeatherData.weatherForTomorrow.length))));
                break;
              case TabText.WEEK:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FullDetailsWeatherPage(
                            WeatherDetails(
                                weatherMoment: 'WEEK',
                                weatherTime: WeatherData.mDayOfTheWeekList,
                                weatherIcon: WeatherData.listOfWeatherIcon,
                                weatherHumidity:
                                    WeatherData.listOfWeatherHumidity,
                                weatherTemp: WeatherData.listOfWeatherTemp,
                               
                                weatherDetailsLength:
                                    WeatherData.weatherForWeek.length))));
                break;
            }
          });
        },
        child: Container(
          height: height * 0.3,
          width: width * 0.3,
          decoration: selectedTab == TabText.values[i]
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(height * 0.3),
                  color: Color(0XFFEBF2FF))
              : null,
          child: Center(
            child: Text(
              _dayType[i],
              style: TextStyle(
                color: Color(0xff586171),
                fontSize: 18.0,
                fontWeight: selectedItem == _dayType[i]
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
      listOfWidgets.add(widget);
    }
    return listOfWidgets;
  }

  Widget generateTab() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: height * 0.06,
        width: width * 0.9,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10.0,
                  spreadRadius: 5.3),
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10.0,
                  spreadRadius: 5.3)
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(height * 0.03),
                bottomLeft: Radius.circular(height * 0.03))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: tabWidgets(),
        ),
      ),
    );
  }
}
