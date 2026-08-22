import 'package:agora_rtc_engine/agora_rtc_engine.dart';

/// In-app voice calling between a donor and a recipient, so neither side
/// has to exchange or expose their real phone number.
///
/// Requires an Agora project App ID (free tier is enough to start) —
/// see README.md "Accounts you need" for where to plug it in.
class CallService {
  static const String _agoraAppId = String.fromEnvironment('AGORA_APP_ID', defaultValue: '');

  RtcEngine? _engine;

  Future<void> init() async {
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(appId: _agoraAppId));
    await _engine!.enableAudio();
    await _engine!.disableVideo();
  }

  /// [channelName] should be a stable id derived from the two user ids
  /// (e.g. sorted-and-joined) so both sides join the same call.
  Future<void> joinCall({
    required String channelName,
    required String token,
    required int uid,
  }) async {
    await _engine?.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
  }

  Future<void> toggleMute(bool muted) async {
    await _engine?.muteLocalAudioStream(muted);
  }

  Future<void> toggleSpeaker(bool speakerOn) async {
    await _engine?.setEnableSpeakerphone(speakerOn);
  }

  Future<void> endCall() async {
    await _engine?.leaveChannel();
  }

  Future<void> dispose() async {
    await _engine?.release();
  }
}
