import 'dart:convert';

import 'package:http/http.dart' as http;

class EquipmentsApi {
  static Future<List<Equipment>> getEquipmentSuggestions(String query) async {
    // final url = Uri.parse('http://192.168.5.60:9000/equipments');
    final url = Uri.parse('https://construck-backend.herokuapp.com/equipments');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List projects = json.decode(response.body);

      return projects.map((json) => Equipment.fromJson(json)).where((project) {
        final plateLower = project.plateNumber.toLowerCase();
        final queryLower = query.toLowerCase();

        return plateLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}

class Equipment {
  final String plateNumber;
  final String equipmentId;

  const Equipment({
    required this.plateNumber,
    required this.equipmentId,
  });

  static Equipment fromJson(Map<String, dynamic> json) =>
      Equipment(plateNumber: json['plateNumber'], equipmentId: json['_id']);
}
