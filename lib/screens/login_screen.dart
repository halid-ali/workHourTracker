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
import 'package:work_hour_tracker/widgets/app_toast.dart';

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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: PlatformInfo.isWeb()
                    ? 600
                    : MediaQuery.of(context).size.width,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Header
                  Container(
                    color: Color(0xFF1D3557),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              S.of(context).login,
                              style: GoogleFonts.merriweather(
                                color: Color(0xFFF1FAEE),
                                fontSize: 21,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Separator
                  Container(
                    height: 10,
                    color: Color(0xFFE63946),
                    margin: EdgeInsets.only(bottom: 20),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('chronometer.png'),
                          fit: BoxFit.none,
                          scale: 1.5,
                          alignment: Alignment.topCenter,
                          colorFilter: ColorFilter.mode(
                            Color(0xFFF5F3F4),
                            BlendMode.color,
                          ),
                        ),
                        color: Color(0xFFF5F3F4),
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFD3D3D3),
                        ),
                      ),
                      child: CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            // hasScrollBody: false,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(child: Container()),
                                dropdownList(),
                                SizedBox(height: 20),
                                AppTextFormField(
                                  hintText: S.of(context).password,
                                  controller: _passwordController,
                                  validateFunc: (val) => '',
                                  isObscureText: true,
                                ),
                                SizedBox(height: 40),
                                Row(
                                  children: [
                                    Expanded(child: Container()),
                                    Expanded(
                                      flex: 3,
                                      child: AppButton(
                                        text: S.of(context).login,
                                        backgroundColor: Color(0xFF0DB65C),
                                        onSubmitFunction: _login,
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                  ],
                                ),
                                divider(),
                                Row(
                                  children: [
                                    Expanded(child: Container()),
                                    Expanded(
                                      flex: 3,
                                      child: AppButton(
                                        text: S.of(context).register,
                                        backgroundColor: Color(0xFFE63946),
                                        onSubmitFunction: () =>
                                            Navigator.pushNamed(context,
                                                RouteGenerator.registerPage),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                  ],
                                ),
                                Expanded(child: Container()),
                                TextButton(
                                  child: Text(S.of(context).forgot_password),
                                  onPressed: () => print('Forgot Password'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
          return Text(S.of(context).error_occurred);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        var users = snapshot.data.docs;
        users.sort(
          (a, b) => a
              .data()['username']
              .toString()
              .compareTo(b.data()['username'].toString()),
        );
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

  Widget divider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            height: 50,
            thickness: 1,
            color: Color(0xFFD3D3D3),
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
            color: Color(0xFFD3D3D3),
          ),
        ),
      ],
    );
  }

  void _login() async {
    if (_selectedUser == null) {
      AppToast.info(context, S.of(context).select_user_toast);
      return;
    }

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot docSnapshot =
        await firestore.collection('users').doc(_selectedUser).get();

    if (_passwordController.text == docSnapshot.data()['password']) {
      if (PlatformInfo.isWeb()) {
        WebStorage.instance.userId = docSnapshot.id;
        WebStorage.instance.username = docSnapshot.data()['username'];
      } else {
        await Preferences.write('userId', docSnapshot.id);
        await Preferences.write('username', docSnapshot.data()['username']);
      }

      Navigator.pushNamed(context, RouteGenerator.homePage);
    } else {
      AppToast.error(context, S.of(context).wrong_password);
    }
  }
}
