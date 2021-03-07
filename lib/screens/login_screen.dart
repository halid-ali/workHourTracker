import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_hour_tracker/routes.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/utils/preferences.dart';
import 'package:work_hour_tracker/utils/web_storage.dart';
import 'package:work_hour_tracker/widgets/app_button.dart';
import 'package:work_hour_tracker/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();
  String _selectedUser;

  Future<void> _login() async {
    if (PlatformInfo.isWeb()) {
      WebStorage.instance.userId = '1';
    } else {
      await Preferences.setInt('userId', 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    _login();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () =>
                        Navigator.pushNamed(context, RouteGenerator.homePage),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.arrow_back_ios_sharp),
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
              Expanded(child: Container()),
              Container(
                color: Colors.pink,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(20.0),
                    padding: EdgeInsets.all(20.0),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        userList(),
                        AppTextFormField(
                          hintText: 'Password',
                          controller: _passwordController,
                          validateFunc: (value) {},
                          isObscureText: true,
                        ),
                        getButton('Login'),
                        SizedBox(height: 20),
                        TextButton(
                          child: Text('Forgot Password'),
                          onPressed: () => print('Forgot Password'),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                height: 50,
                                thickness: 1,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20.0),
                              child: Text('or'),
                            ),
                            Expanded(
                              child: Divider(
                                height: 50,
                                thickness: 1,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        getButton('Register'),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  Widget userList() {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return StreamBuilder(
      stream: firestore.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error occured');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        var users = snapshot.data.docs;
        return DropdownButton<String>(
          isExpanded: true,
          value: _selectedUser,
          hint: Text('Select User'),
          style: GoogleFonts.openSans(fontSize: 17),
          onChanged: (String value) {
            setState(() {
              _selectedUser = value;
            });
            print(_selectedUser);
          },
          items: users
              .map<DropdownMenuItem<String>>(
                (e) => DropdownMenuItem<String>(
                  value: e.data()['username'],
                  child: Text(e.data()['username']),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget getButton(String text) {
    return AppButton(
      text: text,
      backgroundColor: Color(0xFFE63946),
      onSubmitFunction: () => print(text),
    );
  }
}
