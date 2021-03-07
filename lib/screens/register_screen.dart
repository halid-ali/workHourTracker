import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/routes.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/widgets/app_button.dart';
import 'package:work_hour_tracker/widgets/app_text_field.dart';

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
  final _emailController = TextEditingController();

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
                // Form
                _buildForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
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
                      //Username
                      AppTextFormField(
                        isRequired: true,
                        hintText: S.of(context).username,
                        iconData: Icons.account_box_sharp,
                        validateFunc: _validateUsername,
                        controller: _usernameController,
                      ),
                      SizedBox(height: 40),
                      //Password
                      AppTextFormField(
                        isRequired: true,
                        isObscureText: true,
                        hintText: S.of(context).password,
                        iconData: Icons.lock_sharp,
                        validateFunc: _validatePassword,
                        controller: _passwordController,
                      ),
                      SizedBox(height: 40),
                      //Password Repeat
                      AppTextFormField(
                        isRequired: true,
                        isObscureText: true,
                        hintText: S.of(context).repeat_password,
                        iconData: Icons.lock_sharp,
                        validateFunc: _validatePasswordRepeat,
                        controller: _passwordRepeatController,
                      ),
                      SizedBox(height: 40),
                      //Email
                      AppTextFormField(
                        isRequired: true,
                        hintText: S.of(context).email,
                        iconData: Icons.email_sharp,
                        validateFunc: _validateMail,
                        controller: _emailController,
                      ),
                      Expanded(child: Container()),
                      //Button
                      AppButton(
                        text: S.of(context).register,
                        backgroundColor: Color(0xFFE63946),
                        onSubmitFunction: submitRegister,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitRegister() async {
    if (_formKey.currentState.validate()) {
      var userMap = <String, dynamic>{
        'username': _usernameController.text,
        'password': _passwordController.text,
        'email': _emailController.text,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc()
          .set(userMap)
          .catchError((dynamic e) => print(e));

      Navigator.pushNamed(context, RouteGenerator.loginPage);
    }
  }

  String _validateUsername(String username) {
    if (username == null || username.isEmpty) {
      return S.of(context).username_empty;
    }

    if (username.length < 5 || username.length > 15) {
      return S.of(context).username_invalid_length;
    }

    //TODO: check username existance from database

    return null;
  }

  String _validatePassword(String password) {
    if (password == null || password.isEmpty) {
      return S.of(context).password_empty;
    }

    if (password.length < 7 || password.length > 20) {
      return S.of(context).password_invalid_length;
    }

    var bufferPrefix = S.of(context).password_buffer_prefix;
    var buffer = StringBuffer();

    if (!password.contains(RegExp(r'[A-Z]'))) {
      buffer.write(S.of(context).password_contains_uppercase);
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      buffer.write(S.of(context).password_contains_lowercase);
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      buffer.write(S.of(context).password_contains_digit);
    }

    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      buffer.write(S.of(context).password_contains_special_character);
    }

    return buffer.isNotEmpty ? bufferPrefix + buffer.toString() : null;
  }

  String _validatePasswordRepeat(String password) {
    if (password != _passwordController.text) {
      return S.of(context).password_not_match;
    }

    if (_passwordController.text.isEmpty) {
      return '';
    }

    return null;
  }

  String _validateMail(String mail) {
    if (mail == null || mail.isEmpty) {
      return S.of(context).email_empty;
    }

    var pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    if (!RegExp(pattern).hasMatch(mail)) {
      return S.of(context).email_invalid;
    }

    //TODO: check email existance from database

    return null;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
