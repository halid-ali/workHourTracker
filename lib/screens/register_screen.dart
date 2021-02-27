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
                            S.of(context).register,
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
                  height: 10,
                  color: Color(0xFFE63946),
                  margin: EdgeInsets.only(bottom: 20),
                ),
                // Content
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFCED4DA),
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
                                    style: GoogleFonts.openSans(fontSize: 17),
                                    decoration: _getDecoration(
                                      S.of(context).username,
                                      Icons.person_sharp,
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    validator: _validatePassword,
                                    style: GoogleFonts.openSans(fontSize: 17),
                                    decoration: _getDecoration(
                                      S.of(context).password,
                                      Icons.lock_sharp,
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  TextFormField(
                                    controller: _passwordRepeatController,
                                    obscureText: true,
                                    validator: _validatePasswordConfirm,
                                    style: GoogleFonts.openSans(fontSize: 17),
                                    decoration: _getDecoration(
                                      S.of(context).repeat_password,
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
      errorMaxLines: 2,
      errorStyle: GoogleFonts.openSans(fontSize: 11),
      helperText: S.of(context).required_field,
      helperStyle: GoogleFonts.openSans(fontSize: 11),
      hintText: hintText,
      hintStyle: GoogleFonts.openSans(fontSize: 17),
      icon: Icon(
        icon,
        color: Color(0xFF6C757D),
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
