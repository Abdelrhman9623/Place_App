import 'package:flutter/cupertino.dart';
import 'package:placeApp/models/auth.dart';

class Auth extends ChangeNotifier {
  Auth(this._userId);
  List<AuthData> _authData = [
    AuthData(
        id: 'er4rcniu;r43f4i385thfe',
        name: 'Mohammed',
        email: 'admin@gmail.com',
        password: '123456789',
        type: 1),
    AuthData(
        id: 'er4rcniu;fewjfwiueg4gf78f3rj329r23oio2',
        name: 'Ahmed Mohammed',
        email: 'user@gmail.com',
        password: '123456789',
        type: 0),
  ];
  String _userId;
  String get userId {
    return _userId;
  }

  List<AuthData> get user {
    return [..._authData];
  }

  AuthData findByEmail(String email) {
    var user = _authData.firstWhere((user) => user.email == email);
    _userId = user.id;
    return user;
  }

  AuthData findById(String id) {
    var user = _authData.firstWhere((user) => user.id == id);
    return user;
  }
}
