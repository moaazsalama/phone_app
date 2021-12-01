import 'dart:convert';

class AnalysisType {
  final String anaysisType;
  final bool isNeccessary;
  final String key;
  AnalysisType({
    required this.anaysisType,
    required this.isNeccessary,
    required this.key,
  });

  AnalysisType copyWith({
    String? anaysisType,
    bool? isNeccessary,
    String? key,
  }) {
    return AnalysisType(
      anaysisType: anaysisType ?? this.anaysisType,
      isNeccessary: isNeccessary ?? this.isNeccessary,
      key: key ?? this.key,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'anaysisType': anaysisType,
      'isNeccessary': isNeccessary,
      'key': key,
    };
  }

  factory AnalysisType.fromMap(Map<String, String> map) {
    print('${map['isNeccessary']} from map ');
    return AnalysisType(
      anaysisType: map['anaysisType']!,
      // ignore: avoid_bool_literals_in_conditional_expressions
      isNeccessary: map['isNeccessary']!.contains('false') ? false : true,
      key: map['key']!,
    );
  }

  String toJson() => json.encode(toMap());

  factory AnalysisType.fromJson(String source) =>
      AnalysisType.fromMap(json.decode(source));

  @override
  String toString() =>
      'AnalysisType(anaysisType: $anaysisType, isNeccessary: $isNeccessary, key: $key)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnalysisType &&
        other.anaysisType == anaysisType &&
        other.isNeccessary == isNeccessary &&
        other.key == key;
  }

  @override
  int get hashCode =>
      anaysisType.hashCode ^ isNeccessary.hashCode ^ key.hashCode;
}
