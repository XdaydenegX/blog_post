import 'package:flutter/material.dart';

class CreateCommentPage extends StatefulWidget {
  @override
  _CreateCommentState createState() => _CreateCommentState();
}

class _CreateCommentState extends State<CreateCommentPage> {
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
      body: TextField(

      ),
    );
  }
}