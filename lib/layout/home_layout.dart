import 'package:flutter/material.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text("Excuse Generator", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xffFBF8EF)),),
        backgroundColor: Color(0xffff9800),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Stack(children: [SafeArea(child: child!)]),
      ),
    );
  }
}
// flutter run --no-enable-impeller