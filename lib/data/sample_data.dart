import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/news_article.dart';

Future<List<NewsArticle>> fetchNewsArticles() async {
  final apiKey = dotenv.env['NEWS_API_KEY'];
  final response = await http.get(Uri.parse(
    'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey',
  ));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List articles = data['articles'];

    return articles.map((json) => NewsArticle.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load news');
  }
}