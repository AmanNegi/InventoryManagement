import 'dart:convert';

class User {
  String id;
  String email;
  String phone;
  String name;
  String userType;

  User(
      {required this.id,
      required this.email,
      required this.phone,
      required this.name,
      required this.userType});

  User copyWith({
    String? id,
    String? email,
    String? phone,
    String? name,
    String? userType,
  }) {
    return User(
        id: id ?? this.id,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        name: name ?? this.name,
        userType: userType ?? this.userType);
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'userType': userType
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      name: map['name'] ?? '',
      userType: map['userType'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(_id: $id, email: $email, phone: $phone, name: $name, userType: $userType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.email == email &&
        other.phone == phone &&
        other.name == name &&
        other.userType == userType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        name.hashCode ^
        userType.hashCode;
  }
}
