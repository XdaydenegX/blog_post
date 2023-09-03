import 'package:blog_post/widget/post_detail_widgt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:like_button/like_button.dart';
import '../pages/comment_page.dart';
import '../storage/change_notifier.dart';
import 'package:provider/provider.dart';

class PostDetailPage extends StatefulWidget {
  var postId;

  PostDetailPage(this.postId);


  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetailPage> {
  var postDetail;
  var commentsCount;
  var token;
  int likeCount = 0;
  bool likeStatus = false;

  getToken() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    token = await authProvider.getAccessToken();
    print(token);
  }

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getToken();
    });
  }

  likedPost() async {
    http.Response response = await http.post(
        Uri.parse("https://blogpost.rfld.ru/api/posts/${widget.postId}/like"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        });
    var res = await jsonDecode(response.body);
    if (res['success']) {
    }
  }

  getPostLike() async {
    http.Response response = await http.get(
        Uri.parse("https://blogpost.rfld.ru/api/posts/detail/${widget.postId}"),
        headers: {
          "Content-Type": "application/json",
        });
    var res = jsonDecode(response.body);
    if (res['success']) {
      likeCount = res['response']['count_like'];
      likeStatus = res['response']['user_like'];
    }
  }

  getPostDetail() async {
    http.Response response = await http.get(
        Uri.parse("https://blogpost.rfld.ru/api/posts/detail/${widget.postId}"),
        headers: {
          "Content-Type": "application/json",
        });
    var res = jsonDecode(response.body);
    if (res['success']) {
      postDetail = res['response'];
      likeStatus = res['response']['user_like'];
      print(' ++++++ like status: ${likeStatus} ++++++ ');
      print(widget.postId);
      return postDetail;
    }
  }

  getCommentsCount() async {
    http.Response response = await http.get(
        Uri.parse("https://blogpost.rfld.ru/api/posts/${widget.postId}/comments"),
        headers: {
          "Content-Type": "application/json",
        });
    final res = jsonDecode(response.body);
    if (res['success']) {
      commentsCount = res['response'].length;
      print(' +++++ response: $commentsCount +++++ ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Назад'),
        actions: [
          FutureBuilder(future: getPostLike(), builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Row(
                children: [
                  IconButton(onPressed: () => {
                    setState(() {
                      likedPost();
                    })
                  },
                      icon: Icon(FontAwesomeIcons.solidHeart, color: likeStatus ? Colors.pinkAccent : Colors.white,)),
                  Text(likeCount.toString(), style: TextStyle(color: Colors.white, fontSize: 20),),
                ],
              );
            }
            else {
              return CircularProgressIndicator();
            }
          }),
          Row(
            children: [
            IconButton(onPressed: () => {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CommentPage(postDetail['name'], widget.postId))),
            }, icon: Icon(Icons.insert_comment, color: Colors.white,)),
            FutureBuilder(future: getCommentsCount(), builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(commentsCount.toString(), style: TextStyle(fontSize: 20),);
              }
              else {
                return CircularProgressIndicator();
              }
            })
            ],
          )
        ],
      ),
      body: FutureBuilder(
        future: getPostDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ) {
            return Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                  ),

                ),
            );
          }
          else {
            return PostDetailWidget(postDetail);
          }
        },
      ),
    );
  }

}