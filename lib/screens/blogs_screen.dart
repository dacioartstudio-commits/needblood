import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BlogsScreen extends StatelessWidget {
  const BlogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: stream from Firestore blogs collection, ordered by publishedAt desc.
    final posts = [
      {'tag': 'Health', 'title': '5 Things to Know Before Donating', 'excerpt': "Don't donate on an empty stomach, stay hydrated..."},
      {'tag': 'Myths', 'title': 'Does Donating Blood Make You Weak?', 'excerpt': 'Answering the most common myths...'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Blogs')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (context, i) {
          final p = posts[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1E4E5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.rose, AppColors.trustSoft]),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(10),
                  child: Chip(label: Text(p['tag']!, style: AppTextStyles.mono(size: 9, color: AppColors.bloodDeep)), backgroundColor: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p['title']!, style: AppTextStyles.display(size: 16)),
                      const SizedBox(height: 3),
                      Text(p['excerpt']!, style: AppTextStyles.body(size: 11)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
