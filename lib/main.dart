import 'package:blog_post/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';

void main() {
  runApp(BlogPost());
}

class BlogPost extends StatefulWidget {
  @override
  _BlogPostState createState() => _BlogPostState();
}

class _BlogPostState extends State<BlogPost> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlogPost',
      theme: ThemeData(),
      home: FutureBuilder(
          future: checkTokenExists(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              bool tokenExists = snapshot.data!;
              if (tokenExists) {
                return HomePage();
              } else {
                return SignInPage();
              }
            } else {
              return HomePage();
            }
          }),
    );
  }

  Future<bool> checkTokenExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('accessToken');
  }
}