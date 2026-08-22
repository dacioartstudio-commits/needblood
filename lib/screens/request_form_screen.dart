import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/blood_request.dart';
import '../services/alert_dispatch_service.dart';
import '../theme/app_theme.dart';
import '../widgets/blood_group_grid.dart';
import '../widgets/needblood_button.dart';

class RequestFormScreen extends StatefulWidget {
  const RequestFormScreen({super.key});

  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  String? _bloodGroup = 'O+'; // pre-filled from the requester's own profile
  final _areaCtrl = TextEditingController(text: 'Jhang Sadr');
  final _hospitalCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  double _radiusKm = 3;
  bool _sending = false;

  final _dispatchService = AlertDispatchService();

  Future<void> _sendAlert() async {
    if (_bloodGroup == null || _hospitalCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a blood group and enter the hospital name.')),
      );
      return;
    }

    setState(() => _sending = true);

    final request = BloodRequest(
      id: const Uuid().v4(),
      requesterId: 'current-user-id', // TODO: from auth
      requesterName: 'current-user-name', // TODO: from profile
      bloodGroupNeeded: _bloodGroup!,
      province: 'Punjab', // TODO: from profile
      city: 'Jhang', // TODO: from profile
      area: _areaCtrl.text.trim(),
      radiusKm: _radiusKm,
      hospitalName: _hospitalCtrl.text.trim(),
      customMessage: _messageCtrl.text.trim(),
      createdAt: DateTime.now(),
      deliveryMode: RequestDeliveryMode.online, // overwritten by dispatch result
    );

    final modeUsed = await _dispatchService.sendAlert(request);

    if (!mounted) return;
    setState(() => _sending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(modeUsed == RequestDeliveryMode.online
            ? 'Alert sent — donors notified in real time.'
            : 'No internet — alert sent to donors via SMS instead.'),
      ),
    );
    Navigator.pushNamed(context, '/donors');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Request')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          Text('Blood group needed', style: AppTextStyles.display(size: 15)),
          const SizedBox(height: 8),
          BloodGroupGrid(selected: _bloodGroup, onSelect: (g) => setState(() => _bloodGroup = g)),
          const SizedBox(height: 16),

          TextField(controller: _areaCtrl, decoration: const InputDecoration(labelText: 'Area')),
          const SizedBox(height: 12),

          Text('Alert radius: ${_radiusKm.toStringAsFixed(0)} km', style: AppTextStyles.body(size: 12, w: FontWeight.w600, color: AppColors.ink)),
          Slider(
            value: _radiusKm, min: 1, max: 20, divisions: 19,
            activeColor: AppColors.blood,
            onChanged: (v) => setState(() => _radiusKm = v),
          ),

          // Required so the alarm the donor receives tells them exactly
          // where to go, not just which city/area.
          TextField(
            controller: _hospitalCtrl,
            decoration: const InputDecoration(labelText: 'Hospital Name', hintText: 'e.g. City Hospital, Jhang Sadr'),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _messageCtrl,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Custom Message', hintText: 'e.g. Emergency — accident case, ICU bed 4'),
          ),
          const SizedBox(height: 20),

          NeedBloodButton(
            label: _sending ? 'Sending...' : 'Send Alert Now',
            color: AppColors.go,
            icon: Icons.notifications_active,
            onTap: _sending ? () {} : _sendAlert,
          ),
        ],
      ),
    );
  }
}
