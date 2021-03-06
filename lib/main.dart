import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/weather_data.dart';

import 'WeatherHomePage.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

SharedPreferences localStorage;

class _WeatherAppState extends State<WeatherApp> {
  getSharedPreference() async {
    localStorage = await SharedPreferences.getInstance();
  }

  var subscription = Connectivity().onConnectivityChanged;

  Widget homeWidget;
  bool signedIn = false;

  signed() async {
    if (await FirebaseAuth.instance.currentUser() != null) {
      signedIn = true;
    } else {
      signedIn = false;
    }
  }

  @override
  void initState() {
    super.initState();
    getSharedPreference();
    signed();
  }

  @override
  void dispose() {
    super.dispose();
    subscription.listen((event) {}).cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff21335C),
      ),
      home: Scaffold(
        body: StreamBuilder<ConnectivityResult>(
            stream: subscription,
            builder: (context, snapshot) {
              if (snapshot.data == ConnectivityResult.mobile ||
                  snapshot.data == ConnectivityResult.wifi) {
                homeWidget = SignInScreen();
              } else {
                homeWidget = Scaffold(
                  backgroundColor: Colors.teal,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Lottie.asset('assets/no-internet-connection.json',
                            height: MediaQuery.of(context).size.height * 0.3),
                        Text(
                          'Please switch on your Internet Connection for a better experience.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return homeWidget;
            }),
      ),
    );
  }
}

void getUsersLocation(BuildContext context) async {
  var location = Location();
  bool locationEnabled = await location.serviceEnabled();

  if (!locationEnabled) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        'ENABLE YOUR LOCATION FOR A BETTER EXPERIENCE',
        style: TextStyle(color: Colors.white),
      ),
    ));
  }
  WeatherData weatherData = WeatherData();
  await weatherData.getUserAddressAndLocationData();
  await weatherData.getWeatherForecast();

  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => WeatherHomePage()));
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //To get the users location, country and locality as soon they come to the app before going to the weather page.
    getUsersLocation(context);

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Loading',
                style: TextStyle(fontSize: 30.0, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: SizedBox(
              height: 50.0,
              child: RaisedButton(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/google_icon.png'),
                    SizedBox(width: 10.0),
                    Text(
                      'Login with Google',
                      style:
                          TextStyle(fontSize: 16.0, color: Color(0XFFB5B5B5)),
                    ),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    _showSpinner = true;
                  });
                  _signInWithGoogle().whenComplete(() async {
                    setState(() {
                      _showSpinner = false;
                    });
                    localStorage.setString('fName', firstNameFromGoogle);
                    print(localStorage.getString('fName'));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeWidget()),
                    );
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String emailFromGoogle = '';
String firstNameFromGoogle = '';
String lastNameFromGoogle = '';
String idTokenFromGoogle = '';

Future _signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    assert(user.email != null);
    assert(user.displayName != null);

    List<String> displayName = user.displayName.split(' ');
    emailFromGoogle = user.email;
    firstNameFromGoogle = displayName[0];
    lastNameFromGoogle = displayName[1];
    idTokenFromGoogle = googleSignInAuthentication.idToken;
    print("good");
    print(firstNameFromGoogle);

    return 'signInWithGoogle succeeded: $user';
  } else {
    print("ogl");
  }
}

Future signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}
