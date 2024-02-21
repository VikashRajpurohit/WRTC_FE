import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _user = "";

  String get user => _user;

  void setUser(String user) {
    print("Set data"+user.toString());
    _user = user;
    notifyListeners();
  }

  void setUserFromModel(String user) {
    _user = user;
    notifyListeners();
  }
}
