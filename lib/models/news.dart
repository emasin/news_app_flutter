class Article {
  final String title,
      author,
      category,
      content,
      tags,
      featuredImage,
      authorPhoto,
      uid;
  final int views;
  final DateTime time;

  Article({
    required this.uid,
    required this.title,
    required this.author,
    required this.authorPhoto,
    required this.category,
    required this.content,
    required this.tags,
    required this.featuredImage,
    required this.views,
    required this.time,
  });
}

