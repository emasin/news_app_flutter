import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:news_app/models/news.dart';
import 'package:timeago/timeago.dart' as timego;
import 'package:news_app/paltte.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hive/hive.dart';
import 'package:news_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';
class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key, required this.article}) : super(key: key);

  final Article article;

  @override
  _ArticlePageState createState() => _ArticlePageState();


}

class _ArticlePageState extends State<ArticlePage> {

  Future<String> _fetch1() async {



    var url =
        'https://reward-api.newming.io/v2/api/interest/recent/news/' + widget.article.uid;

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
    getTheme();

  }

  Icon themeIcon = Icon(Icons.dark_mode);
  bool isLightTheme = false;

  Color baseColor = Colors.grey[300]!;
  Color highlightColor = Colors.grey[100]!;


  getTheme() async {
    final settings = await Hive.openBox('settings');
    setState(() {
      isLightTheme = settings.get('isLightTheme') ?? false;
      baseColor = isLightTheme ? Colors.grey[300]! : Color(0xff2c2c2c);
      highlightColor = isLightTheme ? Colors.grey[100]! : Color(0xff373737);
      themeIcon = isLightTheme ? Icon(Icons.dark_mode) : Icon(Icons.light_mode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: themeProvider.themeMode().backgroundColor,
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
                    100,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.article.title,
                          style: kBoldHeading.copyWith(
                            color: themeProvider.isLightTheme ? Colors.black : Colors.white,
                            fontSize: 22, backgroundColor: themeProvider.isLightTheme ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(children: [
                          Text(
                            widget.article.tags,
                            style: TextStyle(
                                fontSize: 18,
                                height: 1.5,
                                color: themeProvider.isLightTheme ? Colors.black : Colors.white,
                                backgroundColor: themeProvider.isLightTheme ? Colors.white70 : Colors.black38,
                            ),
                          ),
                          Spacer(),
                          SizedBox(width: 8,),

                        ],),
                        SizedBox(
                          height: 20,
                        ),
                        Row(children: [

                          Spacer(),
                          SizedBox(width: 8,),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(
                                12,
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
                          )
                        ],)

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [

                SingleChildScrollView(

                    child: GestureDetector(child: Column(children:[
                      Container(

                        decoration: BoxDecoration(
                          color: themeProvider.themeMode().toggleBackgroundColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
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
                                children: [],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FutureBuilder<String>(
                                future: _fetch1(),
                                builder: (context, snapshot) {

                                  List<String?>? paragraphs2 = [];
                                  if (snapshot.hasData) {

                                    //var photos = jsonData[0]["photos"];

                                    paragraphs2 =  snapshot.data?.split('%NEW_LINE%');
/**
                                    paragraphs2 =
                                        paragraphs?.map((String p) {
                                          if(p != '' && p != 'null') {
                                            print(p);
                                            return p;
                                          }
                                        })
                                            .toList();


**/
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
                                    shrinkWrap: true,
                                    itemCount: paragraphs2?.length,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {

                                      return Padding(padding: const EdgeInsets.symmetric(vertical: 5),child: HtmlWidget( paragraphs2![index].toString(),textStyle: TextStyle(color:themeProvider.themeMode().textColor,fontSize: 16),), );
                                    },
                                  );
                                },
                              )

                            ],
                          ),
                        ),
                      ),

                    ]), onHorizontalDragEnd: (DragEndDetails details) {
                      if (details.primaryVelocity! > 0) {
                        // User swiped Left
                        print('left');
                      } else if (details.primaryVelocity! < 0) {
                        // User swiped Right
                        print('right');
                        Navigator.pop(
                            context);
                      }
                    })

                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
