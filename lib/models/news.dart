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
  int content_type = 1;
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
    required this.content_type
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        uid: json['content_uid'] == null ? '' : json['content_uid'],
        title:  json['title'] == null ? '' : json['title'],
        time: json['published_at'] == null ? null : DateTime.parse(json['published_at']),
        featuredImage:  json['image'] == null ? '' : json['image'],
        views: 0, content: '', category: '',
        author:  json['user_nm'] == null ? '' : json['user_nm'],
        tags: '', authorPhoto: '',
        content_type:  json['content_type'] == null ? 0 : json['content_type'],

    );
  }
}

