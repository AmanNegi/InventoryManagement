// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inv_mgmt_client/data/cache/app_cache.dart';
import 'package:inv_mgmt_client/models/user.dart';

final authProvider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider());

// TODO: Redundant code. Remove this.
class AuthProvider extends ChangeNotifier {
  AppState _authState = AppState.initial();

  User? getCurrentUser() => _authState.user;
  bool isLoggedIn() => _authState.isLoggedIn;

  bool isAdmin() {
    return _authState.user == null
        ? false
        : _authState.user!.userType == "admin";
  }

  updateUserData(User user) {
    appCache.updateAppCache(new AppState(
      isLoggedIn: true,
      user: user,
    ));
    notifyListeners();
  }

  clearUserData() {
    appCache.clearAppCache();
    notifyListeners();
  }
}

/*  
@AppState: Stores App State and Credentials.
**/
class AppState {
  final bool isLoggedIn;
  final bool isDarkMode;
  final User? user;

  const AppState({
    this.isLoggedIn = false,
    this.isDarkMode = true,
    required this.user,
  });

  factory AppState.initial() {
    return const AppState(
      user: null,
      isLoggedIn: false,
      isDarkMode: true,
    );
  }

  AppState copyWith({
    bool? isLoggedIn,
    bool? isDarkMode,
    ValueGetter<User?>? user,
  }) {
    return AppState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      user: user != null ? user() : this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isLoggedIn': isLoggedIn,
      'isDarkMode': isDarkMode,
      'user': user?.toMap(),
    };
  }

  factory AppState.fromMap(Map<String, dynamic> map) {
    return AppState(
      isLoggedIn: map['isLoggedIn'] ?? false,
      isDarkMode: map['isDarkMode'] ?? true,
      user: map['user'] != null ? User.fromMap(map['user']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppState.fromJson(String source) =>
      AppState.fromMap(json.decode(source));

  @override
  String toString() =>
      'AppState(isLoggedIn: $isLoggedIn, isDarkMode: $isDarkMode, user: $user)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppState &&
        other.isLoggedIn == isLoggedIn &&
        other.isDarkMode == isDarkMode &&
        other.user == user;
  }

  @override
  int get hashCode => isLoggedIn.hashCode ^ isDarkMode.hashCode ^ user.hashCode;
}
