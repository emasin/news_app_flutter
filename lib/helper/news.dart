import 'package:news_app/models/article.dart';
import 'package:news_app/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class News {
  List<Article> news = [];

  Future getNews({String? category}) async {
    String kDailyhuntEndpoint =
        'https://reward-api.staging.newming.io/v2/api/interest/recent/news';
    String kinshortsEndpoint =
        'https://reward-api.staging.newming.io/v2/api/interest/recent/news';

    http.Client client = http.Client();
    http.Response response = await client.get(Uri.parse(kinshortsEndpoint));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);


      if (jsonData.length > 0) {
        jsonData.forEach((element) {

          if (
              element['title'] != "")  {
            Article articleModel = Article(
              publishedDate: element['date'].toString(),
              publishedTime: element['time'].toString(),
              image: element['thumbnail'].toString().replaceAll(".staging", ""),
              thumbnail: element['thumbnail'].toString().replaceAll(".staging", ""),
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
