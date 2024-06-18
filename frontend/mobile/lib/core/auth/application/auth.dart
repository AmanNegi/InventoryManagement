import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inv_mgmt_client/data/auth_state.dart';
import 'package:inv_mgmt_client/globals.dart';
import 'package:http/http.dart' as http;
import 'package:inv_mgmt_client/models/user.dart';

class AuthManager {
  final BuildContext context;
  final WidgetRef ref;
  AuthManager(this.context, this.ref);

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<int> loginUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    ref.read(authProvider).clearUserData();
    isLoading.value = true;
    try {
      var response = await http.post(
        Uri.parse("$API_URL/auth/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );
      isLoading.value = false;

      if (response.statusCode == 200) {
        var loggedInUser = User.fromMap(json.decode(response.body));
        ref.read(authProvider).updateUserData(loggedInUser);
        showToast("Logged in as: ${loggedInUser.name}");
        return 1;
      } else {
        showToast(response.body);
        return -1;
      }
    } catch (error) {
      isLoading.value = false;
      showToast(error.toString());
      debugPrint(error.toString());
      return -1;
    }
  }
}
