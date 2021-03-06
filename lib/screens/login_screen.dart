import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_hour_tracker/routes.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: StreamBuilder(
            stream: firestore.collection('users').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error occured');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              var users = snapshot.data.docs;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(15),
                    child: Text(users[index].data()['username']),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
