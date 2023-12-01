
// ignore_for_file: empty_constructor_bodies

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:panda_technician/models/auth/account.dart';

class UserProvider with ChangeNotifier{

Account user = Account();

UserProvider({
  required this.user,

});


void changeUserProviderState(Account account){
  user = account;
  notifyListeners();
}


}