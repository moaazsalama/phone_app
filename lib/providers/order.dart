// ignore_for_file: unnecessary_null_comparison, iterable_contains_unrelated_type

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:phone_lap/models/analysis.dart';

import 'package:phone_lap/models/analyzer.dart';

import 'cart.dart';

class Orders with ChangeNotifier {
  double? _servicePrice;
  String? userId;
  CollectionReference<Map<String, dynamic>>? requests;
  void getData(
    String userId,
  ) {
    requests = FirebaseFirestore.instance.collection('Orders');
    this.userId = userId;
    notifyListeners();
  }

  double servicePrice(String area, List<CartItem> analysis) {
    final cities = ['madenty', 'elrehab', 'eltgm3'];
    final out = ['alex', 'fayoum'];
    final bool isOut = out.contains(area);
    bool isPcr = false;
    final bool isSoFar = cities.contains(area);
    for (var item in analysis) {
      if (item.analysis.analysisType.contains('pcr') ||
          item.analysis.analysisType.contains('Pcr') ||
          item.analysis.analysisType.contains('PCR')) {
        isPcr = true;
      }
    }
    if (isSoFar) {
      if (isPcr)
        return 200;
      else
        return 100;
    } else if (isOut) {
      if (isPcr)
        return 250;
      else
        return 100;
    } else {
      if (isPcr)
        return 100;
      else
        return 50;
    }
  }

  Future<void> deliverAnalysis(
      String url, OrderItem orderItem, Analysis analysis) async {
    print('enter');
    final future =
        FirebaseFirestore.instance.collection('Orders').doc(orderItem.id!);
    final future2 = await future.get();
    print(future2.data());
    // ignore: prefer_final_locals
    List<dynamic> analysisList = future2.get('analysis');
    for (var an in analysisList) {
      if (an['id'] == analysis.name) {
        an['resultUrl'] = url;
      }
    }
    return await future.update({'analysis': analysisList});
  }

  Future<bool> sendOrder(OrderItem orderItem) async {
    DocumentReference<Map<String, dynamic>>? id;
    _servicePrice = servicePrice(orderItem.user.address, orderItem.analysis);
    try {
      orderItem =
          orderItem.copyWith(totalPrice: orderItem.totalPrice + _servicePrice!);
      final map = orderItem.toMap();
      map.remove('id');
      id = await FirebaseFirestore.instance.collection('Orders').add(map);

      FirebaseFirestore.instance
          .collection('Orders')
          .doc(id.id)
          .update({'id': id.id});

      return true;
    } on Exception {
      return false;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? fetchAllOrders() {
    try {
      return requests!.orderBy('dateTime', descending: true).snapshots();
      // ignore: empty_catches
    } catch (e) {}
  }
}

class OrderItem {
  final List<CartItem> analysis;
  final Analyzer user;
  final String? id;
  final String isDeliverd;
  final DateTime dateTime;
  final double totalPrice;
  OrderItem({
    required this.analysis,
    required this.user,
    this.id,
    required this.isDeliverd,
    required this.dateTime,
    required this.totalPrice,
  });

  static List<String> get values => [
        'analysisName',
        'price',
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

  OrderItem copyWith({
    List<CartItem>? analysis,
    Analyzer? user,
    String? id,
    String? isDeliverd,
    DateTime? dateTime,
    double? totalPrice,
  }) {
    return OrderItem(
      analysis: analysis ?? this.analysis,
      user: user ?? this.user,
      id: id ?? this.id,
      isDeliverd: isDeliverd ?? this.isDeliverd,
      dateTime: dateTime ?? this.dateTime,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'analysis': analysis.map((x) => x.toMap()).toList(),
      'user': user.toMap(),
      'id': id,
      'isDeliverd': isDeliverd,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'totalPrice': totalPrice,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      analysis:
          List<CartItem>.from(map['analysis']?.map((x) => CartItem.fromMap(x))),
      user: Analyzer.fromMap(map['user']),
      id: map['id'],
      isDeliverd: map['isDeliverd'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderItem(analysis: $analysis, user: $user, id: $id, isDeliverd: $isDeliverd, dateTime: $dateTime, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderItem &&
        listEquals(other.analysis, analysis) &&
        other.user == user &&
        other.id == id &&
        other.isDeliverd == isDeliverd &&
        other.dateTime == dateTime &&
        other.totalPrice == totalPrice;
  }

  @override
  int get hashCode {
    return analysis.hashCode ^
        user.hashCode ^
        id.hashCode ^
        isDeliverd.hashCode ^
        dateTime.hashCode ^
        totalPrice.hashCode;
  }
}
