import 'package:flutter/material.dart';
import 'models/news_article.dart';
import 'data/sample_data.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const NewsHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  List<NewsArticle> _articles = [];
  List<NewsArticle> _filteredArticles = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  void loadNews() async {
    try {
      final fetchedArticles = await fetchNewsArticles();
      setState(() {
        _articles = fetchedArticles;
        _filteredArticles = fetchedArticles;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching news: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterArticles(String query) {
    final results = _articles.where((article) {
      final titleLower = article.title.toLowerCase();
      final descriptionLower = article.description.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) || descriptionLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredArticles = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _articles.isEmpty
          ? const Center(child: Text('No news articles available.'))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _filterArticles,
              decoration: InputDecoration(
                hintText: 'Search articles...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: _filteredArticles.length,
              controller: PageController(viewportFraction: 0.9),
              itemBuilder: (context, index) {
                final article = _filteredArticles[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        article.imageUrl.isNotEmpty
                            ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                          child: Image.network(
                            article.imageUrl,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) =>
                            const Icon(Icons.broken_image, size: 80),
                          ),
                        )
                            : const Icon(Icons.image_not_supported, size: 80),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                article.description,
                                style: const TextStyle(fontSize: 16),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
