import 'package:blog_post/pages/signin_page.dart';
import 'package:blog_post/storage/local_save_token.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';
import 'package:provider/provider.dart';
import '../storage/change_notifier.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AuthProvider(),
    child: BlogPost(),
  ),);
}

class BlogPost extends StatefulWidget {
  final authProvider = AuthProvider();

  @override
  _BlogPostState createState() => _BlogPostState();
}

class _BlogPostState extends State<BlogPost> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'BlogPost',
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.token == null) {
              return SignInPage();
            } else {
              return HomePage();
            }
          },
        ),
      ),
    );
  }

  // Future<Widget> checkToken() async {
  //   String? token = LocalSaveToken.getAccessToken().toString();
  //
  //   if (token != null) {
  //     return HomePage();
  //   } else {
  //     return SignInPage();
  //   }
  // }
}