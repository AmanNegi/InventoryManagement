// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inv_mgmt_client/data/cache/app_cache.dart';
import 'package:inv_mgmt_client/models/user.dart';

final authProvider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider());

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
    _authState = AppState(isLoggedIn: true, user: user);
    appCache.updateAppCache(_authState);
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
  final User? user;

  const AppState({
    this.isLoggedIn = false,
    required this.user,
  });

  factory AppState.initial() {
    return const AppState(
      user: null,
      isLoggedIn: false,
    );
  }

  AppState copyWith({
    bool? isLoggedIn,
    User? user,
  }) {
    return AppState(
        isLoggedIn: isLoggedIn ?? this.isLoggedIn, user: user ?? this.user);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isLoggedIn': isLoggedIn,
      'user': user?.toMap(),
    };
  }

  factory AppState.fromMap(Map<String, dynamic> map) {
    return AppState(
      isLoggedIn: map['isLoggedIn'] as bool,
      user: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppState.fromJson(String source) =>
      AppState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AppState(isLoggedIn: $isLoggedIn, user: $user)';

  @override
  bool operator ==(covariant AppState other) {
    if (identical(this, other)) return true;

    return other.isLoggedIn == isLoggedIn && other.user == user;
  }

  @override
  int get hashCode => isLoggedIn.hashCode ^ user.hashCode;
}
