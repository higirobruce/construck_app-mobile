import 'package:construck_app/api/user_api.dart';
import 'package:construck_app/screens/mainScreen.dart';
import 'package:construck_app/screens/success.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String _id = '';
  bool submitting = false;

  login(context, username, password) {
    setState(() {
      submitting = true;
    });
    UserApi.login(password, username).then(
      (value) => {
        if (value['allowed'] == true)
          {
            _id = value['user']['_id'],
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(_id),
                ),
                (Route<dynamic> route) => route is Success)
          }
        else
          {},
        setState(() {
          submitting = false;
        }),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Construck',
                  style: TextStyle(fontSize: 32.0),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Izina/Imeyili',
                            style: TextStyle(
                                color: Colors.blueGrey, fontSize: 16.0),
                          ),
                          TextFormField(
                            controller: usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Andika izina cyangwa imeyili';
                              }
                              return null;
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text(
                              "ijambo ry'ibanga",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 16.0),
                            ),
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Andika ijambo ry'ibanga";
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: !submitting
                                ? ElevatedButton(
                                    onPressed: () {
                                      // Validate returns true if the form is valid, or false otherwise.
                                      if (_formKey.currentState!.validate()) {
                                        // If the form is valid, display a snackbar. In the real world,
                                        // you'd often call a server or save the information in a database.
                                        // ScaffoldMessenger.of(context).showSnackBar(
                                        //   const SnackBar(
                                        //       content: Text('Processing Data')),
                                        // );

                                        login(context, usernameController.text,
                                            passwordController.text);
                                      }
                                    },
                                    child: const Text('OHEREZA'),
                                  )
                                : Text('Ihangane....'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
