import 'package:flutter/material.dart';
import 'widgets/urlboi.dart';
import 'package:url_boi/locator.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URL-Boi : URL Shortner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("URL-Boi : URL Shortner"),
        ),
        body: GestureDetector (
          child: Container(
            child: UrlBoi(),
            height: double.infinity,
          ),
          onTap: (){
            FocusScope.of(context).unfocus();
          },
        ),
      ),
    );
  }
}
