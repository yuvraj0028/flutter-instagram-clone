import 'package:flutter/material.dart';
import 'package:insta_clone/resources/auth_methods.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User get getUser => _user!;

  final AuthMethods _authMethods = AuthMethods();

  Future<void> refershUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
