import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MForm extends StatefulWidget {
  const MForm({Key? key}) : super(key: key);

  @override
  _MFormState createState() => _MFormState();
}

class _MFormState extends State<MForm> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Project Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Project name can not be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Plate Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Plate number can not be empty';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Text(
                      'Equipment type',
                      style: TextStyle(fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        // icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.blueAccent),
                        underline: Container(
                          height: 2,
                          color: Colors.blueAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['One', 'Two', 'Three', 'Four']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Work done',
                      style: TextStyle(fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        // icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.blueAccent),
                        underline: Container(
                          height: 2,
                          color: Colors.blueAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['One', 'Two', 'Three', 'Four']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Start Index',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Plate number can not be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'End index',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Plate number can not be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'DYS & HRS',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Plate number can not be empty';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
