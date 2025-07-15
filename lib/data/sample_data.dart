import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

Future<List<NewsArticle>> fetchNewsArticles() async {
  final response = await http.get(Uri.parse(
    'https://newsapi.org/v2/top-headlines?country=us&apiKey=81273ed5acd2490797e7bcd281f4c347',
  ));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List articles = data['articles'];

    return articles.map((json) => NewsArticle.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load news');
  }
}
