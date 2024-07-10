import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class LogDataProvider extends ChangeNotifier {
  List<Map<String, dynamic>> logData = [];

  Future<void> getlogdata() async {
    final url = Uri.parse('http://103.215.229.251/api/LogData');
    try {
      final response = await http.get(url);  // Change from post to get
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['data'] != null && result['data'] is List) {
          logData = List<Map<String, dynamic>>.from(result['data'].map((item) => Map<String, dynamic>.from(item)));
          notifyListeners();  // Notify listeners after data is fetched
        } else {
          print('No data field found in the response or it is not a list');
        }
      } else {
        print('Failed to fetch data: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }
}
