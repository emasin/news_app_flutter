import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/models/news.dart';
import 'package:news_app/screens/image_screen.dart';
import 'package:transition/transition.dart';
import 'package:timeago/timeago.dart' as timego;
import '../screens/article-page.dart';

class NewsTile extends StatelessWidget {
  final String image, title, content, date, fullArticle,tags,uid;
  final bool hasStory;
  NewsTile({
    required this.uid,
    required this.content,
    required this.date,
    required this.image,
    required this.title,
    required this.fullArticle,
    required this.tags,
    required this.hasStory
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6))),
      margin: EdgeInsets.only(bottom: 24),
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(6),
            bottomLeft: Radius.circular(6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Hero(
                  tag: 'image-$image',
                  child: Stack(children: [
                    CachedNetworkImage(
                      alignment: Alignment.center,
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      imageUrl: image == "" ? kNewsImage : image,
                      placeholder: (context, url) => Image(
                        image: AssetImage('images/dotted-placeholder.jpg'),
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                   hasStory ? Positioned(child: Icon(Icons.interests_outlined,size: 30,color: Colors.orangeAccent,),left: 0,) : SizedBox()
                  ],),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageScreen(
                      imageUrl: image,
                      headline: title,
                    ),
                  ),
                );
              },
            ),
            GestureDetector(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 6,
                    ),

                    Text(timego.format(
                      DateTime.parse(date),
                      locale: 'en',
                    ),
                        style: TextStyle(color: Colors.grey, fontSize: 12.0))
                  ],
                ),
              ),
              onTap: () {

                Navigator.push(
                  context,
                  Transition(
                    child: ArticlePage(article:new Article(uid:uid,title: title, author: 'author', authorPhoto: 'https://images.unsplash.com/photo-1501196354995-cbb51c65aaea?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80', category: 'Health', content: content, tags: tags, featuredImage: image, views: 10, time: DateTime.parse(date))),//ArticleScreen(articleUrl: fullArticle),
                    transitionEffect: TransitionEffect.LEFT_TO_RIGHT,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
