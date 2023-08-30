import 'package:blog_post/pages/home_page.dart';
import 'package:flutter/material.dart';
import '../storage/change_notifier.dart';
import 'package:provider/provider.dart';

final _switchuserinfoformkey = GlobalKey<FormState>();

class ProfilePage extends StatefulWidget {

  ProfilePage({Key, key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  String _name = '';
  String _email = '';
  String name = "";
  String email = "";

  fetchUserInfo() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    name = await authProvider.getUsername();
    email = await authProvider.getEmail();
  }

  @override 
  Widget build(BuildContext context) {
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
            key: _switchuserinfoformkey,
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
                    onSaved: (value) {
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пустое поле!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Сменить email'),
                    onSaved: (value) {
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
                    if (_switchuserinfoformkey.currentState!.validate()) {
                      _switchuserinfoformkey.currentState!.save();
                      setState(() {
                        print("name: ${name}\n\nemail: ${email}");
                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Success')));
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
        ],
      ),
    );
  }
}