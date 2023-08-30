import 'package:blog_post/pages/post_detail_page.dart';
import 'package:blog_post/pages/signin_page.dart';
import 'package:flutter/material.dart';
import '../storage/change_notifier.dart';
import '../storage/local_save_token.dart';
import '../storage/user_security_storage.dart';
import '../pages/profile_page.dart';
import '../pages/notification_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widget/post_view_widget.dart';
import 'package:provider/provider.dart';
import '../storage/change_notifier.dart';
import '../widget/my_posts_widget.dart';

class HomePage extends StatefulWidget {

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  var myposts;
  var mypostscount;
  var posts;
  var postsCount;
  var username = 'Гость';

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  getName() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    username = await authProvider.getUsername();
  }

  void test() {
    print('component is mount');
  }

  @override
  void initState() {
    super.initState();
    refreshList();
    test();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
    return null;
  }



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
      print(posts[3]);
    }
  }

  deleteToken() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.removeToken();
  }

  @override
  Widget build(BuildContext context) {
    getName();
    return
      Scaffold(
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
                      FutureBuilder(future: getName(), builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Text(username,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500
                            ),
                          );
                        } else
                          return Text('Пользователь...');
                      }),
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
                ButtonWidget('Удалить аккаунт', () => null),
                ButtonWidget('Выйти из аккаунта', () => {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Вы точно хотите выйти из аккаунта?'),
                        content: Text('Если вы выйдете из аккаунта, вам прийдется заного вводить данные при входе в приложение.'),
                        actions: [
                          TextButton(onPressed: () => {Navigator.pop(context)}, child: Text('Отмена')),
                          TextButton(onPressed: () => {
                            deleteToken(),
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage())),

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
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: refreshList,
        child: Column(
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
                          FutureBuilder(future: getPosts(), builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return ListView.builder(
                                  addAutomaticKeepAlives: true,
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
                              );
                            }
                            else {return CircularProgressIndicator();}
                          }),
                          ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: postsCount,
                              itemBuilder: (BuildContext context, int index) {
                                return FutureBuilder(
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
                                      print(postsCount);
                                      return PostViewWidget(posts[index]['name'], posts[index]['author']['name'], posts[index]['created_at'], posts[index]['id']);
                                    }
                                  },
                                );
                              }
                          ),

                          // содержимое второго таба
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),

      // Column(
      //     children: <Widget>[
      //       SizedBox(height: 20,),
      //       SizedBox(
      //         width: 350,
      //         child: TextFormField(
      //           decoration: const InputDecoration(
      //             labelText: "Поиск постов",
      //             hintText: "Поиск постов",
      //             prefixIcon: Icon(Icons.search),
      //           ),
      //         ),
      //       ),
      //       SizedBox(height: 20,),
      //       Expanded(
      //           child: DefaultTabController(
      //             length: 2,
      //             child: Column(
      //               children: [
      //                 TabBar(
      //                   unselectedLabelColor: Colors.blue,
      //                   indicatorColor: Colors.pinkAccent,
      //                   labelColor: Colors.pinkAccent,
      //                   tabs: [
      //                     Tab(
      //                       text: 'Посты',
      //                     ),
      //                     Tab(
      //                       text: 'Мои посты',
      //                     ),
      //                   ],
      //                 ),
      //                 Expanded(
      //                   child: TabBarView(
      //                     children: [
      //                       FutureBuilder(future: getPosts(), builder: (context, snapshot) {
      //                         if (snapshot.connectionState == ConnectionState.done) {
      //                           return ListView.builder(
      //                               padding: const EdgeInsets.all(8),
      //                               itemCount: postsCount,
      //                               itemBuilder: (BuildContext context, int index) {
      //                                 return Container(
      //                                   child: FutureBuilder(
      //                                     future: getPosts(),
      //                                     builder: (context, snapshot) {
      //                                       if (snapshot.connectionState == ConnectionState.waiting) {
      //                                         return SizedBox(
      //                                           height: 370,
      //                                           child: CircularProgressIndicator(
      //                                             backgroundColor: Colors.blue[200],
      //                                             valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
      //                                           ),
      //                                         );
      //                                       }
      //                                       else {
      //                                         return PostViewWidget(posts[index]['name'] + "${postsCount} ${index}", posts[index]['author']['name'], posts[index]['created_at'], posts[index]['id']);
      //                                       }
      //                                     },
      //                                   ),
      //                                 );
      //                                 // PostViewWidget(posts[index]['name'], posts[index]['author']['name'], posts[index]['created_at']);
      //                               }
      //                           );
      //                         }
      //                         else {return CircularProgressIndicator();}
      //                       }),
      //                       ListView.builder(
      //                           padding: const EdgeInsets.all(8),
      //                           itemCount: postsCount,
      //                           itemBuilder: (BuildContext context, int index) {
      //                             return FutureBuilder(
      //                               future: getPosts(),
      //                               builder: (context, snapshot) {
      //                                 if (snapshot.connectionState == ConnectionState.waiting) {
      //                                   return SizedBox(
      //                                     height: 370,
      //                                     child: CircularProgressIndicator(
      //                                       backgroundColor: Colors.blue[200],
      //                                       valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
      //                                     ),
      //                                   );
      //                                 }
      //                                 else {
      //                                   print(postsCount);
      //                                   return PostViewWidget(posts[index]['name'] +  "${postsCount} ${index}", posts[index]['author']['name'] + "${postsCount}", posts[index]['created_at'], posts[index]['id']);
      //                                 }
      //                               },
      //                             );
      //                           }
      //                         ),
      //
      //                       // содержимое второго таба
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //       )
      //     ],
      //   ),
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