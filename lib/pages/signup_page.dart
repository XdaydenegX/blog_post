import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../storage/user_security_storage.dart';
import 'package:blog_post/pages/signin_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final _registerformkey = GlobalKey<FormState>();

class SignUpPage extends StatefulWidget {
  SignUpPage({Key, key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  String? name;
  String? email;
  String? password;
  String? repeat_password;

  registerUser(String name, String email, String password) async {
    var bodydata = {
      "login": name,
      "email": email,
      "password": password,
    };
    var _body = jsonEncode(bodydata.toString());
    http.Response response = await http.post(Uri.parse("http://127.0.0.1:8000/api/user/register"),
      body: _body,
      headers: {
        "Content-Type": "application/json",
      }
    );
    final res = jsonDecode(response.body);

    if (res['success']) {
      UserSecurityStorage.setUserEmail(email);
      final userEmail = await UserSecurityStorage.getEmail();
      print(userEmail);
      Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: _registerformkey,
                  child: Column(
                    children: [
                      Image.asset('assets/images/blog_post_logo.png'),
                      SizedBox(height: 20,),
                      Text('Регистрация', textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 20,),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          maxLength: 20,
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Пустое поле";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Придумайте имя',
                          ),
                          onSaved: (value) {
                            name = value.toString();
                          },
                        ),
                      ),
                      SizedBox(height: 10,),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          validator: (value) => EmailValidator.validate(value.toString()) ? null : "Введите корректный email",
                          decoration: InputDecoration(
                              labelText: 'Введите email'
                          ),
                          onSaved: (value) {
                            email = value.toString();
                          },
                        ),
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
                          decoration: InputDecoration(
                              labelText: 'Введите пароль'
                          ),
                          obscureText: true,
                          onSaved: (value) {
                            password = value.toString();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пустое поле!';
                            }
                            if (value != password) {
                              return "Пароли не совпадают";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Повтор пароля'
                          ),
                          obscureText: true,
                          onSaved: (value) {
                            repeat_password = value.toString();
                          },
                        ),
                      ),
                      SizedBox(height: 40,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),

                          backgroundColor: Colors.pinkAccent,
                        ),
                        onPressed: () {
                          if (_registerformkey.currentState!.validate()) {
                            _registerformkey.currentState!.save();
                            // data = registerUser(name, email, password);
                            // registerUser(name, email, password);

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Success'))
                            );
                          }
                        },
                        child: Text(
                          'Зарегистрироваться',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100,),
                TextButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));
                }, child: Text('Уже есть аккаунт?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),))
              ],
            )
        )
    );
  }
}