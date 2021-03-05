import 'dart:async';
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:placeApp/helper/htt_ex.dart';
import 'package:placeApp/helper/url_helper.dart';
import 'package:placeApp/models/place.dart';
import 'package:http/http.dart' as http;

class UserHandler extends ChangeNotifier {
  final String userId;
  UserHandler(this.userId);
  List<Place> _items = [];
  Location _location = Location();
  String _checkInRadius;

  List<Place> get locations {
    return [..._items];
  }

// get place information
  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

// GET ALL OFFICES DATA
  Future<void> fatchManagerData() async {
    try {
      final respnse = await http.get(UrlHandler.url('managerData.json'));
      final responseData = json.decode(respnse.body) as Map<String, dynamic>;
      final List<Place> address = [];
      responseData.forEach((addressId, addressData) {
        address.add(Place(
          id: addressId,
          locationName: addressData['locactioName'],
          latitude: addressData['offeicLatitdue'],
          longitude: addressData['offeicLongitude'],
          radius: addressData['radius'],
          isCheck: false,
        ));
      });
      _items = address;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

// TO GET RADIUS BETWEEN TOW LOCATION
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

// TO MAKE USER CHECKIN
  Future<void> checkIn() async {
    try {
      await fatchManagerData();
      _location.requestPermission();
      var currentLocation = await _location.getLocation();
      for (var i = 0; i < _items.length; i++) {
        var mn = calculateDistance(
          currentLocation.latitude,
          currentLocation.longitude,
          _items[i].latitude,
          _items[i].longitude,
        );
        if (_items[i].radius > mn) {
          _checkInRadius = _items[i].id;
        }
      }
      notifyListeners();
      throw HttpException(_checkInRadius);
    } catch (e) {
      throw e;
    }
  }

// TO MAKE USER CHECKOUT
  Future<void> checkOut(String id) async {
    try {
      await fatchManagerData();
      if (id == null) {
        throw HttpException('you are not in the office');
      }
      var location = _items.firstWhere((element) => element.id == id);
      var currentLocation = await _location.getLocation();
      double currentloactionInmeaters = calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        location.latitude,
        location.longitude,
      );
      notifyListeners();
      throw HttpException('$currentloactionInmeaters');
    } catch (e) {
      throw e;
    }
  }

// adding new place for users
  Future<void> _addNewPlace([
    String locactioName,
    double offeicLatitdue,
    double offeicLongitude,
    double radius,
  ]) async {
    try {
      final respnse = await http.post(UrlHandler.url('managerData.json'),
          body: json.encode({
            'locactioName': locactioName,
            'offeicLatitdue': offeicLatitdue,
            'offeicLongitude': offeicLongitude,
            'radius': radius,
          }));
      final responseData = json.decode(respnse.body);
      final newLocation = Place(
        id: responseData['name'],
        locationName: locactioName,
        latitude: offeicLatitdue,
        longitude: offeicLongitude,
        radius: radius,
      );
      _items.add(newLocation);
      notifyListeners();
      if (responseData != null) {
        throw HttpException('200');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> setPlaceData([
    String locactioName,
    double offeicLatitdue,
    double offeicLongitude,
    double radius,
  ]) async {
    return _addNewPlace(locactioName, offeicLatitdue, offeicLongitude, radius);
  }
}
