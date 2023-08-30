import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../storage/change_notifier.dart';

class NotificationWidget extends StatefulWidget {
  String notifycationTitle = '';
  String notifycationDesc = '';
  bool confirm = false;
  NotificationWidget(this.notifycationTitle, this.notifycationDesc);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();

}


class _NotificationWidgetState extends State<NotificationWidget> {



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(widget.notifycationTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
              Switch(
                  value: widget.confirm,
                  activeColor: Colors.pinkAccent,
                  onChanged: (value) {
                    setState(() {
                      widget.confirm = value;
                    });
                  }
              ),
            ],
          ),
          Text(widget.notifycationDesc, style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black.withOpacity(0.3),
          ),),
        ],
      ),
    );
  }

}