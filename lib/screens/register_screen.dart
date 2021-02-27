import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/routes.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: PlatformInfo.isWeb()
                  ? 600
                  : MediaQuery.of(context).size.width,
            ),
            child: Column(
              children: [
                // Header
                Container(
                  color: Color(0xFF1D3557),
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Register',
                            style: GoogleFonts.merriweather(
                              color: Color(0xFFF1FAEE),
                              fontSize: 21,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        child: Icon(
                          Icons.close_sharp,
                          color: Color(0xFFF1FAEE),
                        ),
                        onTap: () => Navigator.pushNamed(
                            context, RouteGenerator.homePage),
                      ),
                    ],
                  ),
                ),
                // Separator
                Container(
                  height: 1,
                  color: Color(0xFFE63946),
                  margin: EdgeInsets.symmetric(vertical: 20),
                ),
                // Content
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xFFF1FAEE),
                        border: Border.all(
                          width: 1,
                          color: Color(0xFF1D3557),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CustomScrollView(
                          slivers: [
                            SliverFillRemaining(
                              // hasScrollBody: false,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _usernameController,
                                    obscureText: false,
                                    validator: _validateUsername,
                                    style: TextStyle(fontSize: 13),
                                    decoration: _getDecoration(
                                      'Username',
                                      Icons.person_sharp,
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    validator: _validatePassword,
                                    style: TextStyle(fontSize: 13),
                                    decoration: _getDecoration(
                                      'Password',
                                      Icons.lock_sharp,
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  TextFormField(
                                    controller: _passwordRepeatController,
                                    obscureText: true,
                                    validator: _validatePasswordConfirm,
                                    style: TextStyle(fontSize: 13),
                                    decoration: _getDecoration(
                                      'Password Repeat',
                                      Icons.lock_sharp,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  InkWell(
                                    child: Container(
                                      color: Color(0xFFE63946),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        S.of(context).register,
                                        style: GoogleFonts.merriweather(
                                          color: Color(0xFFF1FAEE),
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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

  InputDecoration _getDecoration(String hintText, IconData icon) {
    return InputDecoration(
      errorStyle: TextStyle(fontSize: 9),
      errorMaxLines: 2,
      helperText: 'Required',
      helperStyle: TextStyle(fontSize: 9),
      hintText: hintText,
      icon: Icon(
        icon,
        color: Color(0xFF457B9D),
        size: 33,
      ),
      suffixIcon: Icon(
        Icons.check,
        color: Colors.green,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFE63946),
        ),
      ),
    );
  }

  String _validateUsername(String username) {
    return '';
  }

  String _validatePassword(String password) {
    return '';
  }

  String _validatePasswordConfirm(String password) {
    return '';
  }
}
