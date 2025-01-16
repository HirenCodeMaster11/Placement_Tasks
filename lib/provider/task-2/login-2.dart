import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:placement_tasks/Helper/task-2/api_helper.dart';
import 'package:placement_tasks/modal/task-2/authModal-2.dart';
import 'package:placement_tasks/modal/task-2/userModal-2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier
{
  final ApiHelper helper = ApiHelper();

  UserModal? userModal;
  AuthModal? authModal;

  List<User> userList = [];
  bool userStatus = false;
  SharedPreferences? sharedPreferences;
  List<String> sharedList = [];

  Future<UserModal?> fetchApiData()
  async {
    try {
      final data = await helper.fetchData();
      userModal = UserModal.fromJson(data);
      return userModal;
    } catch (e) {
      throw Exception("Error fetching user data: $e");
    }
  }

  Future<void> fetchDataFromApi(String username, String password) async {
    try {
      final data = await helper.fetchAuthServiceApi(
        username: username,
        password: password,
      );
      authModal = AuthModal.fromJson(data);

      final user = userModal?.users.firstWhere(
            (u) => u.username == username && u.password == password,
        orElse: () => throw Exception("User not found!"),
      );

      if (user != null) {
        userList.add(user);
        userStatus = true;

        // Save user data to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setString('userData', jsonEncode(user.toJson()));

        notifyListeners();
      }
    } catch (e) {
      throw Exception("Error logging in: $e");
    }
  }

  Future<void> addUserInPreferences(List<User> userList) async {
    sharedPreferences = await SharedPreferences.getInstance();
    for (int i = 0; i < userList.length; i++) {
      sharedList.add(
          "${userList[i].id}-${userList[i].firstName}-${userList[i].lastName}-${userList[i].image}");
    }
    sharedPreferences!.setStringList("users", sharedList);
  }

  Future<void> getUsersPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences!.getStringList("users");
  }

  void logout() {
    userStatus = false;
    notifyListeners();
  }

  UserProvider() {
    fetchApiData();
  }
}