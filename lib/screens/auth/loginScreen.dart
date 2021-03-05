import 'package:flutter/material.dart';
import 'package:placeApp/screens/homeScreen.dart';
import 'package:placeApp/services/auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {'email': '', 'password': ''};

  _onEmailValidator(String val) {
    if (val.isEmpty) {
      return 'Requird';
    } else if (!val.contains('@')) {
      return 'this is not valid Email';
    }
  }

  _onPassValidator(String val) {
    if (val.isEmpty) {
      return 'Requird';
    }
    if (val.length < 8) {
      return 'your password not correct';
    }
  }

  _showErrorMessage(String message) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                message.toUpperCase(),
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
            ));
  }

  _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    try {
      var user = Provider.of<Auth>(context, listen: false)
          .findByEmail(_authData['email']);
      if (user.password != _authData['password']) {
        _showErrorMessage('your password incorrect');
      } else {
        Navigator.of(context)
            .pushReplacementNamed(HomeScreen.routeName, arguments: user.type);
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(25),
          children: [
            Container(
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 75),
                    child: Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'E-mail',
                          filled: true,
                          fillColor: Colors.white),
                      // ignore: missing_return
                      validator: (val) => _onEmailValidator(val),
                      onSaved: (val) {
                        _authData['email'] = val.trim();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'password',
                          filled: true,
                          fillColor: Colors.white),
                      // ignore: missing_return
                      validator: (val) => _onPassValidator(val),
                      onSaved: (val) {
                        _authData['password'] = val.trim();
                      },
                    ),
                  ),
                ],
              ),
            ),
            TextButton(onPressed: _submit, child: Text('submit'))
          ],
        ),
      ),
    );
  }
}
