import 'package:flutter/cupertino.dart';

class Place with ChangeNotifier {
  final String id;
  final String locationName;
  final double latitude;
  final double longitude;
  final double radius;
  bool isCheck;
  Place(
      {this.id,
      this.locationName,
      this.latitude,
      this.longitude,
      this.radius,
      this.isCheck = false});
}
