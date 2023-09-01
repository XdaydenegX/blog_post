import 'package:flutter/material.dart';

class MyPostsWidget extends StatefulWidget {
  var title;
  var authorName;
  var CreateAt;
  var dataID;
  MyPostsWidget(this.title, this.authorName, this.CreateAt, this.dataID);

  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPostsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
              ],
            ),
            Text("My posts (пока нет)", style: TextStyle(fontSize: 22)),
          ],
        )
    );
  }
}