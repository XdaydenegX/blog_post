import 'package:blog_post/pages/signin_page.dart';
import 'package:blog_post/pages/signup_page.dart';
import 'package:blog_post/storage/local_save_token.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';
import 'pages/signin_page.dart';
import '../storage/user_security_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


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
      theme: ThemeData(
      ),
      home: LocalSaveToken.getAccessToken() != null ? HomePage() : SignInPage(),
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   checkAccessToken();
  // }
  //
  // checkAccessToken() async {
  //   final accessToken = LocalSaveToken.getAccessToken();
  //   if (accessToken != null) {
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
  //   }
  //   else {
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
  //   }
  // }
}

