import 'package:news_app/constants.dart';
import 'package:news_app/models/category_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
Future<List<CategoryModel>> getCategories()  async {

  String kinshortsEndpoint =
      'https://reward-api.newming.io/v2/api/ming/relation/my/16919';

  http.Client client = http.Client();
  http.Response response = await client.get(Uri.parse(kinshortsEndpoint));

  List<CategoryModel> myCategories = [];



  if (response.statusCode == 200) {
    var jsonData = jsonDecode(response.body);

    CategoryModel categoryModel;
    if (jsonData.length > 0) {
      jsonData.forEach((element) {
        categoryModel = new CategoryModel();
        categoryModel.categoryName = element["name"].toString();
        categoryModel.imageAssetUrl = element["cover_image"] == "" ? kAllImage : element["cover_image"]   ;
        categoryModel.category = element["name"].toString();
        myCategories.add(categoryModel);
      });
    }
  }




  return myCategories;
}
