import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../screens/login.dart';
import '../services/auth.dart';
import '../widgets/square_loading.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().user,
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.uid == null) {
              return const Login();
            } else {
              return const Home();
            }
          }
          return const Scaffold(body: SquareLoading());
        });
  }
}
