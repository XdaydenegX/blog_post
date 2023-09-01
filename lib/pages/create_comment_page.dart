import 'package:flutter/material.dart';
import '../pages/comment_page.dart';
import '../storage/change_notifier.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateCommentPage extends StatefulWidget {
  var postId;
  var posttitle;
  var author;
  CreateCommentPage(this.postId, this.author, this.posttitle);
  @override
  _CreateCommentState createState() => _CreateCommentState();
}

class _CreateCommentState extends State<CreateCommentPage> {
  final _createcommentform = GlobalKey();
  var token;
  var text;

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

  createComments() async {
    http.Response response = await http.post(
        Uri.parse("https://blogpost.rfld.ru/api/posts/${widget.postId}/comment?text=${text.toString()}"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        });
    final res = jsonDecode(response.body);
    if (res['success']) {
      print(' +++++ response: ${res['response']} +++++ ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создание комментария'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Ваш код для обработки события возвращения назад
            // Например, показать диалоговое окно подтверждения
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Вы уверены?'),
                  content: Text('Вы хотите закрыть приложение?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Нет'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Да'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _createcommentform,
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Комментарий к посту: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400
                          ),),
                        Text('${widget.posttitle}', style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),)
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                          children: <Widget>[
                            Text('Автор комментария: ${widget.author}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400
                              ),),
                          ],
                        ),
                    SizedBox(height: 20,),
                    SizedBox(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пустое поле!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Комментарий',
                          focusColor: Colors.pinkAccent,
                        ),
                        maxLines: null,
                        onChanged: (value) {
                          text = value.toString();
                        },
                      ),
                    ),
                    SizedBox(height: 30,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.pinkAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          createComments();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CommentPage(widget.posttitle.toString(), widget.postId.toString())));
                        });
                      },
                      child: Text(
                        'Создать комментарий',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}