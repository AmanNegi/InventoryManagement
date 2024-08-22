import 'package:flutter/material.dart';
import 'package:inv_mgmt_client/data/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<AppState> appState = ValueNotifier(AppState.initial());

class AppCache {
  final String _prefsKey = "inv_mgmt_client";

  getDataFromDevice() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? data = sharedPreferences.getString(_prefsKey);
    if (data == null) return;
    appState.value = (AppState.fromJson(data));
    debugPrint("Data From Device: $data");
  }

  saveDataToDevice() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_prefsKey, appState.value.toJson());
    debugPrint("Saved Data to Device..." + appState.value.toJson());
  }

  updateAppCache(AppState state) {
    appState.value = (AppState.fromMap(state.toMap()));
    saveDataToDevice();
  }

  clearAppCache() {
    appState.value = new AppState(
      user: null,
      isLoggedIn: false,
    );
    saveDataToDevice();
  }

  String getUserName() {
    if (appState.value.user == null) {
      return "NA";
    }
    return appState.value.user!.name;
  }

  String getEmail() {
    if (appState.value.user == null) {
      return "NA";
    }
    return appState.value.user!.email;
  }

  bool isAdmin() {
    return appState.value.user == null
        ? false
        : appState.value.user!.userType == "admin";
  }

  bool isCustomer() {
    return appState.value.user == null
        ? true
        : appState.value.user!.userType == "customer";
  }

  bool isLoggedIn() {
    if (appState.value.user == null || appState.value.user!.id == "") {
      return false;
    }

    return appState.value.isLoggedIn;
  }

  bool isOwnerOf(String id) {
    return appState.value.user!.id == id;
  }
}

AppCache appCache = AppCache();
