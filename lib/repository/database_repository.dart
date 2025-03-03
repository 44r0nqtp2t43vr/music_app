import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:music_app/ble_service.dart';
import 'package:music_app/injection_container.dart';

import 'package:music_app/interface/database_repository.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
  @override
  Future<void> getPatternString() async {
    final String serverIP = sl<BLEService>().getServerIP();
    final String apiUrl = "http://$serverIP:8000/api/get-pattern-string/";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response: ${data['data']}");
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to connect: $e");
    }
  }
}
