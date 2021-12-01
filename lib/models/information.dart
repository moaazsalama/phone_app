import 'dart:convert';

import 'package:http/http.dart' as http;

class Information {
  static Future<Information?> getInfo() async {
    try {
      final request = await http.get(Uri.parse(
          'https://corona.lmao.ninja/v2/countries/Egypt?yesterday=true&strict=true&query'));
      final String response = request.body;
      if (request.statusCode == 200) {
        return Information.fromJson(response);
      } else {
        print('error');
      }
    } catch (e) {
      print('enter');
      print(e.toString());
    }
  }

  final int updated;
  final String country;
  final CountryInfo countryInfo;
  final int cases;
  final int todayCases;
  final int deaths;
  final int todayDeaths;
  final int recovered;
  final int todayRecovered;
  final int active;
  final int critical;
  final int casesPerOneMillion;
  final int deathsPerOneMillion;
  final int tests;
  final int testsPerOneMillion;
  final int population;
  final String continent;
  final int oneCasePerPeople;
  final int oneDeathPerPeople;
  final int oneTestPerPeople;
  final double activePerOneMillion;
  final double recoveredPerOneMillion;
  final double criticalPerOneMillion;
  Information({
    required this.updated,
    required this.country,
    required this.countryInfo,
    required this.cases,
    required this.todayCases,
    required this.deaths,
    required this.todayDeaths,
    required this.recovered,
    required this.todayRecovered,
    required this.active,
    required this.critical,
    required this.casesPerOneMillion,
    required this.deathsPerOneMillion,
    required this.tests,
    required this.testsPerOneMillion,
    required this.population,
    required this.continent,
    required this.oneCasePerPeople,
    required this.oneDeathPerPeople,
    required this.oneTestPerPeople,
    required this.activePerOneMillion,
    required this.recoveredPerOneMillion,
    required this.criticalPerOneMillion,
  });

  Information copyWith({
    int? updated,
    String? country,
    CountryInfo? countryInfo,
    int? cases,
    int? todayCases,
    int? deaths,
    int? todayDeaths,
    int? recovered,
    int? todayRecovered,
    int? active,
    int? critical,
    int? casesPerOneMillion,
    int? deathsPerOneMillion,
    int? tests,
    int? testsPerOneMillion,
    int? population,
    String? continent,
    int? oneCasePerPeople,
    int? oneDeathPerPeople,
    int? oneTestPerPeople,
    double? activePerOneMillion,
    double? recoveredPerOneMillion,
    double? criticalPerOneMillion,
  }) {
    return Information(
      updated: updated ?? this.updated,
      country: country ?? this.country,
      countryInfo: countryInfo ?? this.countryInfo,
      cases: cases ?? this.cases,
      todayCases: todayCases ?? this.todayCases,
      deaths: deaths ?? this.deaths,
      todayDeaths: todayDeaths ?? this.todayDeaths,
      recovered: recovered ?? this.recovered,
      todayRecovered: todayRecovered ?? this.todayRecovered,
      active: active ?? this.active,
      critical: critical ?? this.critical,
      casesPerOneMillion: casesPerOneMillion ?? this.casesPerOneMillion,
      deathsPerOneMillion: deathsPerOneMillion ?? this.deathsPerOneMillion,
      tests: tests ?? this.tests,
      testsPerOneMillion: testsPerOneMillion ?? this.testsPerOneMillion,
      population: population ?? this.population,
      continent: continent ?? this.continent,
      oneCasePerPeople: oneCasePerPeople ?? this.oneCasePerPeople,
      oneDeathPerPeople: oneDeathPerPeople ?? this.oneDeathPerPeople,
      oneTestPerPeople: oneTestPerPeople ?? this.oneTestPerPeople,
      activePerOneMillion: activePerOneMillion ?? this.activePerOneMillion,
      recoveredPerOneMillion:
          recoveredPerOneMillion ?? this.recoveredPerOneMillion,
      criticalPerOneMillion:
          criticalPerOneMillion ?? this.criticalPerOneMillion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'updated': updated,
      'country': country,
      'countryInfo': countryInfo.toMap(),
      'cases': cases,
      'todayCases': todayCases,
      'deaths': deaths,
      'todayDeaths': todayDeaths,
      'recovered': recovered,
      'todayRecovered': todayRecovered,
      'active': active,
      'critical': critical,
      'casesPerOneMillion': casesPerOneMillion,
      'deathsPerOneMillion': deathsPerOneMillion,
      'tests': tests,
      'testsPerOneMillion': testsPerOneMillion,
      'population': population,
      'continent': continent,
      'oneCasePerPeople': oneCasePerPeople,
      'oneDeathPerPeople': oneDeathPerPeople,
      'oneTestPerPeople': oneTestPerPeople,
      'activePerOneMillion': activePerOneMillion,
      'recoveredPerOneMillion': recoveredPerOneMillion,
      'criticalPerOneMillion': criticalPerOneMillion,
    };
  }

