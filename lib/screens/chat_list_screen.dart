import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: stream from Firestore chats/{chatId} where participants contains me.
    final chats = [
      {'name': 'Sana Ahmed · O+', 'msg': 'On my way to donate, 20 min'},
      {'name': 'Hamza Tariq · O-', 'msg': 'Which hospital are you at?'},
      {'name': 'Admin — Blogs', 'msg': 'New article: Benefits of donating'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, i) {
          final c = chats[i];
          return ListTile(
            leading: const CircleAvatar(backgroundColor: AppColors.trustSoft),
            title: Text(c['name']!, style: AppTextStyles.body(size: 12.5, w: FontWeight.w700, color: AppColors.ink)),
            subtitle: Text(c['msg']!, style: AppTextStyles.body(size: 11)),
            onTap: () => Navigator.pushNamed(context, '/chat-thread'),
          );
        },
      ),
    );
  }
}
