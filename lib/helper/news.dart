import 'package:news_app/models/article.dart';
import 'package:news_app/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants.dart';

class News {
  List<Article> news = [];

  Future getNews({String? category}) async {
    String kDailyhuntEndpoint =
        'https://reward-api.newming.io/v2/api/interest/recent/news?size=50';
    String kinshortsEndpoint =
        'https://reward-api.newming.io/v2/api/interest/recent/news?size=50';

    http.Client client = http.Client();
    http.Response response = await client.get(Uri.parse(kinshortsEndpoint));

    if (response.statusCode == 200) {
      print(response.statusCode);
      var jsonData = jsonDecode(response.body);


      if (jsonData.length > 0) {
        jsonData.forEach((element) {

          if (
              element['title'] != "")  {
            Article articleModel = Article(
              publishedDate: element['date'].toString(),
              publishedTime: element['time'].toString(),
              image: element['thumbnail'] == "" ? kAllImage :element['thumbnail'] ,
              thumbnail:element['thumbnail'] == "" ? kAllImage :element['thumbnail'] ,
              content: element['content'].toString(),
              fullArticle: element['title'].toString(),
              title: element['title'].toString(),
              press_nm: element['press_id'].toString(),
              press_id : element['press_id'],
              uid: element['_key'],
              type: element['type'].toString(),
              published_at: element['published_at'].toString(),
              tags: element['tags'].toString(),

            );
            news.add(articleModel);
          }
        });
      } else {
        print('ERROR');
      }
    }
  }
}
