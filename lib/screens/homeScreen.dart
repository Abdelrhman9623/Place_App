import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:placeApp/helper/htt_ex.dart';
import 'package:placeApp/screens/addLocation.dart';
import 'package:placeApp/screens/auth/loginScreen.dart';
import 'package:placeApp/services/auth.dart';
import 'package:placeApp/services/users.dart';
import 'package:placeApp/widgets/officeItem.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isLoading = false;
  String empolyeeName = '';
  String _locationName = '';
  String _date = '';
  String _time = '';
  String _locationId;
  Location _location = Location();

  _showErrorMessage(String message) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                message.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
            ));
  }

  _submitCheckIn() async {
    var currentLocation = await _location.getLocation();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<UserHandler>(context, listen: false).checkIn();
    } on HttpException catch (e) {
      if (e.message != null) {
        var data = Provider.of<UserHandler>(context, listen: false);
        var user =
            Provider.of<Auth>(context, listen: false).findById(data.userId);
        var locatioData = Provider.of<UserHandler>(context, listen: false)
            .findById(e.message);
        var checker = Provider.of<UserHandler>(context, listen: false)
            .calculateDistance(
                currentLocation.latitude,
                currentLocation.longitude,
                locatioData.latitude,
                locatioData.longitude);
        if (locatioData.radius > checker) {
          setState(() {
            empolyeeName = user.name;
            _isLoading = false;
            _locationId = locatioData.id;
            _locationName = locatioData.locationName;
            _date = DateFormat('yy-MM-dd').format(DateTime.now());
            _time = DateFormat.jm().format(DateTime.now());
          });
          _showErrorMessage('You have been arraived');
        } else {
          setState(() {
            empolyeeName = '';
            _isLoading = false;
            _locationId = null;
            _locationName = '';
            _date = '';
            _time = '';
          });
          _showErrorMessage('you are out of range');
        }
      } else {
        setState(() {
          _isLoading = false;
          _locationName = '';
          _date = '';
          _time = '';
        });
        _showErrorMessage('you are out of range');
      }
    } catch (error) {
      throw error;
    }
  }

// FUN FOR CHECKOUT
  _submitCheckOut() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<UserHandler>(context, listen: false)
          .checkOut(_locationId);
    } on HttpException catch (messege) {
      var locatioData = Provider.of<UserHandler>(context, listen: false)
          .findById(_locationId);
      var checkOutRange = locatioData.radius;
      var userRange = double.parse(messege.message);
      if (userRange > checkOutRange) {
        setState(() {
          empolyeeName = '';
          _isLoading = false;
          _locationName = '';
          _date = '';
          _time = '';
          _locationId = null;
        });
        _showErrorMessage('You are left the building');
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorMessage('you are still inside in the building');
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = ModalRoute.of(context).settings.arguments as int;
    final items = Provider.of<UserHandler>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (route) => false),
          ),
          centerTitle: true,
          title: Text('Welcome'),
          actions: [
            type == 1
                ? IconButton(
                    icon: Icon(Icons.plus_one),
                    onPressed: () {
                      Navigator.of(context).pushNamed(AddNewLocation.routeName);
                    })
                : Container()
          ],
        ),
        body: type == 1
            ? Column(
                children: [
                  Expanded(
                      child: FutureBuilder(
                          future: items.fatchManagerData(),
                          builder: (context, snapshot) => ListView.builder(
                              itemCount: items.locations.length,
                              itemBuilder: (context, i) =>
                                  ChangeNotifierProvider.value(
                                    value: items.locations[i],
                                    child: OfficeItem(),
                                  )))),
                ],
              )
            : Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('$_locationName'),
                            SizedBox(
                              height: 15,
                            ),
                            Text('$empolyeeName'),
                            SizedBox(
                              height: 15,
                            ),
                            Text('$_date'),
                            SizedBox(
                              height: 15,
                            ),
                            Text('$_time')
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Center(
                              // ignore: deprecated_member_use
                              child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.green,
                            child: Text('CheckIn'),
                            onPressed:
                                _locationId != null ? null : _submitCheckIn,
                          )),
                          Center(
                              // ignore: deprecated_member_use
                              child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.red,
                            child: Text('CheckOut'),
                            onPressed:
                                _locationId == null ? null : _submitCheckOut,
                          )),
                        ],
                      ),
                    ],
                  ),
                  Positioned.fill(
                      child: _isLoading
                          ? Container(
                              color: Colors.black87.withOpacity(0.5),
                              child: Center(child: CircularProgressIndicator()))
                          : Container())
                ],
              ));
  }
}
