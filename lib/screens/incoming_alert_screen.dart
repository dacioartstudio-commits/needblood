import 'package:flutter/material.dart';
import '../services/alarm_notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/blood_drop.dart';

/// Shown full-screen on a donor's phone when a matching request comes in
/// — whether that arrived via FCM push (online) or was triggered locally
/// after an SMS was received (offline). See AlarmNotificationService for
/// the ringtone + vibration that plays alongside this screen.
class IncomingAlertScreen extends StatefulWidget {
  const IncomingAlertScreen({super.key});

  @override
  State<IncomingAlertScreen> createState() => _IncomingAlertScreenState();
}

class _IncomingAlertScreenState extends State<IncomingAlertScreen> {
  @override
  void dispose() {
    AlarmNotificationService().stopAlarm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: read the real BloodRequest passed via route arguments.
    const recipientName = 'Ali';
    const bloodGroup = 'O+';
    const hospital = 'City Hospital, Jhang Sadr';
    const distance = '2.1 km away';
    const message = 'Emergency — accident case, ICU bed 4';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [AppColors.bloodDeep, AppColors.blood],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 96, height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.14),
                    border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                  ),
                  alignment: Alignment.center,
                  child: const BloodDrop(size: 22, color: Colors.white),
                ),
                const SizedBox(height: 18),
                Text('RINGING', style: AppTextStyles.mono(size: 11, color: Colors.white.withOpacity(0.9))),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.display(size: 26, color: Colors.white),
                    children: const [
                      TextSpan(text: '$recipientName needs '),
                      TextSpan(text: bloodGroup, style: TextStyle(backgroundColor: Colors.white, color: AppColors.bloodDeep)),
                      TextSpan(text: '\nBlood'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text('$hospital · $distance\n"$message"',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(size: 12.5, color: Colors.white.withOpacity(0.9))),
                const SizedBox(height: 6),
                Text('🔊 Ringtone: Medium–High Intensity', style: AppTextStyles.mono(size: 9.5, color: Colors.white.withOpacity(0.75))),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.bloodDeep, padding: const EdgeInsets.symmetric(vertical: 14)),
                        onPressed: () => Navigator.pushReplacementNamed(context, '/donors'),
                        child: const Text('View & Accept'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54), padding: const EdgeInsets.symmetric(vertical: 14)),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Not Now'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
