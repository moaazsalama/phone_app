import 'dart:convert';

import 'package:phone_lap/models/analysis.dart';
import 'package:phone_lap/models/analyzer.dart';

class PCR {
  final String id;
  final String passportImageUrl;
  final Analyzer analyzer;
  final Analysis analysis;
  final String travlingCountry;
  final String flightLine;
  PCR({
    required this.id,
    required this.passportImageUrl,
    required this.analyzer,
    required this.analysis,
    required this.travlingCountry,
    required this.flightLine,
  });

  PCR copyWith({
    String? id,
    String? passportImageUrl,
    Analyzer? analyzer,
    Analysis? analysis,
    String? travlingCountry,
    String? flightLine,
  }) {
    return PCR(
      id: id ?? this.id,
      passportImageUrl: passportImageUrl ?? this.passportImageUrl,
      analyzer: analyzer ?? this.analyzer,
      analysis: analysis ?? this.analysis,
      travlingCountry: travlingCountry ?? this.travlingCountry,
      flightLine: flightLine ?? this.flightLine,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'passportImageUrl': passportImageUrl,
      'analyzer': analyzer.toMap(),
      'analysis': analysis.toMap(),
      'travlingCountry': travlingCountry,
      'flightLine': flightLine,
    };
  }

  factory PCR.fromMap(Map<String, dynamic> map) {
    return PCR(
      id: map['id'],
      passportImageUrl: map['passportImageUrl'],
      analyzer: Analyzer.fromMap(map['analyzer']),
      analysis: Analysis.fromMap(map['analysis']),
      travlingCountry: map['travlingCountry'],
      flightLine: map['flightLine'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PCR.fromJson(String source) => PCR.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PCR(id: $id, passportImageUrl: $passportImageUrl, analyzer: $analyzer, analysis: $analysis, travlingCountry: $travlingCountry, flightLine: $flightLine)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PCR &&
        other.id == id &&
        other.passportImageUrl == passportImageUrl &&
        other.analyzer == analyzer &&
        other.analysis == analysis &&
        other.travlingCountry == travlingCountry &&
        other.flightLine == flightLine;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        passportImageUrl.hashCode ^
        analyzer.hashCode ^
        analysis.hashCode ^
        travlingCountry.hashCode ^
        flightLine.hashCode;
  }
}
