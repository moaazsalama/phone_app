import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phone_lap/models/analysis.dart';
import 'package:phone_lap/models/analyzer.dart';

import 'google_sheets_Api.dart';

class Orders with ChangeNotifier {
  String? userId;
  CollectionReference<Map<String, dynamic>>? requests;
  void getData(
    String userId,
  ) {
    requests = FirebaseFirestore.instance.collection('Orders');
    this.userId = userId;
    notifyListeners();
  }

  Future<void> sendOrder(OrderItem orderItem, String sheet) async {
    final map = orderItem.toMap();
    map.remove('id');
    final id = await FirebaseFirestore.instance.collection('Orders').add(map);
    map.addAll({'id': id.id});

    FirebaseFirestore.instance
        .collection('Orders')
        .doc(id.id)
        .update({'id': id.id});
    if (sheet.contains('pcrTravel')) {
      await UserSheetApi.insertPcrTravel({
        'analysisName': orderItem.analysis.name,
        'price': orderItem.analysis.price,

        'analysisType': orderItem.analysis.analysisType.toString(),
        'analyzerId': orderItem.user.analyzerId,
        'analayzerName': orderItem.user.name,
        'analayzerPhone': orderItem.user.phone,
        'analayzerAddress': orderItem.user.address,
        'analayzerDate': orderItem.user.date,
        'analayzerEmail': orderItem.user.email,
        'analayzerGender': orderItem.user.gender,
        'Orderid': id.id,
        'dateTime': orderItem.dateTime.toString(),
        'passportImageUrl': orderItem.passportImageUrl,
        'travlingCountry': orderItem.travlingCountry,
        'flightLine': orderItem.flightLine,
      });
    } else if (sheet.contains('pcrNormal')) {
      await UserSheetApi.insertPcrNormal({
        'analysisName': orderItem.analysis.name,
        'price': orderItem.analysis.price,
        'analyzerId': orderItem.user.analyzerId,
        'analayzerName': orderItem.user.name,
        'analayzerPhone': orderItem.user.phone,
        'analayzerAddress': orderItem.user.address,
        'analayzerDate': orderItem.user.date,
        'analayzerEmail': orderItem.user.email,
        'analayzerGender': orderItem.user.gender,
        'Orderid': id.id,
        'dateTime': orderItem.dateTime.toString(),
      });
    } else if (sheet.contains('blood')) {
      print(5);
      await UserSheetApi.insertBloodAnalysis({
        'analysisName': orderItem.analysis.name,
        'price': orderItem.analysis.price,
        'analyzerId': orderItem.user.analyzerId,
        'analayzerName': orderItem.user.name,
        'analayzerPhone': orderItem.user.phone,
        'analayzerAddress': orderItem.user.address,
        'analayzerDate': orderItem.user.date,
        'analayzerEmail': orderItem.user.email,
        'analayzerGender': orderItem.user.gender,
        'Orderid': id.id,
        'dateTime': orderItem.dateTime.toString(),
      });
    } else {
      await UserSheetApi.insertNecessaryAnalysis({
        'analysisName': orderItem.analysis.name,
        'price': orderItem.analysis.price,
        'analyzerId': orderItem.user.analyzerId,
        'analayzerName': orderItem.user.name,
        'analayzerPhone': orderItem.user.phone,
        'analayzerAddress': orderItem.user.address,
        'analayzerDate': orderItem.user.date,
        'analayzerEmail': orderItem.user.email,
        'analayzerGender': orderItem.user.gender,
        'Orderid': id.id,
        'dateTime': orderItem.dateTime.toString(),
      });
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllOrders() {
    try {
      return requests!.orderBy('dateTime', descending: true).snapshots();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}

class OrderItem {
  final Analysis analysis;
  final Analyzer user;
  final String? id;
  final String isDeliverd;
  final DateTime dateTime;
  final String? passportImageUrl;
  final String? travlingCountry;
  final String? flightLine;
  final String? resultUrl;
  OrderItem({
    required this.isDeliverd,
    this.resultUrl,
    required this.analysis,
    required this.user,
    required this.id,
    required this.dateTime,
    this.passportImageUrl,
    this.travlingCountry,
    this.flightLine,
  });

  OrderItem copyWith({
    String? isDeliverd,
    Analysis? analysis,
    Analyzer? user,
    String? id,
    DateTime? dateTime,
    String? passportImageUrl,
    String? travlingCountry,
    String? flightLine,
    String? resultUrl,
  }) {
    return OrderItem(
      analysis: analysis ?? this.analysis,
      resultUrl: resultUrl ?? this.resultUrl,
      user: user ?? this.user,
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      passportImageUrl: passportImageUrl ?? this.passportImageUrl,
      travlingCountry: travlingCountry ?? this.travlingCountry,
      flightLine: flightLine ?? this.flightLine,
      isDeliverd: isDeliverd ?? this.isDeliverd,
    );
  }

  Future<void> deliver(String resultUrl) async {
    print(id! + "HHHHHHHHHHHH");
    await FirebaseFirestore.instance.collection('Orders').doc(id).update(
      {'isDeliverd': 'yes', 'resultUrl': resultUrl},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'analysis': analysis.toMap(),
      'user': user.toMap(),
      'id': id,
      'dateTime': dateTime.toString(),
      'passportImageUrl': passportImageUrl,
      'travlingCountry': travlingCountry,
      'flightLine': flightLine,
      'resultUrl': resultUrl,
      'isDeliverd': isDeliverd
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      analysis: Analysis.fromMap(map['analysis']),
      user: Analyzer.fromMap(map['user']),
      id: map['id'],
      dateTime: DateTime.parse(map['dateTime']),
      passportImageUrl: map['passportImageUrl'],
      travlingCountry: map['travlingCountry'],
      flightLine: map['flightLine'],
      isDeliverd: map['isDeliverd'],
      resultUrl: map['resultUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderItem(analysis: $analysis, user: $user, id: $id, dateTime: $dateTime, passportImageUrl: $passportImageUrl, travlingCountry: $travlingCountry, flightLine: $flightLine, isDeliverd: $isDeliverd, resultUrl: $resultUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderItem &&
        other.analysis == analysis &&
        other.user == user &&
        other.id == id &&
        other.dateTime == dateTime &&
        other.passportImageUrl == passportImageUrl &&
        other.travlingCountry == travlingCountry &&
        other.flightLine == flightLine &&
        other.resultUrl == resultUrl &&
        other.isDeliverd == isDeliverd;
  }

  @override
  int get hashCode {
    return analysis.hashCode ^
        user.hashCode ^
        id.hashCode ^
        dateTime.hashCode ^
        passportImageUrl.hashCode ^
        travlingCountry.hashCode ^
        flightLine.hashCode ^
        resultUrl.hashCode ^
        isDeliverd.hashCode;
  }

  static List<String> get values => [
        'analysisName',
        'price',
        'isNecessary',
        'analysisType',
        'analyzerId',
        'analayzerName',
        'analayzerPhone',
        'analayzerAddress',
        'analayzerDate',
        'analayzerEmail',
        'analayzerGender',
        'Orderid',
        'dateTime',
        'passportImageUrl',
        'travlingCountry',
        'flightLine',
        'isDeliverd',
        'resultUrl'
      ];
}
