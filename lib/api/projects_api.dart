import 'dart:convert';

import 'package:http/http.dart' as http;

class ProjectsApi {
  static Future<List<Project>> getUserSuggestions(String query) async {
    // final url = Uri.parse('http://192.168.5.60:9000/projects');
    final url = Uri.parse('https://construck-backend.herokuapp.com/projects');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List projects = json.decode(response.body);

      return projects.map((json) => Project.fromJson(json)).where((project) {
        final nameLower = project.prjDescription.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}

class Project {
  final String prjDescription;
  final String prjId;

  const Project({
    required this.prjDescription,
    required this.prjId,
  });

  static Project fromJson(Map<String, dynamic> json) =>
      Project(prjDescription: json['prjDescription'], prjId: json['_id']);
}
