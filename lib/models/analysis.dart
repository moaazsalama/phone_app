import 'dart:convert';

class Analysis {
  final String name;
  final String price;
  final String analysisType;
  Analysis({
    required this.name,
    required this.price,
    required this.analysisType,
  });

  Analysis copyWith({
    String? name,
    String? price,
    bool? isNecessary,
    String? analysisType,
  }) {
    return Analysis(
      name: name ?? this.name,
      price: price ?? this.price,
      analysisType: analysisType ?? this.analysisType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'analysisName': name,
      'price': price,
      'analysisType': analysisType.toString(),
    };
  }

  factory Analysis.fromMap(Map<String, dynamic> map) {
    // ignore: avoid_bool_literals_in_conditional_expressions
    final bool isNecessary = map['isNecessary'].toString() == 'false' ||
            map['isNecessary'].toString() == 'False'
        ? false
        : true;
    return Analysis(
      name: map['analysisName'],
      price: map['price'],
      analysisType: map['analysisType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Analysis.fromJson(String source) =>
      Analysis.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Analysis(name: $name, price: $price, analysisType: $analysisType)';
  }

  static List values() =>
      ['analysisName', 'price', 'analysisType'];
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Analysis &&
        other.name == name &&
        other.price == price &&

        other.analysisType == analysisType;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        price.hashCode ^

        analysisType.hashCode;
  }
}
