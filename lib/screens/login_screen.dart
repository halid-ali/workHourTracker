import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
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

  @override
  Widget build(BuildContext context) {
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
                        dropdownList(),
                        SizedBox(height: 20),
                        AppTextFormField(
                          hintText: S.of(context).password,
                          controller: _passwordController,
                          validateFunc: (value) => '',
                          isObscureText: true,
                        ),
                        AppButton(
                          text: S.of(context).login,
                          backgroundColor: Color(0xFFE63946),
                          onSubmitFunction: _login,
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          child: Text(S.of(context).forgot_password),
                          onPressed: () => print('Forgot Password'),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                height: 50,
                                thickness: 1,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Text(S.of(context).or),
                            ),
                            Expanded(
                              child: Divider(
                                height: 50,
                                thickness: 1,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                          ],
                        ),
                        AppButton(
                          text: S.of(context).register,
                          backgroundColor: Color(0xFFE63946),
                          onSubmitFunction: () => Navigator.pushNamed(
                              context, RouteGenerator.registerPage),
                        ),
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

  Widget dropdownList() {
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
        users.sort((a, b) => a
            .data()['username']
            .toString()
            .compareTo(b.data()['username'].toString()));
        return DropdownButton<String>(
          isExpanded: true,
          value: _selectedUser,
          hint: Text(S.of(context).select_user),
          style: GoogleFonts.openSans(fontSize: 17),
          onChanged: (String value) {
            setState(() {
              _selectedUser = value;
            });
          },
          items: users
              .map<DropdownMenuItem<String>>(
                (e) => DropdownMenuItem<String>(
                  value: e.id,
                  child: Row(
                    children: [
                      Text('${e.data()['username']}'),
                      Expanded(child: Container()),
                      Text('${e.id}'),
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  void _login() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot docSnapshot =
        await firestore.collection('users').doc(_selectedUser).get();

    if (_passwordController.text == docSnapshot.data()['password']) {
      if (PlatformInfo.isWeb()) {
        WebStorage.instance.userId = docSnapshot.id;
      } else {
        await Preferences.write('userId', docSnapshot.id);
      }

      Navigator.pushNamed(context, RouteGenerator.homePage);
    }
  }
}
