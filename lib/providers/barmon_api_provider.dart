import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/barmon.dart';

final barMonApiProvider = FutureProvider<List<BarMon>>((ref) async {
  final response = await http.get(Uri.parse('http://localhost:4000/api/barmon'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => BarMon.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load BarMons');
  }
}); 