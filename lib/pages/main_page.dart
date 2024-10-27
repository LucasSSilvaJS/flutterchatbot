import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sistemaintegrado/components/Chatbot.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Container(
        child: Text("User not found"),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Chatbot no Flutter"),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
              tooltip: "Logout",
            )
          ],
        ),
        body: const Chatbot());
  }

  _logout() {
    FirebaseAuth.instance.signOut().then((result) {
      Navigator.of(context).pushNamedAndRemoveUntil("/login", (_) => false);
    });
  }
}
