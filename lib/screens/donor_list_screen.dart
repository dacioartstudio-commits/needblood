import 'package:flutter/material.dart';
import '../data/blood_compatibility.dart';
import '../theme/app_theme.dart';
import '../widgets/needblood_button.dart';

class DonorListScreen extends StatelessWidget {
  const DonorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: replace with a live Firestore query (online) or LocalDonorCache
    // read (offline) filtered by BloodCompatibility.compatibleDonorsFor(...).
    const requestedGroup = 'O+';
    final compatible = BloodCompatibility.compatibleDonorsFor(requestedGroup);
    final donors = [
      {'name': 'Hamza Tariq', 'area': 'Jhang Sadr', 'group': 'O-', 'dist': '0.8 km'},
      {'name': 'Sana Ahmed', 'area': 'Jhang Sadr', 'group': 'O+', 'dist': '1.4 km'},
      {'name': 'Bilal Khan', 'area': 'Satellite Town', 'group': 'A+', 'dist': '3.2 km'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Matching Donors')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('Compatible: ${compatible.join(', ')}'), backgroundColor: AppColors.rose),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: donors.length,
              itemBuilder: (context, i) {
                final d = donors[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF1E4E5)),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(backgroundColor: AppColors.trustSoft, radius: 19),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d['name']!, style: AppTextStyles.body(size: 12.5, w: FontWeight.w700, color: AppColors.ink)),
                            Text(d['area']!, style: AppTextStyles.body(size: 10.5)),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.blood, borderRadius: BorderRadius.circular(8)),
                            child: Text(d['group']!, style: AppTextStyles.mono(size: 12, color: Colors.white)),
                          ),
                          const SizedBox(height: 3),
                          Text(d['dist']!, style: AppTextStyles.mono(size: 9)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/chat-thread'),
                    icon: const Icon(Icons.chat_bubble_outline, size: 16),
                    label: const Text('Message'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: NeedBloodButton(
                    label: 'Call',
                    color: AppColors.go,
                    icon: Icons.call,
                    onTap: () => Navigator.pushNamed(context, '/call'),
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
