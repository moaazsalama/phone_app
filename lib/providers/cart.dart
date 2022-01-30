import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:phone_lap/models/analysis.dart';

class CartItem {
  final String id;
  final Analysis analysis;
  final String? passportImageUrl;
  final String? travlingCountry;
  final String? flightLine;
  final String? resultUrl;

  CartItem({
    required this.id,
    required this.analysis,
    this.passportImageUrl,
    this.travlingCountry,
    this.flightLine,
    this.resultUrl,
  });

  CartItem copyWith({
    String? id,
    Analysis? analysis,
    String? passportImageUrl,
    String? travlingCountry,
    String? flightLine,
    String? resultUrl,
    double? price,
  }) {
    return CartItem(
      id: id ?? this.id,
      analysis: analysis ?? this.analysis,
      passportImageUrl: passportImageUrl ?? this.passportImageUrl,
      travlingCountry: travlingCountry ?? this.travlingCountry,
      flightLine: flightLine ?? this.flightLine,
      resultUrl: resultUrl ?? this.resultUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'analysis': analysis.toMap(),
      'passportImageUrl': passportImageUrl,
      'travlingCountry': travlingCountry,
      'flightLine': flightLine,
      'resultUrl': resultUrl,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      analysis: Analysis.fromMap(map['analysis']),
      passportImageUrl: map['passportImageUrl'],
      travlingCountry: map['travlingCountry'],
      flightLine: map['flightLine'],
      resultUrl: map['resultUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartItem(id: $id, analysis: $analysis, passportImageUrl: $passportImageUrl, travlingCountry: $travlingCountry, flightLine: $flightLine, resultUrl: $resultUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem &&
        other.id == id &&
        other.analysis == analysis &&
        other.passportImageUrl == passportImageUrl &&
        other.travlingCountry == travlingCountry &&
        other.flightLine == flightLine &&
        other.resultUrl == resultUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        analysis.hashCode ^
        passportImageUrl.hashCode ^
        travlingCountry.hashCode ^
        flightLine.hashCode ^
        resultUrl.hashCode;
  }
}

class Cart with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items {
    return _items;
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((element) {
      total += double.parse(element.analysis.price);
    });
    return total;
  }

  bool addItem(Analysis analysis,
      {String? passportImageUrl, String? travlingCountry, String? flightLine}) {
    bool contain = false;
    _items.forEach((element) {
      if (element.id == analysis.name) contain = true;
    });
    print(contain);
    if (!contain) {
      _items.add(CartItem(
          id: analysis.name,
          analysis: analysis,
          flightLine: flightLine,
          passportImageUrl: passportImageUrl,
          travlingCountry: travlingCountry));

      notifyListeners();

      return true;
    } else
      return false;
  }

  void removeItem(Analysis analysis) {
    _items.removeWhere((element) => element.id == analysis.name);
    notifyListeners();
  }

  void clear() {
    _items = [];
    notifyListeners();
  }
}
