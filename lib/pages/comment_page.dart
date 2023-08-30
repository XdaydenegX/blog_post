import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../pages/create_comment_page.dart';

class CommentPage extends StatefulWidget {
  final String postDetailTitle;
  CommentPage(this.postDetailTitle);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<CommentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            leading: BackButton(),
            title: Text(widget.postDetailTitle),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: index !=7 ? Colors.blueAccent : Colors.pinkAccent,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            bottom: 10.0
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('User1377', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),),],
                        ),
                      ),
                      Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400)
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 10.0
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Text('DD.MM.YYYY', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w400),),],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            items: [
              IconButton(onPressed: () => {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateCommentPage())),
              }, icon: Icon(FontAwesomeIcons.plus, color: Colors.white,))
            ],
            backgroundColor: Colors.white.withOpacity(1),
            color: Colors.pinkAccent,
            buttonBackgroundColor: Colors.pinkAccent,

          ),
        );
  }
}
