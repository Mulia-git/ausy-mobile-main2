import 'package:html/parser.dart';
import 'package:intl/intl.dart';

class Blog {
  final int id;
  final String slug;
  final String title;
  final String image;
  final String excerpt;
  final String content;
  final String date;

  Blog({
    required this.id,
    required this.slug,
    required this.title,
    required this.image,
    required this.excerpt,
    required this.content,
    required this.date,
  });

  factory Blog.fromApi(Map<String, dynamic> json) {
    String imageUrl = json['cover_photo'] ?? '';

    if (!imageUrl.startsWith('http') && imageUrl.isNotEmpty) {
      imageUrl =
      "https://apam.rsaurasyifa.com/uploads/news/$imageUrl";
    }

    final rawContent = json['content'] ?? '';

    return Blog(
      id: int.tryParse(json['id'].toString()) ?? 0,
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      image: imageUrl,
      excerpt: _removeHtml(json['intro'] ?? ''),
      content: _removeHtml(rawContent),
      date: json['tanggal'] ?? '',
    );
  }

  static String _removeHtml(String htmlString) {
    final document = parse(htmlString);
    return document.body?.text
        .replaceAll('\n', ' ')
        .replaceAll('\r', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim() ??
        '';
  }
  String get shortContent {
    final text = excerpt.isNotEmpty ? excerpt : content;
    if (text.length > 120) {
      return "${text.substring(0, 120)}...";
    }
    return text;
  }

}
