import 'package:flutter/material.dart';
import 'package:placeApp/models/place.dart';
import 'package:provider/provider.dart';

class OfficeItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Place>(context);
    return Container(
      height: 100,
      child: Card(
        color: items.isCheck ? Colors.amber.withOpacity(0.5) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(items.locationName),
                      Text('Latitude: ${items.latitude.toStringAsFixed(5)}'),
                      Text('Longitude: ${items.longitude.toStringAsFixed(5)}'),
                    ],
                  ),
                  Text('Range: ${items.radius} M'),
                ],
              ),

              // Text(items.items[i].locationName),
            ],
          ),
        ),
      ),
    );
  }
}
