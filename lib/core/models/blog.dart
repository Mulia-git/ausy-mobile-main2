import 'package:html/parser.dart';
import 'package:intl/intl.dart';

class Blog {
  final int id;
  final String slug;
  final String url;
  final String image;
  final String title;
  final String excerpt;
  final String date;
  final List<String> categories;

  Blog({
    required this.id,
    required this.slug,
    required this.url,
    required this.image,
    required this.title,
    required this.excerpt,
    required this.date,
    required this.categories,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      slug: json['slug'],
      url: json['link'],
      image: json['_embedded']?['wp:featuredmedia']?[0]?['source_url'] ?? '',
      title: json['title']['rendered'],
      excerpt: _removeHtmlTags(json['excerpt']['rendered']),
      date: _formatDate(json['date']), // Getting post date
      categories: _getCategories(json['_embedded']?['wp:term']),
    );
  }
  static String _removeHtmlTags(String htmlString) {
    return parse(htmlString).body?.text ?? '';
  }

  static List<String> _getCategories(dynamic categoriesData) {
    if (categoriesData == null || categoriesData.isEmpty) return [];
    return categoriesData[0]
        .map<String>((cat) => cat['name'].toString())
        .toList();
  }
   static String _formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('d MMM y').format(parsedDate); // Example: 16 Feb 2025
    } catch (e) {
      return date; // Fallback in case of error
    }
  }
}
