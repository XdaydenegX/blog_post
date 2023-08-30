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
                ),
              ],
            ),
            Text("My posts (пока нет)", style: TextStyle(fontSize: 22)),
          ],
        )
    );
  }
}