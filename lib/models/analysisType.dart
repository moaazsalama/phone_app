import 'dart:convert';

class AnalysisType {
  final String anaysisType;

  final String key;
  AnalysisType({
    required this.anaysisType,

    required this.key,
  });

  AnalysisType copyWith({
    String? anaysisType,
    bool? isNeccessary,
    String? key,
  }) {
    return AnalysisType(
      anaysisType: anaysisType ?? this.anaysisType,

      key: key ?? this.key,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'anaysisType': anaysisType,

      'key': key,
    };
  }

  factory AnalysisType.fromMap(Map<String, String> map) {
    print('${map['isNeccessary']} from map ');
    return AnalysisType(
      anaysisType: map['anaysisType']!,
      key: map['key']!,
    );
  }

  String toJson() => json.encode(toMap());

  factory AnalysisType.fromJson(String source) =>
      AnalysisType.fromMap(json.decode(source));

  @override
  String toString() =>
      'AnalysisType(anaysisType: $anaysisType, key: $key)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnalysisType &&
        other.anaysisType == anaysisType &&

        other.key == key;
  }

  @override
  int get hashCode =>
      anaysisType.hashCode ^  key.hashCode;
}
