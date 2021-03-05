import 'package:flutter/material.dart';
import 'package:placeApp/helper/htt_ex.dart';
import 'package:placeApp/services/users.dart';
import 'package:provider/provider.dart';

class AddNewLocation extends StatefulWidget {
  static const routeName = '/location-screen';
  AddNewLocation({Key key}) : super(key: key);

  @override
  _AddNewLocationState createState() => _AddNewLocationState();
}

class _AddNewLocationState extends State<AddNewLocation> {
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _managerPanal = {
    'locationName': '',
    "lat": '',
    "long": '',
    'range': ''
  };

  _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    try {
      await Provider.of<UserHandler>(context, listen: false).setPlaceData(
          _managerPanal['locationName'],
          double.parse(_managerPanal['lat']),
          double.parse(_managerPanal['long']),
          double.parse(_managerPanal['range']));
    } on HttpException catch (massege) {
      if (massege.message == '200') {
        Navigator.of(context).pop();
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,
      backgroundColor: Color(0xfff6f9fc),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: FittedBox(
                        child: Text(
                          'Manager Panal',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      child: FittedBox(
                        child: Text(
                          'Add new location',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusColor: Color(0xfffea13b),
                      filled: true,
                      hintText: 'location name'),
                  // ignore: missing_return
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Location name is REQUIRD';
                    }
                  },
                  onSaved: (val) {
                    _managerPanal['locationName'] = val.trim();
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusColor: Color(0xfffea13b),
                      filled: true,
                      hintText: 'location latitude'),
                  // ignore: missing_return
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Location latitude is REQUIRD';
                    }
                  },
                  onSaved: (val) {
                    _managerPanal['lat'] = val.trim();
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusColor: Color(0xfffea13b),
                      filled: true,
                      hintText: 'location longitude'),
                  // ignore: missing_return
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Location longitude is REQUIRD';
                    }
                  },
                  onSaved: (val) {
                    _managerPanal['long'] = val.trim();
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusColor: Color(0xfffea13b),
                      filled: true,
                      hintText: 'range'),
                  // ignore: missing_return
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Location latitude is REQUIRD';
                    }
                  },
                  onSaved: (val) {
                    _managerPanal['range'] = val.trim();
                  },
                ),
              ),
              Container(
                width: 100,
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(vertical: 30, horizontal: 100),
                child: TextButton(
                  style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      primary: Colors.white,
                      backgroundColor: Colors.amber),
                  child: Text('Submit'.toUpperCase()),
                  onPressed: _submit,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
