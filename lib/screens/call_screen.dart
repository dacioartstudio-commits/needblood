import 'package:flutter/material.dart';
import '../services/call_service.dart';
import '../theme/app_theme.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final _callService = CallService();
  bool _muted = false;
  bool _speakerOn = false;

  @override
  void initState() {
    super.initState();
    _startCall();
  }

  Future<void> _startCall() async {
    await _callService.init();
    // TODO: fetch a real Agora token from your backend and a stable
    // channel name derived from the two user ids.
    await _callService.joinCall(channelName: 'donor-recipient-demo', token: '', uid: 0);
  }

  @override
  void dispose() {
    _callService.endCall();
    _callService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF2C3A46), AppColors.trust]),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: Column(
              children: [
                Text('AUDIO CALL · CONNECTING…', style: AppTextStyles.mono(size: 10, color: Colors.white70)),
                const Spacer(),
                Container(width: 92, height: 92, decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle)),
                const SizedBox(height: 16),
                Text('Sana Ahmed', style: AppTextStyles.display(size: 24, color: Colors.white)),
                Text('O+ · Jhang Sadr', style: AppTextStyles.body(size: 12, color: Colors.white70)),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _CallActionButton(
                      icon: _muted ? Icons.mic_off : Icons.mic,
                      background: Colors.white.withOpacity(0.15),
                      onTap: () {
                        setState(() => _muted = !_muted);
                        _callService.toggleMute(_muted);
                      },
                    ),
                    const SizedBox(width: 26),
                    _CallActionButton(
                      icon: Icons.call_end,
                      background: AppColors.blood,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 26),
                    _CallActionButton(
                      icon: Icons.volume_up,
                      background: Colors.white.withOpacity(0.15),
                      onTap: () {
                        setState(() => _speakerOn = !_speakerOn);
                        _callService.toggleSpeaker(_speakerOn);
                      },
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

class _CallActionButton extends StatelessWidget {
  final IconData icon;
  final Color background;
  final VoidCallback onTap;
  const _CallActionButton({required this.icon, required this.background, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56, height: 56,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
