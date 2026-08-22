import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/blood_drop.dart';
import '../widgets/needblood_button.dart';

class SplashRegisterScreen extends StatefulWidget {
  const SplashRegisterScreen({super.key});

  @override
  State<SplashRegisterScreen> createState() => _SplashRegisterScreenState();
}

class _SplashRegisterScreenState extends State<SplashRegisterScreen> {
  final _mobileCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  children: [
                    const BloodDrop(size: 16),
                    const SizedBox(width: 6),
                    Text('NeedBlood', style: AppTextStyles.display(size: 22)),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0xFFE85C71), AppColors.blood],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text('+', style: AppTextStyles.display(size: 40, color: Colors.white)),
                ),
                const SizedBox(height: 26),
                Text(
                  'Save a life,\none tap away.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.display(size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connects blood donors and people in need,\ncity by city, across Pakistan.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(size: 13),
                ),
                const Spacer(),
                // Both channels required so an alert can always reach the
                // user — push when online, SMS/email when it can't.
                TextFormField(
                  controller: _mobileCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Mobile Number', hintText: '+92 3XX XXXXXXX'),
                  validator: (v) => (v == null || v.length < 10) ? 'Enter a valid mobile number' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email Address', hintText: 'you@example.com'),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 18),
                NeedBloodButton(
                  label: 'Register',
                  color: AppColors.blood,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: FirebaseAuth verifyPhoneNumber (OTP) +
                      // create pending user doc with mobile+email, then:
                      Navigator.pushNamed(context, '/profile-setup');
                    }
                  },
                ),
                TextButton(
                  onPressed: () {}, // TODO: login flow for returning users
                  child: Text('Already registered? Log in', style: AppTextStyles.body(size: 12)),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
