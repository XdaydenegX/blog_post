import 'package:blog_post/storage/change_notifier.dart';
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../widget/notifycation_widget.dart';
import '../storage/change_notifier.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key, key}) : super(key: key);
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  bool isSwitched = false;

  // changeSwitchState(value) async {
  //   SaveNotify savenotify = Provider.of<SaveNotify>(context);
  //   await savenotify.saveNotify(value);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 20,),
            onPressed: () {
              setState(() {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
              });
            },
          ),
          title: Text('На главную'),
          bottom: PreferredSize(
              child: Container(
                color: Colors.blue,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Уведомления', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),)
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(100.0)),
        ),
      ),
      body: ListView(
        children: <Widget>[
          NotificationWidget('Новый пост', 'уведомление о публикациях новых постов'),
          NotificationWidget('Лайки', 'уведомления о лайке поста пользователя'),
          NotificationWidget('Комментарии', 'Уведомления о новых комментариях поста пользователя'),
        ],
      )
    );
  }
}
