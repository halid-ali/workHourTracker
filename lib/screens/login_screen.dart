import 'package:flutter/material.dart';
import 'package:work_hour_tracker/data/bloc/user_bloc.dart';
import 'package:work_hour_tracker/data/model/user_model.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserBloc _userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: StreamBuilder(
              stream: _userBloc.users,
              builder: (context, AsyncSnapshot<List<User>> snapshot) {
                if (!snapshot.hasData) {
                  return Text('No user');
                }

                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var user = snapshot.data[index];
                    return Text(user.username);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
