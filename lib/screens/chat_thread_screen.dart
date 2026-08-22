import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChatThreadScreen extends StatefulWidget {
  const ChatThreadScreen({super.key});

  @override
  State<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  final _msgCtrl = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'from': 'them', 'text': 'Hi, I got your alert for O+'},
    {'from': 'me', 'text': 'Hi! Yes — City Hospital, ICU bed 4'},
    {'from': 'them', 'text': 'On my way, will reach in 20 minutes'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sana Ahmed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: AppColors.go),
            onPressed: () => Navigator.pushNamed(context, '/call'),
            tooltip: 'Audio call',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                final isMe = m['from'] == 'me';
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.blood : AppColors.trustSoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(m['text']!, style: AppTextStyles.body(size: 12.5, color: isMe ? Colors.white : AppColors.ink)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.blood,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: () {
                      if (_msgCtrl.text.trim().isEmpty) return;
                      setState(() {
                        _messages.add({'from': 'me', 'text': _msgCtrl.text.trim()});
                        _msgCtrl.clear();
                      });
                      // TODO: write to Firestore chats/{chatId}/messages
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
