import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_hour_tracker/data/repo/user_repo.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/routes.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/utils/session_manager.dart';
import 'package:work_hour_tracker/widgets/app_button.dart';
import 'package:work_hour_tracker/widgets/app_text_field.dart';
import 'package:work_hour_tracker/widgets/app_toast.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

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
                        // image: DecorationImage(
                        //   image: AssetImage('chronometer.png'),
                        //   fit: BoxFit.none,
                        //   scale: 1.5,
                        //   alignment: Alignment.topCenter,
                        //   colorFilter: ColorFilter.mode(
                        //     Color(0xFFF5F3F4),
                        //     BlendMode.color,
                        //   ),
                        // ),
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
                                AppTextFormField(
                                  hintText: S.of(context).username,
                                  controller: _usernameController,
                                  validateFunc: (val) => '',
                                  onSubmitFunc: _login,
                                  isObscureText: false,
                                ),
                                SizedBox(height: 20),
                                AppTextFormField(
                                  hintText: S.of(context).password,
                                  controller: _passwordController,
                                  validateFunc: (val) => '',
                                  onSubmitFunc: _login,
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

  Widget divider() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
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
      ),
    );
  }

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username == null || username == '') {
      AppToast.error(context, S.of(context).invalid_username);
      return;
    }

    if (password == null || password == '') {
      AppToast.error(context, S.of(context).invalid_password);
      return;
    }

    await UserRepository.getUser(username).then((user) {
      if (user != null) {
        if (password == user.password) {
          SessionManager.write(SessionKey.userId, user.id);
          SessionManager.write(SessionKey.username, user.username);

          Navigator.pushNamed(context, RouteGenerator.homePage);
        } else {
          AppToast.error(context, S.of(context).wrong_password);
          return;
        }
      } else {
        AppToast.error(context, S.of(context).user_not_found);
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
