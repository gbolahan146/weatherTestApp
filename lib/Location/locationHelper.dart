import 'package:geolocator/geolocator.dart';


class LocationHelper {


  double longitude;
  double latitude;
  String userCountry;
  String userLocality;
  List<Placemark> placemark;

  Future getUserCoordinate() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    longitude = position.longitude;
    latitude = position.latitude;

    print('getUserCoordinate: $longitude');
    print('getUserCoordinate: $latitude');

  }

  Future<void> getUserCountryAndLocality() async {
    await getUserCoordinate();

    placemark =
        await Geolocator().placemarkFromCoordinates(latitude, longitude);

    userCountry = placemark[0].country;
    userLocality = placemark[0].locality;

    print('getUserCountryLocality: $userCountry');
    print('getUserLocality: $userLocality');
  }
}
