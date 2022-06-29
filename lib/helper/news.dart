import 'package:news_app/models/article.dart';
import 'package:news_app/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants.dart';

class News {
  List<Article> news = [];

  Future getNews({String? category, required int page}) async {
    print(category);

    if(page ==0 )
      page = 1;

    String kDailyhuntEndpoint =
        '${baseUrl}/v2/api/interest/recent/news?size=50&page=${page}&type=${category}';
    String kinshortsEndpoint =
        '${baseUrl}/v2/api/interest/recent/news?size=50&page=${page}';




    http.Client client = http.Client();
    http.Response response = await client.get(Uri.parse(category == 0 ? kinshortsEndpoint : kDailyhuntEndpoint));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);


      if (jsonData.length > 0) {
        jsonData.forEach((element) {

          if (
              element['title'] != "")  {
            Article articleModel = Article(
              publishedDate: element['date'].toString(),
              publishedTime: element['time'].toString(),
              image: element['thumbnail'] == "" ? kNewsImage :element['thumbnail'] ,
              thumbnail:element['thumbnail'] == "" ? kNewsImage :element['thumbnail'] ,
              content: element['content'].toString(),
              fullArticle: element['title'].toString(),
              title: element['title'].toString(),
              press_nm: element['press_id'].toString(),
              press_id : element['press_id'],
              uid: element['_key'],
              type: element['type'].toString(),
              published_at: element['published_at'].toString(),
              tags: element['tags'].toString(),
              hasStory: element['hasStory'] == "" ||  element['hasStory'] == null  ? false : true

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
