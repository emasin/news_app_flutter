import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:news_app/models/news.dart';
import 'package:timeago/timeago.dart' as timego;
import 'package:news_app/paltte.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key, required this.article}) : super(key: key);

  final Article article;

  @override
  _ArticlePageState createState() => _ArticlePageState();


}

class _ArticlePageState extends State<ArticlePage> {

  Future<String> _fetch1() async {



    var url =
        'https://reward-api.staging.newming.io/v2/api/interest/recent/news/' + widget.article.uid;

    String result = 'loading..';
    try {
      var response = await http.get(Uri.parse(url));


      if (response.statusCode == HttpStatus.ok) {

        var jsonData = jsonDecode(response.body);
        result = jsonData[0]["content"];

      } else {
        print('Something went wrong!');
      }
    } catch (exception) {
      return exception.toString();
    }

    return result;

  }


  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            collapsedHeight: size.height * 0.4,
            backgroundColor: Colors.transparent,
            flexibleSpace: Stack(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                  ).createShader(bounds),
                  blendMode: BlendMode.darken,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      image: DecorationImage(
                        image: NetworkImage(widget.article.featuredImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(
                    0,
                    200,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 3.0,
                              sigmaY: 3.0,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Text(
                                widget.article.category,
                                style: kLabelText,
                              ),
                            ),
                          ),
                        ),ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 3.0,
                              sigmaY: 3.0,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Text(
                                widget.article.category,
                                style: kLabelText,
                              ),
                            ),
                          ),
                        )],)
                        ,

                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.article.title,
                          style: kBoldHeading.copyWith(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.article.tags,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.white,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      maxRadius: 16,
                                      backgroundImage: NetworkImage(
                                        widget.article.authorPhoto,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      widget.article.author,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(
                              24,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.watch_later_outlined,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                timego.format(
                                  widget.article.time,
                                  locale: 'en_short',
                                ),
                                style: kLabelblack,
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(height: size.height * 0.9 ,child:Column(children:[ Flexible(child:FutureBuilder<String>(
                      future: _fetch1(),
                      builder: (context, snapshot) {

                        List<String?>? paragraphs2 = [];
                        if (snapshot.hasData) {

                          //var photos = jsonData[0]["photos"];


                          List<String>? paragraphs =  snapshot.data?.split('%NEW_LINE%');

                          paragraphs2 =
                          paragraphs?.map((String p) {
                            if(p != '' && p != 'null') {
                              print(p);
                              return p;
                            }
                          })
                              .toList();



                        } else if (snapshot.hasError) {
                          print(snapshot.data); // null
                          print(snapshot.error); // 에러메세지 ex) 사용자 정보를 확인할 수 없습니다.
                          return Text("에러 일때 화면");
                        } else {
                          return  SizedBox(
                            child: CircularProgressIndicator(),
                            width: 30,
                            height: 30,
                          );
                        }


                        return ListView.builder(
                          itemCount: paragraphs2?.length,
                          itemBuilder: (context, index) {

                            return Text(paragraphs2![index] == null ? "" : paragraphs2![index].toString());
                          },
                        );
                      },
                    ),)]
                    ),)

                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
