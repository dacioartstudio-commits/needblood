import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../theme/app_theme.dart';
import '../widgets/blood_drop.dart';
import '../widgets/needblood_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TODO: replace with the signed-in user's real profile (Provider/Riverpod).
  final String myBloodGroup = 'O+';
  final String myCity = 'Jhang Sadr';
  bool _online = true;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() => _online = result != ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                children: [
                  Row(children: [const BloodDrop(size: 15), const SizedBox(width: 6), Text('NeedBlood', style: AppTextStyles.display(size: 20))]),
                  const Spacer(),
                  Row(
                    children: [
                      Container(width: 7, height: 7, decoration: BoxDecoration(color: _online ? AppColors.go : AppColors.offline, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text(_online ? 'ONLINE' : 'OFFLINE · SMS mode', style: AppTextStyles.mono(size: 9, color: _online ? AppColors.goDeep : AppColors.offline)),
                    ],
                  ),
                  const SizedBox(width: 10),
                  const CircleAvatar(backgroundColor: AppColors.rose, radius: 16),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [Color(0xFFE85C71), AppColors.blood]),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(myCity.toUpperCase(), style: AppTextStyles.display(size: 12, color: Colors.white.withOpacity(0.85))),
                          Text('Nearby\nDonors', textAlign: TextAlign.center, style: AppTextStyles.display(size: 22, color: Colors.white)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text('Your group is $myBloodGroup. In an emergency, matching donors get notified instantly.',
                        textAlign: TextAlign.center, style: AppTextStyles.body(size: 12)),
                    const SizedBox(height: 20),
                    NeedBloodButton(
                      label: 'Need Blood',
                      color: AppColors.go,
                      icon: Icons.notifications_active,
                      onTap: () => Navigator.pushNamed(context, '/request'),
                    ),
                  ],
                ),
              ),
            ),
            _BottomNav(),
          ],
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF1E4E5)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: const Icon(Icons.home, color: AppColors.blood), onPressed: () {}),
          IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: () => Navigator.pushNamed(context, '/chats')),
          IconButton(icon: const Icon(Icons.people_outline), onPressed: () => Navigator.pushNamed(context, '/donors')),
          IconButton(icon: const Icon(Icons.article_outlined), onPressed: () => Navigator.pushNamed(context, '/blogs')),
        ],
      ),
    );
  }
}
