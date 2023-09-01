import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../pages/create_comment_page.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/change_notifier.dart';
import 'package:intl/intl.dart';



class CommentPage extends StatefulWidget {
  var postDetailTitle;
  var postID;
  CommentPage(this.postDetailTitle, this.postID);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<CommentPage> {
  var token;
  var comments;
  var userinfo;
  // var created_date;
  // var created_time;

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getUser();
      getToken();
    });
  }

  getToken() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    token = await authProvider.getAccessToken();
    print(token);
  }

  getUser() async {
    http.Response response = await http.get(
        Uri.parse("https://blogpost.rfld.ru/api/user"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        });
    final res = jsonDecode(response.body);
    if (res['success']) {
      userinfo = res['response'];
      print(' +++++ response: ${userinfo} +++++ ');
      print(' +++++ datetime now: ${DateTime.now().toString()} +++++ ');
    }
  }


  getComments() async {
    http.Response response = await http.get(
        Uri.parse("https://blogpost.rfld.ru/api/posts/${widget.postID}/comments"),
        headers: {
          "Content-Type": "application/json",
        });
    final res = jsonDecode(response.body);
    if (res['success']) {
      comments = res['response'];
      // created_date = DateFormat('dd.MM.yyyy').format(comments['created_at']);
      // created_time = DateFormat('HH:mm').format(comments['created_at']);
      print(' +++++ response: ${comments['response']} +++++ ');
    }
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    getToken();
    return Scaffold(
          appBar: AppBar(
            leading: BackButton(),
            title: Text(widget.postDetailTitle),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: FutureBuilder(future: getComments(), builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: comments.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: comments[index]['author']['name'].toString() == userinfo['name'] ? Colors.pinkAccent : Colors.blueAccent,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 10.0
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text(comments[index]['author']['name'], style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),),],
                            ),
                          ),
                          Text(comments[index]['text'],
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400)
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 10.0
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  DateTime.parse(comments[index]['created_at']) == DateTime.now()
                                      ? DateFormat('HH:mm').format(DateTime.parse(comments[index]['created_at'])).toString()
                                      : DateFormat('dd.MM.yyyy').format(DateTime.parse(comments[index]['created_at'])).toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.6),
                                      fontWeight: FontWeight.w400),),],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              else {
                return CircularProgressIndicator();
              }
            }),
          ),
      bottomNavigationBar:  SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),

              backgroundColor: Colors.blueAccent,
            ),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateCommentPage(widget.postID, userinfo['name'], widget.postDetailTitle)));
            },
            child: Text(
              'Создать комментарий',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
        ),
      ),
    );
  }
}
