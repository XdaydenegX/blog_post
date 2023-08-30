import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostDetailWidget extends StatefulWidget {
  var postDetaildata;
  PostDetailWidget(this.postDetaildata);

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text(widget.postDetaildata['name'].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Создатель поста: ', style: TextStyle(fontSize: 16),),
                      SizedBox(width: 10,),
                      Text(widget.postDetaildata['author']['name'].toString(), style: TextStyle(fontSize: 16),),
                      SizedBox(width: 5,),
                      ClipOval(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(20), // Image radius
                          child: Image.asset('assets/images/avatar.jpg'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Время создания ', style: TextStyle(fontSize: 16),),
                        SizedBox(width: 10,),
                        Text(DateFormat('dd.MM.yyyy').format(DateTime.parse(widget.postDetaildata['created_at'])).toString(), style: TextStyle(fontSize: 16),),
                      ]
                  ),
                  SizedBox(height: 10,),
                  Divider(
                    height: 2,
                    color: Colors.pinkAccent,
                  ),
                  SizedBox(height: 20,),
                  Text(widget.postDetaildata['text'].toString(), style: TextStyle(fontSize: 16),),
                ],
              )
            ],
          )
        ),
      ],
    );
  }
}