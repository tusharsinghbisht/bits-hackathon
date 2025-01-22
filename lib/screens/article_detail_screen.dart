import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  String _getReadingTime() {
    final wordCount = article.content.split(' ').length;
    final minutes = (wordCount / 200).ceil(); // Average reading speed
    return '$minutes min read';
  }

  Future<void> _shareArticle() async {
    try {
      final result = await Share.shareWithResult(
        '${article.title}\n\n${article.content.substring(0, 200)}...\n\nRead more on Health App',
        subject: article.title,
      );
      
      if (result.status == ShareResultStatus.success) {
        print('Share successful');
      }
    } catch (e) {
      print('Error sharing article: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Title Section with Reading Time
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF07569b),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getReadingTime(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Image Section with Gradient
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      Hero(
                        tag: 'article_${article.title}',
                        child: SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: Image.asset(
                            article.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                              Colors.black.withOpacity(0.4),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      article.content,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.8,
                        color: Colors.black87,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Close Button with Elevation
            Positioned(
              top: 16,
              left: 16,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF07569b)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),

            // Share Button
            Positioned(
              top: 16,
              right: 16,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Color(0xFF07569b)),
                    onPressed: _shareArticle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}