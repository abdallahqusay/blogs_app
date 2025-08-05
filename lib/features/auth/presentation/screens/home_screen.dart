
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
    static route() => MaterialPageRoute(builder: (context) => HomeScreen());
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Text("boda"),
      ),
    );
  }
}