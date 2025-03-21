import 'dart:convert';

import 'package:flutter/services.dart';

class JsonService {
  static Future<Map<String, dynamic>> Readquestions(String filepath) async{
    String json = await rootBundle.loadString(filepath);
    return jsonDecode(json);
  }
}