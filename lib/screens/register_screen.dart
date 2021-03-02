import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/routes.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/widgets/custom_text_field.dart';

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
                      CustomTextFormField(
                        isRequired: true,
                        hintText: S.of(context).username,
                        iconData: Icons.account_box_rounded,
                        validateFunc: _validateUsername,
                        controller: _usernameController,
                      ),
                      SizedBox(height: 40),
                      //Password
                      CustomTextFormField(
                        isRequired: true,
                        isObscureText: true,
                        hintText: S.of(context).password,
                        iconData: Icons.lock_rounded,
                        validateFunc: _validatePassword,
                        controller: _passwordController,
                      ),
                      SizedBox(height: 40),
                      //Password Repeat
                      CustomTextFormField(
                        isRequired: true,
                        isObscureText: true,
                        hintText: S.of(context).repeat_password,
                        iconData: Icons.lock_rounded,
                        validateFunc: _validatePasswordRepeat,
                        controller: _passwordRepeatController,
                      ),
                      Expanded(child: Container()),
                      //Button
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
                        onTap: () => Navigator.pushNamed(
                            context, RouteGenerator.homePage),
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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    super.dispose();
  }
}
