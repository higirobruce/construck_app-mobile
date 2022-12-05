import 'dart:convert';

import 'package:construck_app/api/equipments_api.dart';
import 'package:construck_app/api/projects_api.dart';
import 'package:construck_app/api/user_api.dart';
import 'package:construck_app/api/workDone_api.dart';
import 'package:http/http.dart' as http;

class WorkDatasApi {
  static Future<List<WorkData>> getWorkData(userId) async {
    // final url = Uri.parse('http://192.168.5.60:9000/works');
    final url = Uri.parse('https://construck-backend.herokuapp.com/works');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List works = json.decode(response.body);

      return works.map((json) => WorkData.fromJson(json)).where((job) {
        return (job.driver.userId == userId &&
            (job.status != 'approved' && job.status != 'rejected'));
      }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<bool> saveWorkData(
    Project project,
    Equipment equipment,
    String workDone,
    String startIndex,
    String endIndex,
    String hours,
    String comment,
  ) async {
    // final url = Uri.parse('http://192.168.5.60:9000/works');
    final url = Uri.parse('https://construck-backend.herokuapp.com/works');
    final response = await http.post(url, body: {
      "project": project.prjId,
      "equipment": equipment.equipmentId,
      "workDone": workDone,
      "startIndex": startIndex,
      "endIndex": endIndex,
      "startTime": "2022-04-13T11:20:19.858Z",
      "endTime": "2022-04-13T21:20:19.858Z",
      "rate": "500",
      "driver": "6260051e74e53acb4eac871b",
      "status": "created",
      "duration": hours,
      "comment": comment
    });

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> startJob(String jobId, String startIndex) async {
    // final url = Uri.parse('http://192.168.5.60:9000/works/start/' + jobId);
    final url = Uri.parse(
        'https://construck-backend.herokuapp.com/works/start/' + jobId);
    final response = await http.put(url, body: {"startIndex": startIndex});

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> endJob(String jobId, String endIndex, String duration,
      String tripsDone, String comment) async {
    // final url = Uri.parse('http://192.168.5.60:9000/works/stop/' + jobId);
    final url = Uri.parse(
        'https://construck-backend.herokuapp.com/works/stop/' + jobId);
    final response = await http.put(url, body: {
      "endIndex": endIndex,
      "duration": duration,
      "tripsDone": tripsDone,
      "comment": comment,
    });

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}

class WorkData {
  final WorkDone workDone;
  final String jobId;
  final String status;
  final Project prj;
  final String createdOn;
  final User driver;
  final Equipment equipment;

  const WorkData({
    required this.workDone,
    required this.jobId,
    required this.status,
    required this.prj,
    required this.createdOn,
    required this.driver,
    required this.equipment,
  });

  static WorkData fromJson(Map<String, dynamic> json) => WorkData(
      workDone: WorkDone.fromJson(json['workDone']),
      jobId: json['_id'],
      status: json['status'],
      prj: Project.fromJson(
        json['project'],
      ),
      createdOn: json['createdOn'],
      equipment: Equipment.fromJson(json['equipment']),
      driver: User.fromJson(json['driver']));
}
