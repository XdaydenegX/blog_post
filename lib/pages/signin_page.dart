import 'package:blog_post/pages/home_page.dart';
import 'package:blog_post/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import '../storage/user_security_storage.dart';
import 'package:http/http.dart' as http;
import '../storage/local_save_token.dart';
import 'dart:convert';
import '../storage/change_notifier.dart';
import 'package:provider/provider.dart';

final _loginformkey = GlobalKey<FormState>();

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var email;
  var password;
  var data;


  loginUser(String email, String password) async {
    var bodydata = {
      "email": email,
      "password": password,
    };
    var _body = jsonEncode(bodydata).toString();
    http.Response response = await http.post(
        Uri.parse("https://blogpost.rfld.ru/api/user/login"),
        body: _body,
        headers: {
          "Content-Type": "application/json",
        });
    final res = jsonDecode(response.body);
    print(res);
    if (res['success'] == true) {
      AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.saveToken(res['response']['token'].toString());
      await authProvider.saveUsername(res['response']['data']['name']);
      await authProvider.saveEmail(res['response']['data']['email']);
      var token = await authProvider.getAccessToken();
      print(res['response']);
      print("token: ${token}");
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _loginformkey,
              child: Column(
                children: [
                  Image.asset('assets/images/blog_post_logo.png'),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Вход',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      validator: (value) =>
                          EmailValidator.validate(value.toString())
                              ? null
                              : "Введите корректный email",
                      decoration: InputDecoration(
                        labelText: 'Введите email',
                      ),
                      onSaved: (value) {
                        email = value.toString();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пустое поле!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Введите пароль'),
                      obscureText: true,
                      onSaved: (value) {
                        password = value.toString();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.pinkAccent,
                    ),
                    onPressed: () {
                      if (_loginformkey.currentState!.validate()) {
                        _loginformkey.currentState!.save();
                        setState(() async {
                          bool response = await loginUser(email, password);
                          if (response) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Success')));
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error')));
                          }
                        });
                      }
                    },
                    child: Text(
                      'Войти',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                child: Text(
                  'Регистрация',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ))
          ],
        )));
  }
}
