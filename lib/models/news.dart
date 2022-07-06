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
  final DateTime? time;

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

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        uid: json['_key'] == null ? '' : json['_key'],
        title:  json['title'] == null ? '' : json['title'],
        time: json['published_at'] == null ? null : DateTime.parse(json['published_at']),
        featuredImage:  json['thumbnail'] == null ? '' : json['thumbnail'], views: 0, content: '', category: '', author: '', tags: '', authorPhoto: '',

    );
  }
}

