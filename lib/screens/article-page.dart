import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:news_app/components/action_card.dart';
import 'package:news_app/components/news_tile.dart';
import 'package:news_app/models/news.dart';
import 'package:news_app/models/Paragraph.dart';
import 'package:news_app/data/example_data.dart' as Example;
import 'package:news_app/provider/count_provider.dart';
import 'package:timeago/timeago.dart' as timego;
import 'package:news_app/paltte.dart';

import 'package:hive/hive.dart';
import 'package:news_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_stack/image_stack.dart';
import '../constants.dart';
import '../models/ContributionAction.dart';

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
  bool isLoading = false;

  Future<List<Paragraph>>? _contentList;
  Future<List<ContributionAction>>? _actionList;
  List<Article> _articleList = [];
  final ScrollController? scrollController =  ScrollController();
  late List<ContributionAction> _list = [];



  Future<void> _launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw 'Could not launch $url';
    }
  }

  _actionRequest({required String hash_key,required String content_hash_str,required int contribution_type,required String contribution_action_val }) async {
    String url = '${baseUrl}/v2/api/contribution/action';

    http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String> {
        'hash_key': hash_key,
        'content_hash_str': content_hash_str,
        'contribution_type': contribution_type.toString(),
        'contribution_action_val': contribution_action_val,
      },
    );
    myController.clear();
    late SnackBar snackBar = SnackBar(
        content: Text(
          response.statusCode.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red);


    if (response.statusCode == 200 || response.statusCode == 201) {
      snackBar = SnackBar(
          content: Text(
            response.statusCode.toString(),
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green);
    }

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    _fetch2();
  }

  Future<String>? searchResult;

  Future<List<Article>> _fetch4(keyword) async {


    var url = '${searchUrl}/v2/api/search?keyword=' +
        keyword;

    String result = 'loading.. $url';

    List<Article> l = [];
    try {
      isLoading = true;
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == HttpStatus.ok) {

        var jsonData = jsonDecode(
            response
                .body);

        if(jsonData.length > 0) {
          setState(() {
            _articleList.clear() ;
          });
        }
        for (var o in jsonData) {
          Article p = Article
              .fromJson(
              o);

            _articleList.add(p);


          Provider.of<Counter>(context,listen:false).set(_articleList.length);
        }


        return l;

      } else {
        print('Something went wrong! ');
      }
    } catch (exception){
      print('exception $exception');

    } finally {
      isLoading = false;
    }
    return [];

  }


  Future<List<Article>> _fetch3(keyword) async {

    if(isLoading)
      return [];

    var url = '${baseUrl}/v2/api/interest/prime/news/search/' +
        keyword;

    String result = 'loading.. $url';

    List<Article> list = [];
    try {
      isLoading = true;
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == HttpStatus.ok) {
        var jsonData = jsonDecode(response.body);
        print(jsonData);
        for(var  o in jsonData){
          Article p = Article.fromJson(o);
          list.add(p);
        }


        //result = jsonData[0]["content"];

      } else {
        print('Something went wrong! ');
      }
    } catch (exception){
      print(url + " " + exception.toString());
      list = [];
      return list;
    } finally {
      isLoading = false;
    }

    return list;
  }


  Future<List<ContributionAction>> _fetch2() async {


    var url = '${baseUrl}/v2/api/contribution/action/history/' +
        widget.article.uid;


    String result = 'loading.. $url';

    List<ContributionAction> list = [];
    try {

      var response = await http.get(Uri.parse(url));
      if (response.statusCode == HttpStatus.ok) {
        var jsonData = jsonDecode(response.body);

        for(var  o in jsonData["actions"]){
          ContributionAction p = ContributionAction.fromJson(o);

          list.add(p);
          //_list.add(p);
        }

      } else {
        print('Something went wrong! ');
      }
      setState(() {

        this._list = list;
      });

    } catch (exception){
      print(url + " " + exception.toString());
      list = [];
      return list;
    } finally {

    }

    return list;
  }

  Future<List<Paragraph>> _fetch1() async {

    if(isLoading)
      return [];

    var url = '${baseUrl}/v2/api/interest/recent/news/' +
        widget.article.uid;

    String result = 'loading.. $url';

    List<Paragraph> list = [];
    try {
      isLoading = true;
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == HttpStatus.ok) {
        var jsonData = jsonDecode(response.body);

        for(var  o in jsonData){
          Paragraph p = Paragraph.fromJson(o);
          list.add(p);
        }


        //result = jsonData[0]["content"];

      } else {
        print('Something went wrong! ');
      }
    } catch (exception){
      print(url + " " + exception.toString());
      list = [];
      return list;
    } finally {
      isLoading = false;
    }

    return list;
  }



  void _articleRelated(String uid,String related_uid,String hash,int content_type) async {


    String kinshortsEndpoint =
        content_type == 1 ? 'https://news-api.newming.io/v1/articles/${related_uid}/link' : 'https://api.newming.io/v1/posts/${related_uid}/link?link=/share/post/${related_uid}';

    http.Client client = http.Client();
    http.Response response = await client.get(Uri.parse(kinshortsEndpoint));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var text = '${jsonData["data"]["link"]}';
      _actionRequest(hash_key: uid, content_hash_str: hash, contribution_type: 7, contribution_action_val: text);
    }

  }


  void _articleShare(String uid,String title,String hash) async {

    String kinshortsEndpoint =
        'https://news-api.newming.io/v1/articles/${uid}/link';
    http.Client client = http.Client();
    http.Response response = await client.get(Uri.parse(kinshortsEndpoint));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var text = '${title} ${jsonData["data"]["link"]}';
      await Share.shareWithResult(text, subject: title).then((value){
        print("shareWithResult ${ value.status}");
        _actionRequest(hash_key: uid, content_hash_str: hash, contribution_type: 6, contribution_action_val: title);});
    }

  }


  String tags = "";
  static const int kTabletBreakpoint = 600;

  List<String> images = <String>[
    "https://ca.slack-edge.com/T02SL6R7CTD-U02SNG073UL-76516cc14607-512",
    "https://ca.slack-edge.com/T02SL6R7CTD-U02SL790AKC-5b748b8c4408-512",
    "https://ca.slack-edge.com/T02SL6R7CTD-U02SDGTEE86-d691acf9ecc7-512",
    "https://ca.slack-edge.com/T02SL6R7CTD-U02S5JPUPRD-a74a7d864ab6-512",
   ];



  @override
  void initState() {
    super.initState();
    _contentList  = _fetch1();
    _actionList = _fetch2();

    setState(() {
      for(var t in widget.article.tags.split(',').map((v)=>'#${v} ')){
        tags += t;
      }
    });

    _actionList?.then((val) {
      _list = val;
    }).catchError((error) {
      // error가 해당 에러를 출력
      print('error: $error');
    });



    myController.addListener(_printLatestValue);
    articleController.addListener(searchArticle);
    getTheme();
  }

  void _printLatestValue() {
    print('Second text field: ${myController.text}');
  }

  void searchArticle() async{
    print('Second text field: ${articleController.text}');
    if(articleController.text.length > 1) {

        await _fetch4(articleController.text);


        
    }

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

  _onEmojiSelected(Emoji emoji,String hash) {

    Navigator.pop(context, "This string will be passed back to the parent",);

    _actionRequest(hash_key: widget.article.uid, contribution_action_val: emoji.emoji, contribution_type: 1, content_hash_str: hash);
  }

  _onBackspacePressed() {

  }
  final myController = TextEditingController();
  final articleController = TextEditingController();
  final _formKey=GlobalKey<FormState>();
  final focus = FocusNode();
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    scrollController?.dispose();
    myController.dispose();
    articleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    Size size = MediaQuery.of(context).size;
    bool _menuVisible = false;
    var shortestSide = size.shortestSide;
    return PieCanvas(
      theme: PieTheme(overlayColor:themeProvider.themeMode().backgroundColor,

      ),
        onMenuToggle: (displaying) {
          setState(() => _menuVisible = displaying);
        },
        child: Scaffold(
          backgroundColor: themeProvider.themeMode().toggleBackgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                collapsedHeight: 260,
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

                        ),
                      ),
                    ),
                    Transform.translate(
                      offset:  Offset(
                        0,
                        (size.height * 2) / 30,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
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
                                  tags,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[

                                      GestureDetector(
                                          onTap:()=>{
                                            showSnackBar("이 기사를 함께 보고 있는 사람들",context)
                                          },
                                          child:ImageStack(
                                        imageList: images,
                                        imageRadius: 25,
                                        imageCount: 5,
                                        imageBorderWidth: 1,
                                        totalCount: images.length,
                                        backgroundColor: Colors.white70,
                                        imageBorderColor: Colors.orangeAccent,
                                        extraCountBorderColor: Colors.black,
                                      )),
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
                                          widget.article.time!,
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
                                  child:  GestureDetector(
                                    onTap:()=>{
                                      showSnackBar("이 기사의 활동 히스토리 ",context)
                                    },
                                    child: Row(
                                        children: [
                                          Icon(
                                            Icons.edit_note,
                                            color: Colors.grey.shade400,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "${_list.length}",
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

                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Column(
                                    children: [

                                      FutureBuilder<List<Paragraph>>(
                                        future: _contentList,
                                        builder: (context, snapshot) {
                                          List<String?>? paragraphs2 = [];
                                          List<Paragraph>? paragraphs3 = [];
                                          if (snapshot.hasData) {

                                            paragraphs3  = snapshot.data;




                                            for(var p in paragraphs3!){
                                              p.children?.clear();
                                              for(var a in _list!){
                                                if(p.hash == a.content_hash_str){
                                                  //print(a);
                                                  p.children?.add(a);
                                                }
                                              }
                                            }


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

    return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) {
                                                              return Container(
                                                                height: 400,
                                                                color: Colors
                                                                    .amber,
                                                                child: Center(
                                                                  child: Offstage(
                                                                    offstage: emojiShowing,
                                                                    child: SizedBox(
                                                                      height: 400,
                                                                      child: EmojiPicker(
                                                                          onEmojiSelected: (Category? category, Emoji emoji) {
                                                                            _onEmojiSelected(emoji,paragraphs3![index]!.hash);
                                                                          },
                                                                          onBackspacePressed: _onBackspacePressed,
                                                                          config: Config(
                                                                              columns: 10,
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
                                                              );});
                                                            },
                                                          )
                                                        },
                                                        buttonTheme:
                                                            PieButtonTheme(
                                                          backgroundColor:
                                                              Colors
                                                                  .yellow[700], iconColor: null,
                                                        ),
                                                      ),
                                                      PieAction(
                                                        tooltip: 'Youtube',
                                                        child: const Icon(
                                                            Icons.play_circle_outline),
                                                        onSelect: () => {



                                                          showModalBottomSheet<
                                                              void>(
                                                            isScrollControlled:true,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                            context) {
                                                              return Padding(
                                                                  padding: MediaQuery.of(context).viewInsets,
                                                                  child:Container(
                                                                height: 300,
                                                                color: baseColor,
                                                                child: Center(
                                                                  child: Center(

                                                                      child:  Form(
                                                                          key: _formKey,
                                                                          child: Column(
                                                                            children: [
                                                                              Padding(padding: EdgeInsets.symmetric(vertical:5,horizontal:5),
                                                                              child:TextFormField(
                                                                                  validator: (value){
                                                                                    if(value!.isEmpty){
                                                                                      return '입력해주세요';
                                                                                    }else{
                                                                                      return null;
                                                                                    }
                                                                                  },

                                                                                  keyboardType: TextInputType.url,
                                                                                  controller:myController,
                                                                                  textInputAction: TextInputAction.next,
                                                                                  autofocus: true,

                                                                                  decoration: InputDecoration(
                                                                                    border: OutlineInputBorder(),
                                                                                    labelText: 'Youtube URL',
                                                                                    contentPadding: EdgeInsets.all(10),



                                                                                  )

                                                                              ),
                                                                              ),
                                                                            Padding(padding: EdgeInsets.symmetric(vertical:5,horizontal:5),
                                                                              child:
                                                                              TextFormField(
                                                                                  validator: (value){
                                                                                    if(value!.isEmpty ){
                                                                                      return '입력해주세요';
                                                                                    }else{
                                                                                      return null;
                                                                                    }
                                                                                  },

                                                                                  focusNode: focus,

                                                                                  enableInteractiveSelection:true,
                                                                                  maxLines:2,
                                                                                  maxLength: 100,
                                                                                  decoration: InputDecoration(
                                                                                    border: OutlineInputBorder(),
                                                                                    labelText: 'Description',
                                                                                  )
                                                                              )),

                                                                              Center(child:Padding(padding: EdgeInsets.symmetric(vertical:5,horizontal:5),
                                                                                  child:ElevatedButton(style: ElevatedButton.styleFrom(
                                                                                    // background color

                                                                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                                                                    textStyle: const TextStyle(fontSize: 20),
                                                                                    primary:themeProvider
                                                                                      .themeMode()
                                                                                      .toggleBackgroundColor
                                                                                  ),
                                                                                onPressed: (){
                                                                                  _actionRequest(hash_key: widget.article.uid, contribution_action_val: myController.text, contribution_type: 2, content_hash_str:paragraphs3![index]!.hash );
                                                                                  Navigator.pop(context, "This string will be passed back to the parent",);
                                                                                },
                                                                                child: Text("Submit",style: TextStyle(color: themeProvider
                                                                                    .themeMode()
                                                                                    .textColor),),
                                                                              )))
                                                                            ],
                                                                          ))),
                                                                ),
                                                              ));
                                                            },
                                                          )
                                                        },
                                                        buttonTheme:
                                                        PieButtonTheme(
                                                          backgroundColor:
                                                          Colors
                                                              .red[700], iconColor: null,
                                                        ),
                                                      ),
                                                      PieAction(
                                                        tooltip: '!가장중요한',
                                                        child: const Icon(
                                                            Icons.notification_important),
                                                        onSelect: () =>
                                                            _actionRequest(hash_key: widget.article.uid, contribution_action_val: '', contribution_type: 3, content_hash_str:paragraphs3![index]!.hash ),
                                                        buttonTheme:
                                                        PieButtonTheme(
                                                          backgroundColor:
                                                          Colors
                                                              .red[400], iconColor: null,
                                                        ),
                                                      ),
                                                      /**PieAction(
                                                        tooltip: 'Flag Issue',
                                                        child: const Icon(
                                                            Icons.flag),
                                                        onSelect: ()  {



                                                          showModalBottomSheet<
                                                              void>(
                                                            isScrollControlled:true,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                            context) {
                                                              return Padding(
                                                                  padding: MediaQuery.of(context).viewInsets,
                                                                  child:Container(
                                                                    height: 300,
                                                                    color: baseColor,
                                                                    child: Center(
                                                                      child: Center(

                                                                          child:  Form(
                                                                              key: _formKey,
                                                                              child: Column(
                                                                                children: [

                                                                                  Padding(padding: EdgeInsets.symmetric(vertical:5,horizontal:5),
                                                                                      child:
                                                                                      TextFormField(
                                                                                          validator: (value){
                                                                                            if(value!.isEmpty ){
                                                                                              return '입력해주세요';
                                                                                            }else{
                                                                                              return null;
                                                                                            }
                                                                                          },

                                                                                          focusNode: focus,

                                                                                          enableInteractiveSelection:true,
                                                                                          maxLines:3,
                                                                                          maxLength: 100,
                                                                                          decoration: InputDecoration(
                                                                                            border: OutlineInputBorder(),
                                                                                            labelText: '토론내용',
                                                                                          )
                                                                                      )),

                                                                                  Center(child:Padding(padding: EdgeInsets.symmetric(vertical:5,horizontal:5),
                                                                                      child:ElevatedButton(style: ElevatedButton.styleFrom(
                                                                                        // background color

                                                                                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                                                                          textStyle: const TextStyle(fontSize: 20),
                                                                                          primary:themeProvider
                                                                                              .themeMode()
                                                                                              .toggleBackgroundColor
                                                                                      ),
                                                                                        onPressed: (){
                                                                                          _actionRequest(hash_key: widget.article.uid, contribution_action_val: myController.text, contribution_type: 2, content_hash_str:paragraphs3![index]!.hash );
                                                                                          Navigator.pop(context, "This string will be passed back to the parent",);
                                                                                        },
                                                                                        child: Text("토론생성",style: TextStyle(color: themeProvider
                                                                                            .themeMode()
                                                                                            .textColor),),
                                                                                      )))
                                                                                ],
                                                                              ))),
                                                                    ),
                                                                  ));
                                                            },
                                                          );
                                                        },
                                                        buttonTheme:
                                                        PieButtonTheme(
                                                          backgroundColor:
                                                          Colors
                                                              .orange[700],
                                                        ),
                                                      ), **/
                                                      PieAction(
                                                        tooltip: '뉴밍 콘텐츠(뉴스/토론/투표) 검색',
                                                        child: const Icon(
                                                            Icons.newspaper),
                                                        onSelect: ()
                                                        {

                                                          
                                                          String content_hash_str = paragraphs3![index]!.hash;
                                                          showModalBottomSheet<
                                                              void>(
                                                            isScrollControlled: true,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                            context) {
                                                                  return StatefulBuilder(
                                                                      builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {


                                                              return Container(
                                                                  padding: MediaQuery
                                                                      .of(
                                                                      context)
                                                                      .viewInsets,
                                                                  child: Container(
                                                                    height: 400,
                                                                    color: baseColor,
                                                                    child: Center(
                                                                      child: Center(

                                                                          child: Form(
                                                                              key: _formKey,
                                                                              child: Column(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: EdgeInsets
                                                                                        .symmetric(
                                                                                        vertical: 5,
                                                                                        horizontal: 5),
                                                                                    child: TextFormField(
                                                                                        validator: (
                                                                                            value) {
                                                                                          if (value!
                                                                                              .isEmpty) {
                                                                                            return '입력해주세요';
                                                                                          } else {
                                                                                            return null;
                                                                                          }
                                                                                        },


                                                                                        controller: articleController,

                                                                                        autofocus: true,

                                                                                        decoration: InputDecoration(
                                                                                          border: OutlineInputBorder(),
                                                                                          labelText: '콘텐츠 검색',
                                                                                          contentPadding: EdgeInsets
                                                                                              .all(
                                                                                              10),


                                                                                        )

                                                                                    ),
                                                                                  ),


                                                                                  Expanded(
                                                                                      child:
                                                                                      ListView
                                                                                          .builder(
                                                                                        controller:scrollController,

                                                                                          itemCount: Provider.of<Counter>(context,listen:false).count,
                                                                                          shrinkWrap: true,
                                                                                          physics: ScrollPhysics(),

                                                                                          itemBuilder: (
                                                                                              BuildContext context,
                                                                                              int i) {
                                                                                            //print(i);
                                                                                            return GestureDetector(
                                                                                              onTap: () {



                                                                                                _articleRelated(widget.article.uid,_articleList[i]!.uid,content_hash_str,_articleList[i]!.content_type);

                                                                                                Navigator
                                                                                                    .pop(
                                                                                                  context,
                                                                                                  "This string will be passed back to the parent",);
                                                                                              },
                                                                                              child: Padding(
                                                                                                padding: EdgeInsets
                                                                                                    .symmetric(
                                                                                                    vertical: 5,
                                                                                                    horizontal: 5),
                                                                                                child: Row(
                                                                                                  children: [
                                                                                                    CachedNetworkImage(
                                                                                                      alignment: Alignment
                                                                                                          .center,
                                                                                                      height: 50,
                                                                                                      width: 50,
                                                                                                      fit: BoxFit
                                                                                                          .cover,
                                                                                                      imageUrl: _articleList[i]!
                                                                                                          .featuredImage ==
                                                                                                          ""
                                                                                                          ? _articleList[i]!
                                                                                                          .content_type == 1  ? kNewsImage : kNewmingLogoImage
                                                                                                          : _articleList[i]!
                                                                                                          .featuredImage,
                                                                                                      errorWidget: (
                                                                                                          context,
                                                                                                          url,
                                                                                                          error) =>
                                                                                                          Image
                                                                                                              .network(
                                                                                                              kNewsImage),
                                                                                                      placeholder: (
                                                                                                          context,
                                                                                                          url) =>
                                                                                                          Image(
                                                                                                            image: AssetImage(
                                                                                                                'images/dotted-placeholder.jpg'),
                                                                                                            height: 50,
                                                                                                            width: 50,
                                                                                                            fit: BoxFit
                                                                                                                .cover,
                                                                                                          ),
                                                                                                    ),
                                                                                                    SizedBox(
                                                                                                      width: 5,),
                                                                                                    Flexible(child: Column(
                                                                                                      crossAxisAlignment: CrossAxisAlignment
                                                                                                          .start,
                                                                                                      mainAxisSize: MainAxisSize
                                                                                                          .min,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                            _articleList[i]!
                                                                                                                .title,
                                                                                                            overflow: TextOverflow.ellipsis,
                                                                                                            style: TextStyle(
                                                                                                              color: themeProvider
                                                                                                                  .themeMode()
                                                                                                                  .textColor,
                                                                                                              fontSize: 14,)),
                                                                                                        SizedBox(height: 5,),
                                                                                                        Text(
                                                                                                            _articleList[i]!
                                                                                                                .time
                                                                                                                .toString(),
                                                                                                            style: TextStyle(
                                                                                                              color: themeProvider
                                                                                                                  .themeMode()
                                                                                                                  .imageDescTextColor,
                                                                                                              fontSize: 12,))
                                                                                                      ],

                                                                                                    )),SizedBox(
                                                                                                      width: 5,)

                                                                                                  ],),),)


                                                                                            ;
                                                                                          }
                                                                                      ))


                                                                                ],
                                                                              ))),
                                                                    ),
                                                                  ));})


                                                              ;
                                                            },
                                                          );
                                                        },
                                                        buttonTheme:
                                                        PieButtonTheme(
                                                          backgroundColor:
                                                          Colors
                                                              .grey[700], iconColor: null,
                                                        ),
                                                      ),
                                                      /**PieAction(
                                                        tooltip: 'Photos & Files',
                                                        child: const Icon(
                                                            Icons.attach_file),
                                                        onSelect: () =>
                                                            showSnackBar(
                                                                'Attach #$index',
                                                                context),
                                                      ),**/
                                                      PieAction(
                                                        tooltip: 'Share',
                                                        child: const Icon(
                                                            Icons.share),
                                                        onSelect: () {
                                                          _articleShare(
                                                              widget.article
                                                                  .uid,
                                                              paragraphs3![index]!.text,
                                                            paragraphs3![index]!.hash,
                                                          );
                                                        }
                                                      ),
                                                    ],
                                                    child: GestureDetector(

                                                        onTap: (){
                                                          /**
                                                         if(paragraphs3![index].children!.length > 0){
                                                           Iterable<ContributionAction> a = paragraphs3![index].children!.where((v)=> v.contribution_type == 2);

                                                            if(a.length > 0) {
                                                              _launchInWebViewOrVC(Uri.parse(a.first.contribution_action_val));
                                                            }
                                                         }
                                                              **/

                                                        },
                                                        child:Stack(children: [ Container(
                                                            padding: EdgeInsets.only(bottom: paragraphs3![index].children!.length > 0 ?30:0 ,top: paragraphs3![index].children!.length > 0 &&  paragraphs3![index].children![0].contribution_type == 3  ? 30 : 0),
                                                            decoration:BoxDecoration(
                                                          border: Border.all(
                                                            width: 0,
                                                            color: paragraphs3![index].children!.length > 0 &&  paragraphs3![index].children![0].contribution_type == 3   ?  Color(0xFFFF1744) : Colors.transparent,

                                                          ),


                                                        ),
                                                        child:paragraphs3![index].type  == 'photo' ? Center(child: Column(children: [
                                                          HtmlWidget(
                                                            '<img src="${paragraphs3![index].src}" style="width:100%">',
                                                            textStyle: TextStyle(
                                                                color: themeProvider
                                                                    .themeMode()
                                                                    .textColor,
                                                                fontSize: 16),
                                                          )
                                                          ,Text('${paragraphs3![index].desc}',style: TextStyle(color: themeProvider
                                                              .themeMode()
                                                              .imageDescTextColor,fontSize: 16))
                                                        ],)) : SelectableText(paragraphs3![index].text.replaceAll( RegExp(
                                                                                                                      r"<[^>]*>",
                                                                                                                      multiLine: true,
                                                                                                                      caseSensitive: true
                                                                                                                    ), ''),
                                                        style: TextStyle(fontSize: shortestSide < kTabletBreakpoint  ?  18.0: 18.0),
                                                          onSelectionChanged: (selection, cause) {

                                                          },
                                                        )/** Html(


                                                          data:  '<p>${paragraphs3![index].text}</p>',
                                                        style: { "p": Style(
                                                          fontSize: shortestSide < kTabletBreakpoint  ?  FontSize(18.0): FontSize.xLarge,
                                                        ),}

                                                        )**/,) ,  SizedBox(height:10),
                                                          paragraphs3![index].children!.length > 0 ? Positioned(child:
                                                          ActionCard(paragraphs3![index].children)

                                                            ,right: 5,bottom: -5,) :
                                                              SizedBox()
                                                    ])
                                                    ),
                                                  ));
                                            },
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                            onHorizontalDragEnd: (DragEndDetails details) {/**
                              if (details.primaryVelocity! > 0) {
                                // User swiped Left
                                print('left');
                              } else if (details.primaryVelocity! < 0) {
                                // User swiped Right
                                print('right');
                                Navigator.pop(context);
                              }**/
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

_showSnackBar(String s) {
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
