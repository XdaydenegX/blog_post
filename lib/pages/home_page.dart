import 'package:blog_post/pages/post_detail_page.dart';
import 'package:blog_post/pages/signin_page.dart';
import 'package:flutter/material.dart';
import '../storage/local_save_token.dart';
import '../storage/user_security_storage.dart';
import '../pages/profile_page.dart';
import '../pages/notification_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widget/post_view_widget.dart';

class HomePage extends StatefulWidget {

  HomePage({Key, key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  var posts;
  var postsCount;
  getPosts() async {
    http.Response response = await http.get(
        Uri.parse("https://blogpost.rfld.ru/api/posts"),
        headers: {
          "Content-Type": "application/json",
        });
    var res = jsonDecode(response.body);
    if (res['success']) {
      posts = res['response'];
      postsCount = posts.length;
      return posts;
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getPosts();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            centerTitle: true,
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
                ButtonWidget('Профиль', () => {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()))}),
                ButtonWidget('Уведомления', () => {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NotificationPage()))}),
                ButtonWidget('Удалитть аккаунт', () => null),
                ButtonWidget('Выйти из аккаунта', () => {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Вы точно хотите выйти из аккаунта?'),
                        content: Text('Если вы выйдете из аккаунта, вам прийдется заного вводить данные при входе в приложение.'),
                        actions: [
                          TextButton(onPressed: () => {Navigator.pop(context)}, child: Text('Отмена')),
                          TextButton(onPressed: () => {
                            LocalSaveToken.deleteAccessToken(),
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()))
                          }, child: Text('Ок')),
                        ],
                      )
                  )
                }),
                // LocalSaveToken.deleteAccessToken()
        // , Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()))
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
                                itemCount: postsCount,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    child: FutureBuilder(
                                      future: getPosts(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return SizedBox(
                                            height: 370,
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.blue[200],
                                              valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                                            ),
                                          );
                                        }
                                        else {
                                          return PostViewWidget(posts[index]['name'], posts[index]['author']['name'], posts[index]['created_at'], posts[index]['id']);
                                        }
                                      },
                                    ),
                                  );
                                    // PostViewWidget(posts[index]['name'], posts[index]['author']['name'], posts[index]['created_at']);
                                }
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Center(
                                    child: Text('Добавить пост', style: TextStyle(color: Colors.white, fontSize: 20),),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue
                                  ),
                                  width: double.infinity,
                                  height: 50,
                                  margin: EdgeInsets.only(
                                    top: 10.0
                                  ),
                                )
                              ],
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
  final Function callBack;

  ButtonWidget(this.text, this.callBack);

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
          callBack();
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