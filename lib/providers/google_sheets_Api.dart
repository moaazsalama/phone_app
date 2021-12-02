// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:gsheets/gsheets.dart';
import 'package:phone_lap/models/analysis.dart';
import 'package:phone_lap/models/analysisType.dart';
import 'package:phone_lap/providers/order.dart';

class UserSheetApi {
  static const _spreedSheetId = '1-4qGNyhJlqlDL4e57ZSET5mccManFQZwMCjFFYmpVKU';
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "phone-lap",
  "private_key_id": "bd4d3357c92ea145c8c5a99f891b5bd2d47d49e3",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDCaH2cW4XTn7de\nJ2eI9je9/0JkQ4rUV7dzOjt8iuq0b9E5isjQWZGD5lqHM3RbQu2z4eDP0h0+OFT6\nYzDYH/t5Ugb23+n7arkYZWrgQrHl7+/O/xmj0hNSpVrBpneJE+BA3GZVFfTa5XRL\nOx6yyaPPNxMsp26Pksz3QcSPN+NCQBVxxhkbYV+2SE+LoGQcfT0pzYKmlaZji0x7\nKkanFibOExJoouETrOK/SG2s4EvtoGSkZIVVjNLsR75+UQXOrkwGdkXqjbKXiYrX\nTS0EDwk4HwXyzT2fsLoWbl8Gy9tEwj+rVspZGkjPwG2TtWvr88GEE3eDScnhKlgf\nfbr+YVnLAgMBAAECggEAI2RYcc2rqGIsRMTRsXp5nWpKEOzG6m9po12XlM3Jer3c\njig49M1Jk4StOG3iofamRZg6kDsFPd2NguPp8X6pDmYjhHAxLac5OTrFYTxjHKQ4\nuStx5IQLJoGZ6yU+H8NxkP1O1/CeWfdp24RQy2WwH7o8EGYO1653CBB+E0Cua9Hj\nM/xoWVpusIIHcv4KVwl/YNaA4oYcUR4UMxsM1tjHLW2oKjN1M4SLqqNmlxT83WV1\nnh8MzTqjQAy/TXOmbDQuERwmNZe1fnZh4rPzZYfbSWOd9LIBP8kO42RP349A6Jv9\nL7PxyFynr0vMCfemef+MEGzVfVg4McKy3cfESWftCQKBgQD2dOwbqgGNj/eHpKkP\nWTYmLWepURtJGSJyp4SbIlZSetcXA57/WVQYwPiNzjz21UHjUTGzd3CVZFTU/XB/\n0NDhRoStrjIcAHLhTvoWeFaj6tywLv4HHjLmPxskzq0LXsu5FzNCFTOSmi7m+C1V\nOpygGkATWKo6O2PfqunfoBYP/wKBgQDJ757/knyX6t1ztKPABfJ6IVPPUCKnHkk9\nBGQ07fW06HgiRvZgeSU0Ac7Zs4Ti7/ARM4ObICUG/qs9OSX1w0ZxGEFBr1iVGyLB\noGcKaZPF5QZFMY+zxkvtG4Keni/srLf72KA08TgYlt1CxDheELcE62IwAFwccmkD\nWxhJSY/2NQKBgBNbDWwCxwpyIxORGAHvlLQc3sZKa2UrRyxQAbcZVEQ4B4p0K1mM\nj3E+PocMincsOnd62fdpSvtAnPT5TouLP8xheGwXgTH3yw3s4PFA1DUdbeWcWzD9\n6ytwC1axsJ9y+3b23nyzI5DA8SwMk6rc5o4gYaXjUcMvBOH9D08TyIfLAoGBAIKa\nGYlNootWeVdmEyoULpjSiTPhrifLrK5r8qtQ48LXPytcHeiTMX6LVM70DhP//pIB\ncTKY/Zmih/mWxnhGjX6Do2DqGS6GWFpGdZ4EXnB1CTMjNL+elmiJjFcuE+zMYEnf\n9u2GvTMaD4wpABPGV7g0zFIjSW+Uh1qGRhTQIO2pAoGBAMYSjHrnenrfvhUtBbbZ\nor8fCf1Bkabsc90W8aAtwGK/S586UkDS9yMD4h+oREh9NYOH4iV1S4nPnFq4lFJz\n5qvZQO2nFugUmNA+MtAsfJgmY2etz/zkGIo5KM/oaBaabS/8uYzMzdFCnIZgjliX\nM6oHHeiPRDW9e+ASPqO0Vsjp\n-----END PRIVATE KEY-----\n",
  "client_email": "phone-lap@appspot.gserviceaccount.com",
  "client_id": "105548675272790292536",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/phone-lap%40appspot.gserviceaccount.com"
}

  ''';
  static List<String> admins = [];
  static Worksheet? _admins;

  static Worksheet? _pcrTravelOrders;

  static Worksheet? _pcrNormalOrders;

  static Worksheet? _necessaryOrders;
  static Worksheet? _bloodOrders;
  static Worksheet? _bloodAnalysis;
  static Worksheet? _bloodAnalysisType;
  static final _gsheets = GSheets(_credentials);

  static Future<void> init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreedSheetId);
      _admins = await _getWorkSheet(spreadsheet, title: 'Admins');
      _pcrTravelOrders =
          await _getWorkSheet(spreadsheet, title: 'PCR Travel(Orders)');
      _pcrTravelOrders!.values.insertRow(1, OrderItem.values);
      _pcrNormalOrders =
          await _getWorkSheet(spreadsheet, title: 'PCR Normal(Orders)');
      _necessaryOrders =
          await _getWorkSheet(spreadsheet, title: 'Necessary(Orders)');
      _bloodAnalysis =
          await _getWorkSheet(spreadsheet, title: 'Blood Analysis');
      _bloodOrders = await _getWorkSheet(spreadsheet, title: 'Blood (Orders)');
      final list = await fetchAnalysis();
      print(list.length);
      _bloodAnalysisType =
          await _getWorkSheet(spreadsheet, title: 'Blood Analysis Type');

      final values = OrderItem.values;
      values.removeWhere((element) => element.contains('analysisType')
          ? true
          : element.contains('isNecessary')
              ? true
              : element.contains('passportImageUrl')
                  ? true
                  : element.contains('travlingCountry')
                      ? true
                      : element.contains('flightLine')
                          ? true
                          : false);
      _pcrNormalOrders!.values.insertRow(1, values);
      await fetchAdmins();
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<List<AnalysisType>> fetchAnalysisTypes(
      {bool? isNecessary}) async {
    final List<Map<String, String>>? analysisTypes =
        await _bloodAnalysisType!.values.map.allRows(fromRow: 1);

   return List.generate(analysisTypes!.length,
        (index) => AnalysisType.fromMap(analysisTypes[index]));



  }

  static Future<List<Analysis>> fetchAnalysis({String? key}) async {
    final List<Map<String, String>>? analysis =
        await _bloodAnalysis!.values.map.allRows(fromRow: 1);
    print(analysis);
    final List<Analysis> list = List.generate(
        analysis!.length, (index) => Analysis.fromMap(analysis[index]));
    if (key == null) {
      return list;
    } else {
      return list.where((element) => element.analysisType == key).toList();
    }
  }

  static Future<void> fetchAdmins() async {
    if (admins.isEmpty) {
      final List<Map<String, String>>? data =
          await _admins!.values.map.allRows(fromRow: 1);

      admins = List.generate(data!.length, (index) => data[index]['email']!);
    }
  }

  static Future insertPcrTravel(Map<String, dynamic> rowList) async {
    if (_pcrTravelOrders == null) return;
    _pcrTravelOrders!.values.map.appendRow(rowList);
  }

  static Future insertPcrNormal(Map<String, dynamic> rowList) async {
    if (_pcrNormalOrders == null) return;
    _pcrNormalOrders!.values.map.appendRow(rowList);
  }

  static Future insertBloodAnalysis(Map<String, dynamic> rowList) async {
    if (_bloodOrders == null) return;
    _bloodOrders!.values.map.appendRow(rowList);
  }

  static Future insertNecessaryAnalysis(Map<String, dynamic> rowList) async {
    if (_bloodOrders == null) return;
    _necessaryOrders!.values.map.appendRow(rowList);
  }

  static Future<Worksheet?> _getWorkSheet(Spreadsheet spreedSheet,
      {required String title}) async {
    try {
      return await spreedSheet.addWorksheet(title);
    } catch (e) {
      return spreedSheet.worksheetByTitle(title);
    }
  }
}
