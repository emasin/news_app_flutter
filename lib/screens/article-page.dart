import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:news_app/models/news.dart';
import 'package:news_app/data/example_data.dart' as Example;
import 'package:timeago/timeago.dart' as timego;
import 'package:news_app/paltte.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hive/hive.dart';
import 'package:news_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key, required this.article}) : super(key: key);

  final Article article;

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  String? selectedValue;

  Future<String> _fetch1() async {
    var url = 'https://reward-api.newming.io/v2/api/interest/recent/news/' +
        widget.article.uid;

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

  void _articleShare(String uid,String title) async {

    String kinshortsEndpoint =
        'https://news-api.newming.io/v1/articles/${uid}/link';
    http.Client client = http.Client();
    http.Response response = await client.get(Uri.parse(kinshortsEndpoint));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var text = '${title} ${jsonData["data"]["link"]}';
      await Share.share(text, subject: title);
    }




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

  bool emojiShowing = false;

  _onEmojiSelected(Emoji emoji) {

  }

  _onBackspacePressed() {

  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Size size = MediaQuery.of(context).size;
    bool _menuVisible = false;
    return PieCanvas(
        onMenuToggle: (displaying) {
          setState(() => _menuVisible = displaying);
        },
        child: Scaffold(
          backgroundColor: themeProvider.themeMode().toggleBackgroundColor,
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

                          color: themeProvider.themeMode().backgroundColor,
                          image: DecorationImage(
                            image: NetworkImage(widget.article.featuredImage),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
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
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              widget.article.title,
                              style: kBoldHeading.copyWith(
                                color: themeProvider.isLightTheme
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 22,
                                backgroundColor: themeProvider.isLightTheme
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.article.tags,
                                  style: TextStyle(
                                    fontSize: 18,
                                    height: 1.5,
                                    color: themeProvider.isLightTheme
                                        ? Colors.black
                                        : Colors.white,
                                    backgroundColor: themeProvider.isLightTheme
                                        ? Colors.white70
                                        : Colors.black38,
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 8,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                SizedBox(
                                  width: 8,
                                ),
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
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                  ),
                                  child: GestureDetector(

                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.share,
                                            color: Colors.grey.shade400,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "1k",
                                            style: kLabelblack,
                                          ),
                                        ],
                                      )),
                                )
                              ],
                            ),
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
                        child: GestureDetector(
                            child: Column(children: [
                              Container(

                                decoration: BoxDecoration(
                                  color: themeProvider
                                      .themeMode()
                                      .toggleBackgroundColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
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
                                      FutureBuilder<String>(
                                        future: _fetch1(),
                                        builder: (context, snapshot) {
                                          List<String?>? paragraphs2 = [];
                                          List<String?>? paragraphs3 = [];
                                          if (snapshot.hasData) {
                                            //var photos = jsonData[0]["photos"];
                                            String? text = snapshot.data?.replaceAll("%PHOTO%", "%NEW_LINE% %PHOTO% %NEW_LINE%");
                                            paragraphs2 = text
                                                ?.split('%NEW_LINE%');

                                            int photo_index = 0;
                                            paragraphs2?.forEach((element) {
                                              String str = element.toString().trim();
                                              if(str.length > 0){


                                                if(str == '%PHOTO%') {
                                                  print(str.startsWith('%PHOTO'));
                                                  if(photo_index != 0) {
                                                    paragraphs3.add('$element$photo_index');
                                                  }
                                                  photo_index++;
                                                }else {
                                                  paragraphs3.add(element);
                                                }

                                              }
                                            });

                                          } else if (snapshot.hasError) {
                                            print(snapshot.data); // null
                                            print(snapshot
                                                .error); // 에러메세지 ex) 사용자 정보를 확인할 수 없습니다.
                                            return Text("에러 일때 화면");
                                          } else {
                                            return SizedBox(
                                              child:
                                                  CircularProgressIndicator(),
                                              width: 30,
                                              height: 30,
                                            );
                                          }

                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: paragraphs3?.length,
                                            physics: _menuVisible
                                                ? const NeverScrollableScrollPhysics()
                                                : const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: PieMenu(
                                                    actions: [
                                                      PieAction(
                                                        tooltip: 'Like',
                                                        child: const Icon(Icons
                                                            .emoji_emotions_outlined),
                                                        onSelect: () => {
                                                          showModalBottomSheet<
                                                              void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Container(
                                                                height: 250,
                                                                color: Colors
                                                                    .amber,
                                                                child: Center(
                                                                  child: Offstage(
                                                                    offstage: emojiShowing,
                                                                    child: SizedBox(
                                                                      height: 250,
                                                                      child: EmojiPicker(
                                                                          onEmojiSelected: (Category category, Emoji emoji) {
                                                                            _onEmojiSelected(emoji);
                                                                          },
                                                                          onBackspacePressed: _onBackspacePressed,
                                                                          config: Config(
                                                                              columns: 7,
                                                                              // Issue: https://github.com/flutter/flutter/issues/28894
                                                                              emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                                                                              verticalSpacing: 0,
                                                                              horizontalSpacing: 0,
                                                                              gridPadding: EdgeInsets.zero,
                                                                              initCategory: Category.RECENT,
                                                                              bgColor: const Color(0xFFF2F2F2),
                                                                              indicatorColor: Colors.blue,
                                                                              iconColor: Colors.grey,
                                                                              iconColorSelected: Colors.blue,
                                                                              progressIndicatorColor: Colors.blue,
                                                                              backspaceColor: Colors.blue,
                                                                              skinToneDialogBgColor: Colors.white,
                                                                              skinToneIndicatorColor: Colors.grey,
                                                                              enableSkinTones: true,
                                                                              showRecentsTab: true,
                                                                              recentsLimit: 28,
                                                                              replaceEmojiOnLimitExceed: false,
                                                                              noRecents: const Text(
                                                                                'No Recents',
                                                                                style: TextStyle(fontSize: 20, color: Colors.black26),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                              tabIndicatorAnimDuration: kTabScrollDuration,
                                                                              categoryIcons: const CategoryIcons(),
                                                                              buttonMode: ButtonMode.MATERIAL)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        },
                                                        buttonTheme:
                                                            PieButtonTheme(
                                                          backgroundColor:
                                                              Colors
                                                                  .yellow[700],
                                                        ),
                                                      ),
                                                      PieAction(
                                                        tooltip: 'Youtube',
                                                        child: const Icon(
                                                            Icons.play_circle_outline),
                                                        onSelect: () =>
                                                            showSnackBar(
                                                                'Play #$index',
                                                                context),
                                                        buttonTheme:
                                                        PieButtonTheme(
                                                          backgroundColor:
                                                          Colors
                                                              .red[700],
                                                        ),
                                                      ),
                                                      PieAction(
                                                        tooltip: '!가장중요한',
                                                        child: const Icon(
                                                            Icons.flag),
                                                        onSelect: () =>
                                                            showSnackBar(
                                                                'Flag #$index',
                                                                context),
                                                        buttonTheme:
                                                        PieButtonTheme(
                                                          backgroundColor:
                                                          Colors
                                                              .orange[700],
                                                        ),
                                                      ),
                                                      PieAction(
                                                        tooltip: 'Photos & Files',
                                                        child: const Icon(
                                                            Icons.attach_file),
                                                        onSelect: () =>
                                                            showSnackBar(
                                                                'Attach #$index',
                                                                context),
                                                      ),
                                                      PieAction(
                                                        tooltip: 'Share',
                                                        child: const Icon(
                                                            Icons.share),
                                                        onSelect: () {
                                                          _articleShare(
                                                              widget.article
                                                                  .uid,
                                                              paragraphs3![index]
                                                                  .toString());
                                                        }
                                                      ),
                                                    ],
                                                    child: GestureDetector(

                                                        onLongPress: () {

                                                        },
                                                        child: HtmlWidget(
                                                          paragraphs3![index]
                                                              .toString().trim().startsWith('%PHOTO%') ? '<img src="https://lawngtlai.nic.in/wp-content/themes/district-theme-2/images/news.jpg">' : paragraphs3![index]
                                                              .toString(),
                                                          textStyle: TextStyle(
                                                              color: themeProvider
                                                                  .themeMode()
                                                                  .textColor,
                                                              fontSize: 16),
                                                        )),
                                                  ));
                                            },
                                          );
                                        },
                                      ), SizedBox(
                                        height: size.height * 0.1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                            onHorizontalDragEnd: (DragEndDetails details) {
                              if (details.primaryVelocity! > 0) {
                                // User swiped Left
                                print('left');
                              } else if (details.primaryVelocity! < 0) {
                                // User swiped Right
                                print('right');
                                Navigator.pop(context);
                              }
                            })),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [
    like,
    flag,
    youtube,
    album,
  ];
  static const List<MenuItem> secondItems = [cancel];

  static const like =
      MenuItem(text: '이모지', icon: Icons.emoji_emotions_outlined);
  static const flag = MenuItem(text: '가장 중용한!', icon: Icons.flag);
  static const youtube =
      MenuItem(text: 'Youtube', icon: Icons.play_circle_outline);
  static const album =
      MenuItem(text: '첨부', icon: Icons.picture_as_pdf_outlined);
  static const cancel = MenuItem(text: 'Cancel', icon: Icons.cancel);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
          item.icon,
          color: Colors.white,
          size: 22,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.like:
        //Do something

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected value: $item'),
          ),
        );
        break;
      case MenuItems.flag:
        //Do something
        break;
      case MenuItems.youtube:
        //Do something
        break;
      case MenuItems.album:
        //Do something
        break;
      case MenuItems.cancel:
        //Do something
        break;
    }
  }
}
