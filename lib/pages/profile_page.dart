import 'package:blog_post/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../storage/change_notifier.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ProfilePage extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  String _name = '';
  String _email = '';
  String name = "";
  String email = "";
  var token;

  final _edituserinfo = GlobalKey<FormState>();

  getToken() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    token = await authProvider.getAccessToken();
    print(token);
  }

  fetchUserInfo() async {
    http.Response response = await http.get(
        Uri.parse("https://blogpost.rfld.ru/api/user"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        });
    final res = jsonDecode(response.body);
    if (res['success']) {
      name = res['response']['name'].toString();
      email = res['response']['email'].toString();
      print("name: ${name}\n\nemail: ${email}");
    }
  }

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getToken();
      fetchUserInfo();
    });
  }


  editUserInfo() async {
    if (token != null) {
      var bodydata = {
        "name": _name,
        "email": _email,
      };
      var _body = jsonEncode(bodydata).toString();
      http.Response response = await http.post(
          Uri.parse("https://blogpost.rfld.ru/api/user/edit"),
          body: _body,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          });
      final res = jsonDecode(response.body);
      if (res['success']) {
        name = res['response']['name'];
        email = res['response']['email'];
      }
      }
    }

  @override 
  Widget build(BuildContext context) {
    getToken();
    fetchUserInfo();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 20,),
            onPressed: () {
              setState(() {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
              });
            },
          ),
          title: Text('На главную'),
          bottom: PreferredSize(
              child: Container(
                color: Colors.blue,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Профиль', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),)
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(100.0)),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(48), // Image radius
                    child: Image.asset('assets/images/avatar.jpg'),
                  ),
                ),
              ),
              FutureBuilder(future: fetchUserInfo(), builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                      Text(email,  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    ],
                  );
                }
                else {
                  return CircularProgressIndicator();
                }
              }),
            ],
          ),
          Form(
            key: _edituserinfo,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Изменить данные',
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пустое поле!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Сменить имя',
                    ),
                    onChanged: (value) {
                      _name = value.toString();
                    },
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
                    decoration: InputDecoration(labelText: 'Сменить email'),
                    onChanged: (value) {
                      _email = value.toString();
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
                      if (_edituserinfo.currentState!.validate()) {
                        _edituserinfo.currentState!.save();
                        setState(() {
                          editUserInfo();
                          print("name: ${_name}\n\nemail: ${_email}");
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Success')));
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error')));
                      }
                    },
                  child: Text(
                    'Изменить данные',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}