import 'package:blog_post/widget/post_detail_widgt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:like_button/like_button.dart';
import '../pages/comment_page.dart';


class PostDetailPage extends StatefulWidget {
  final int postId;
  PostDetailPage(this.postId);


  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetailPage> {
  var postDetail;
  var commentsCount;

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getCommentsCount();
    });
  }

  getPostDetail () async {
    http.Response response = await http.get(
        Uri.parse("https://blogpost.rfld.ru/api/posts/detail/${widget.postId}"),
        headers: {
          "Content-Type": "application/json",
        });
    var res = jsonDecode(response.body);
    if (res['success']) {
      postDetail = res['response'];
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
    getCommentsCount();
    return Scaffold(
      appBar: AppBar(
        title: Text('Назад'),
        actions: [
          LikeButton(size: 20, likeCount: 1020, countPostion: CountPostion.bottom, bubblesSize: 0, circleColor: CircleColor(start: Colors.pinkAccent, end: Colors.pink.shade50),),
          Row(
            children: [
            IconButton(onPressed: () => {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CommentPage(postDetail['name'], widget.postId))),
            }, icon: Icon(Icons.insert_comment, color: Colors.white,)),
            FutureBuilder(future: getCommentsCount(), builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(commentsCount.toString());
              }
              else {
                return CircularProgressIndicator();
              }
            })
            ],)
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