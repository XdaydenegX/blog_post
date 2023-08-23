import 'package:blog_post/pages/signin_page.dart';
import 'package:flutter/material.dart';
import '../storage/local_save_token.dart';
import '../storage/user_security_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';



class HomePage extends StatefulWidget {

  HomePage({Key, key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var test;
  void _testfun() {
    print('hw');
  }

  void testFun() async  {
    var token = await UserSecurityStorage.getToken();
    print(token);
  }

  @override void initState() {
    super.initState();

    testFun();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.cancel_outlined, size: 30, color: Colors.white,),
                onPressed: () {
                  setState(() {
                    LocalSaveToken.deleteAccessToken();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
                  });
                },
              ),
            ],
            title: Text('BlogPost'),
          ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
              ),
              child: Row(
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
                  SizedBox(width: 20,),
                  Column(
                    children: <Widget>[
                      Text('X_daydeneg_X', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(height: 1,),
                ButtonWidget('Профиль'),
                ButtonWidget('Уведомления'),
                ButtonWidget('Удалитть аккаунт'),
                ButtonWidget('ВЫйти из аккаунта'),
                SizedBox(height: 100,),
              ],
            )
          ],
        ),
      ),
      body: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            SizedBox(
              width: 350,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Поиск постов",
                  hintText: "Поиск постов",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        unselectedLabelColor: Colors.blue,
                        indicatorColor: Colors.pinkAccent,
                        labelColor: Colors.pinkAccent,
                        tabs: [
                          Tab(
                            text: 'Посты',
                          ),
                          Tab(
                            text: 'Мои посты',
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: 100,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 400,
                                            width: 500,
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      ClipOval(
                                                        child: SizedBox.fromSize(
                                                          size: Size.fromRadius(30), // Image radius
                                                          child: Image.asset('assets/images/avatar.jpg'),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Text('X_daydeneg_X', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600))
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(20),
                                                    child: SizedBox.fromSize(
                                                      child: Image.asset('assets/images/post_image.jpg'),
                                                    ),
                                                  ),
                                                  Text("Blog Post", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w600)),
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text("14.08.2004", style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w500)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                          ))
                                        ],
                                      )
                                  );
                                }
                            ),
                            // содержимое второго таба
                            ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: 3,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("My posts (пока нет)", style: TextStyle(fontSize: 22)),
                                        ],
                                      )
                                  );
                                }
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            )
          ],
        ),
    );
  }
}

class ButtonWidget extends StatelessWidget{
  final String text;

  ButtonWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),

          backgroundColor: Colors.pinkAccent,
        ),
        onPressed: () {
          null;
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}