import 'dart:convert';

import 'package:phone_lap/models/analysis.dart';

class Analyzer {
  final String analyzerId;
  final String name;
  final String phone;
  final String address;
  final String date;
  final String email;
  final bool gender;
  List<Analysis> lastAnalYsis = [];
  Analyzer({
    required this.analyzerId,
    required this.name,
    required this.phone,
    required this.address,
    required this.date,
    required this.email,
    required this.gender,
  });

  Analyzer copyWith(
      {String? analyzerId,
      String? name,
      String? phone,
      String? address,
      String? date,
      String? email,
      bool? gender}) {
    return Analyzer(
      analyzerId: analyzerId ?? this.analyzerId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      date: date ?? this.date,
      email: email ?? this.email,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'analyzerId': analyzerId,
      'analayzerName': name,
      'analayzerPhone': phone,
      'analayzerAddress': address,
      'analayzerDate': date,
      'analayzerEmail': email,
      'analayzerGender': gender
    };
  }

  static List<String> values() => [
        'analayzerName',
        'analayzerPhone',
        'analayzerAddress',
        'analayzerDate',
        'analayzerEmail',
        'analayzerGender'
      ];
  factory Analyzer.fromMap(Map<String, dynamic> map) {
    return Analyzer(
        analyzerId: map['analyzerId'],
        name: map['analayzerName'],
        phone: map['analayzerPhone'],
        address: map['analayzerAddress'],
        date: map['analayzerDate'],
        email: map['analayzerEmail'],
        gender: map['analayzerGender']);
  }

  String toJson() => json.encode(toMap());

  factory Analyzer.fromJson(String source) =>
      Analyzer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Analyzer(analyzerId: $analyzerId, name: $name, phone: $phone, address: $address, date: $date, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Analyzer &&
        other.analyzerId == analyzerId &&
        other.name == name &&
        other.phone == phone &&
        other.address == address &&
        other.date == date &&
        other.email == email;
  }

  @override
  int get hashCode {
    return analyzerId.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        date.hashCode ^
        email.hashCode;
  }
}
