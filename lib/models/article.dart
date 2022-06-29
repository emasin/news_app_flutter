class Article {
  String uid;
  int press_id;
  String press_nm;
  String thumbnail;
  String published_at;
  String tags;
  String title;
  String image;
  String content;
  String publishedTime;
  String publishedDate;
  String fullArticle;
  String type;
  bool hasStory;

  Article(
      {required this.content,
      required this.fullArticle,
      required this.image,
      required this.publishedDate,
      required this.publishedTime,
      required this.title,
      required this.press_id,
      required this.press_nm,
      required this.published_at,
      required this.tags,
      required this.thumbnail,
      required this.type,
      required this.uid,
      required this.hasStory});
}