  factory Information.fromMap(Map<String, dynamic> map) {
    return Information(
      updated: map['updated'],
      country: map['country'],
      countryInfo: CountryInfo.fromMap(map['countryInfo']),
      cases: map['cases'],
      todayCases: map['todayCases'],
      deaths: map['deaths'],
      todayDeaths: map['todayDeaths'],
      recovered: map['recovered'],
      todayRecovered: map['todayRecovered'],
      active: map['active'],
      critical: map['critical'],
      casesPerOneMillion: map['casesPerOneMillion'],
      deathsPerOneMillion: map['deathsPerOneMillion'],
      tests: map['tests'],
      testsPerOneMillion: map['testsPerOneMillion'],
      population: map['population'],
      continent: map['continent'],
      oneCasePerPeople: map['oneCasePerPeople'],
      oneDeathPerPeople: map['oneDeathPerPeople'],
      oneTestPerPeople: map['oneTestPerPeople'],
      activePerOneMillion: map['activePerOneMillion'],
      recoveredPerOneMillion: map['recoveredPerOneMillion'],
      criticalPerOneMillion: map['criticalPerOneMillion'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Information.fromJson(String source) =>
      Information.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Information(updated: $updated, country: $country, countryInfo: $countryInfo, cases: $cases, todayCases: $todayCases, deaths: $deaths, todayDeaths: $todayDeaths, recovered: $recovered, todayRecovered: $todayRecovered, active: $active, critical: $critical, casesPerOneMillion: $casesPerOneMillion, deathsPerOneMillion: $deathsPerOneMillion, tests: $tests, testsPerOneMillion: $testsPerOneMillion, population: $population, continent: $continent, oneCasePerPeople: $oneCasePerPeople, oneDeathPerPeople: $oneDeathPerPeople, oneTestPerPeople: $oneTestPerPeople, activePerOneMillion: $activePerOneMillion, recoveredPerOneMillion: $recoveredPerOneMillion, criticalPerOneMillion: $criticalPerOneMillion)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Information &&
        other.updated == updated &&
        other.country == country &&
        other.countryInfo == countryInfo &&
        other.cases == cases &&
        other.todayCases == todayCases &&
        other.deaths == deaths &&
        other.todayDeaths == todayDeaths &&
        other.recovered == recovered &&
        other.todayRecovered == todayRecovered &&
        other.active == active &&
        other.critical == critical &&
        other.casesPerOneMillion == casesPerOneMillion &&
        other.deathsPerOneMillion == deathsPerOneMillion &&
        other.tests == tests &&
        other.testsPerOneMillion == testsPerOneMillion &&
        other.population == population &&
        other.continent == continent &&
        other.oneCasePerPeople == oneCasePerPeople &&
        other.oneDeathPerPeople == oneDeathPerPeople &&
        other.oneTestPerPeople == oneTestPerPeople &&
        other.activePerOneMillion == activePerOneMillion &&
        other.recoveredPerOneMillion == recoveredPerOneMillion &&
        other.criticalPerOneMillion == criticalPerOneMillion;
  }

  @override
  int get hashCode {
    return updated.hashCode ^
        country.hashCode ^
        countryInfo.hashCode ^
        cases.hashCode ^
        todayCases.hashCode ^
        deaths.hashCode ^
        todayDeaths.hashCode ^
        recovered.hashCode ^
        todayRecovered.hashCode ^
        active.hashCode ^
        critical.hashCode ^
        casesPerOneMillion.hashCode ^
        deathsPerOneMillion.hashCode ^
        tests.hashCode ^
        testsPerOneMillion.hashCode ^
        population.hashCode ^
        continent.hashCode ^
        oneCasePerPeople.hashCode ^
        oneDeathPerPeople.hashCode ^
        oneTestPerPeople.hashCode ^
        activePerOneMillion.hashCode ^
        recoveredPerOneMillion.hashCode ^
        criticalPerOneMillion.hashCode;
  }
}

class CountryInfo {
  final int? id;
  final String? iso2;
  final String? iso3;
  final int? lat;
  final int? long;
  final String? flag;
  CountryInfo({
    this.id,
    this.iso2,
    this.iso3,
    this.lat,
    this.long,
    this.flag,
  });

  CountryInfo copyWith({
    int? id,
    String? iso2,
    String? iso3,
    int? lat,
    int? long,
    String? flag,
  }) {
    return CountryInfo(
      id: id ?? this.id,
      iso2: iso2 ?? this.iso2,
      iso3: iso3 ?? this.iso3,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      flag: flag ?? this.flag,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'iso2': iso2,
      'iso3': iso3,
      'lat': lat,
      'long': long,
      'flag': flag,
    };
  }

  factory CountryInfo.fromMap(Map<String, dynamic> map) {
    return CountryInfo(
      id: map['id'],
      iso2: map['iso2'],
      iso3: map['iso3'],
      lat: map['lat'],
      long: map['long'],
      flag: map['flag'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CountryInfo.fromJson(String source) =>
      CountryInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CountryInfo(id: $id, iso2: $iso2, iso3: $iso3, lat: $lat, long: $long, flag: $flag)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CountryInfo &&
        other.id == id &&
        other.iso2 == iso2 &&
        other.iso3 == iso3 &&
        other.lat == lat &&
        other.long == long &&
        other.flag == flag;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        iso2.hashCode ^
        iso3.hashCode ^
        lat.hashCode ^
        long.hashCode ^
        flag.hashCode;
  }
}
