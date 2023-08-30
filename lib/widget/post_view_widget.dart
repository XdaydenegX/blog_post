import 'package:blog_post/pages/post_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostViewWidget extends StatefulWidget {
  var title;
  var authorName;
  var CreateAt;
  var dataID;
  PostViewWidget(this.title, this.authorName, this.CreateAt, this.dataID);

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostViewWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: 500,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      child: InkWell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 10,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                ClipOval(
                                  child: SizedBox.fromSize(
                                    size: Size.fromRadius(30), // Image radius
                                    child: Image.asset('assets/images/avatar.jpg'),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(widget.authorName, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600))
                              ],
                            ),
                            SizedBox(height: 10,),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox.fromSize(
                                child: Image.asset('assets/images/post_image.jpg'),
                              ),
                            ),
                            Text(widget.title, style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w600)),
                            SizedBox(height: 10,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(DateFormat('dd.MM.yyyy').format(DateTime.parse(widget.CreateAt)).toString(), style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => PostDetailPage(widget.dataID),
                          ));
                        },
                      ),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ))
              ],
            )
        );
  }

  @override
  bool get wantKeepAlive => true;
}