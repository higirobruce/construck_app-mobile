// ignore_for_file: unnecessary_const

import 'package:construck_app/api/equipments_api.dart';
import 'package:construck_app/api/projects_api.dart';
import 'package:construck_app/api/reasons_api.dart';
import 'package:construck_app/api/workData_api.dart';
import 'package:construck_app/api/workDone_api.dart';
import 'package:construck_app/screens/success.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MainScreen extends StatefulWidget {
  final String userId;
  const MainScreen(this.userId, {Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _equipmentController = TextEditingController();
  final TextEditingController _workDoneController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _startIndex = TextEditingController();
  final TextEditingController _endIndex = TextEditingController();
  final TextEditingController _duration = TextEditingController();
  final TextEditingController _tripsDone = TextEditingController();
  final TextEditingController _hours = TextEditingController();

  Project project = const Project(prjDescription: '', prjId: '');
  Equipment equipment = const Equipment(equipmentId: '', plateNumber: '');
  WorkDone workDone = const WorkDone(jobDescription: '', jobId: '');
  Reason reason =
      const Reason(description: '', reasonId: '', descriptionRw: '');
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      FutureBuilder<List<WorkData>>(
        future: WorkDatasApi.getWorkData(widget.userId),
        builder: (context, jobSnap) {
          final jobs = jobSnap.data;
          switch (jobSnap.connectionState) {
            case ConnectionState.waiting:
              return (Center(
                child: CircularProgressIndicator(),
              ));
            default:
              if (jobSnap.hasError) {
                return Center(
                  child: Text(jobSnap.error.toString()),
                );
              } else {
                return buildJobs(jobs);
              }
          }
        },
      ),
      const Center(
        child: Text('Settings'),
      ),
    ];
    const bottomNavigationBarItem = BottomNavigationBarItem(
      icon: Icon(Icons.file_copy),
      label: 'Data',
      backgroundColor: Colors.blue,
    );
    const bottomNavigationBarItem2 = BottomNavigationBarItem(
      icon: Icon(Icons.task),
      label: 'Jobs',
      backgroundColor: Colors.blue,
    );
    const bottomNavigationBarItem3 = BottomNavigationBarItem(
      icon: const Icon(Icons.settings),
      label: 'Settings',
      backgroundColor: Colors.blue,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Construck App')),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          onTap: (index) => setState(() {
                currentIndex = index;
              }),
          currentIndex: currentIndex,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            bottomNavigationBarItem2,
            bottomNavigationBarItem3,
          ]),
    );
  }

  Widget buildJobs(List<WorkData>? jobs) => ListView.builder(
        itemBuilder: (context, index) {
          final job = jobs![index];
          return Card(
            child: ListTile(
                title: Text(job.prj.prjDescription),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job.workDone.jobDescription),
                        Text(job.equipment.plateNumber,
                            style: TextStyle(
                                color: Color.fromARGB(135, 20, 20, 20),
                                fontWeight: FontWeight.bold)),
                      ]),
                ),
                trailing: job.status == 'in progress'
                    ? IconButton(
                        onPressed: () => {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('Gusoza akazi'),
                                        content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                controller: _endIndex,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText:
                                                      "Kilometraje nyuma y'akazi",
                                                  prefixIcon: Icon(Icons.login),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Andika Kilometraje zisoza';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              TextFormField(
                                                controller: _duration,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText:
                                                      'Amasaha akazi katwaye',
                                                  prefixIcon:
                                                      Icon(Icons.timelapse),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Andika amasaha akazi katwaye';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              TextFormField(
                                                controller: _tripsDone,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText:
                                                      "Umubare w'Ingendo wakoze",
                                                  prefixIcon: Icon(
                                                      Icons.threesixty_sharp),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Andika umubare w'ingendo wakoze";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              TypeAheadFormField(
                                                debounceDuration:
                                                    const Duration(
                                                        milliseconds: 500),
                                                // hideSuggestionsOnKeyboardHide: false,
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  controller: _reasonController,
                                                  decoration:
                                                      const InputDecoration(
                                                    prefixIcon: Icon(
                                                        Icons.question_mark),
                                                    hintText: 'Impamvu',
                                                  ),
                                                ),
                                                onSuggestionSelected:
                                                    (Reason suggestion) {
                                                  _reasonController.text =
                                                      suggestion.descriptionRw;
                                                  reason = suggestion;
                                                },
                                                itemBuilder: (context,
                                                    Reason? suggestion) {
                                                  final reason = suggestion!;

                                                  return ListTile(
                                                    title: Text(
                                                        reason.descriptionRw),
                                                  );
                                                },
                                                suggestionsCallback: ReasonApi
                                                    .getReasonSuggestion,
                                                noItemsFoundBuilder:
                                                    (context) => Container(
                                                  height: 80,
                                                  child: const Center(
                                                    child: Text(
                                                      'Nta mpamvu zibonetse.',
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('GUSUBIRA INYUMA')),
                                          TextButton(
                                            onPressed: () => {
                                              WorkDatasApi.endJob(
                                                      job.jobId,
                                                      _endIndex.text,
                                                      _duration.text,
                                                      _tripsDone.text,
                                                      _reasonController.text)
                                                  .then(
                                                (value) => setState(
                                                  () {},
                                                ),
                                              ),
                                              Navigator.pop(context),
                                            },
                                            child: Text("OHEREZA"),
                                          )
                                        ],
                                      )),
                            },
                        // ignore: prefer_const_constructors
                        icon: Icon(
                          Icons.stop,
                          color: Colors.red,
                        ))
                    : job.status == 'created'
                        ? IconButton(
                            onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text('Gutangira akazi'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: _startIndex,
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'Kilometraje utangiranye',
                                              prefixIcon: Icon(Icons.login),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Andika kilometraje utangiranye';
                                              }
                                              return null;
                                            },
                                          )
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('GUSUBIRA INYUMA')),
                                        TextButton(
                                          onPressed: () => {
                                            WorkDatasApi.startJob(
                                                    job.jobId, _startIndex.text)
                                                .then(
                                              (value) => setState(
                                                () => {_duration.text = ''},
                                              ),
                                            ),
                                            Navigator.pop(context),
                                          },
                                          child: Text("OHEREZA"),
                                        )
                                      ],
                                    )),

                            // ignore: prefer_const_constructors
                            icon: Icon(
                              Icons.play_arrow,
                              color: Colors.green,
                            ))
                        : job.status == 'approved'
                            // ignore: prefer_const_constructors
                            ? Icon(
                                Icons.check,
                                color: Colors.blue,
                              )
                            // ignore: prefer_const_constructors
                            : job.status == 'stopped'
                                ? Icon(
                                    Icons.hourglass_bottom,
                                  )
                                : Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  )),
          );
        },
        physics: BouncingScrollPhysics(),
        itemCount: jobs!.length,
      );
}
