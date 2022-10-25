import 'package:meta/meta.dart';

@immutable
class Article implements Comparable<Article> {
  const Article({
    required this.id,
    required this.uri,
    required this.title,
    required this.excerpt,
    required this.published,
    required this.author,
    required this.blog,
    required this.android,
    required this.ios,
  });

  final String id;
  final String uri;
  final String title;
  final String excerpt;
  final DateTime published;
  final String author;
  final String blog;
  final String android;
  final String ios;

  factory Article.fromJson(Map<String, Object?> json) => Article(
        id: json['id']! as String,
        uri: json['uri']! as String,
        title: json['title']! as String,
        excerpt: json['excerpt']! as String,
        published: DateTime.parse(json['published']! as String).toUtc(),
        author: json['author']! as String,
        blog: json['blog']! as String,
        android: json['android']! as String,
        ios: json['ios']! as String,
      );

  Map<String, Object?> toJson() => <String, Object?>{
        'id': id,
        'uri': uri,
        'title': title,
        'excerpt': excerpt,
        'published': published.toUtc().toIso8601String(),
        'author': author,
        'blog': blog,
        'android': android,
        'ios': ios,
      };

  Article copyWith({
    String? id,
    String? uri,
    String? title,
    String? excerpt,
    DateTime? published,
    String? author,
    String? blog,
    String? android,
    String? ios,
  }) =>
      Article(
        id: id ?? this.id,
        uri: uri ?? this.uri,
        title: title ?? this.title,
        excerpt: excerpt ?? this.excerpt,
        published: published ?? this.published,
        author: author ?? this.author,
        blog: blog ?? this.blog,
        android: android ?? this.android,
        ios: ios ?? this.ios,
      );

  @override
  String toString() => (StringBuffer('Article(')
        ..write('id: $id, ')
        ..write('uri: $uri, ')
        ..write('title: $title, ')
        ..write('excerpt: $excerpt, ')
        ..write('published: ${published.toIso8601String()}, ')
        ..write('author: $author, ')
        ..write('blog: $blog, ')
        ..write('android: $android, ')
        ..write('ios: $ios')
        ..write(')'))
      .toString();

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Article && other.id == id);

  @override
  int compareTo(Article other) => published.compareTo(other.published);
}
