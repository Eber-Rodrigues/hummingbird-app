import 'package:flutter/material.dart';
import 'package:hummingbird/l10n/app_localizations.dart';

import 'humming.dart';
import 'l10n_text.dart';
import 'melody_player.dart';
import 'pitch_capture.dart';
import 'theme.dart';
import 'voice_profile.dart';

class VoiceTestScreen extends StatefulWidget {
  const VoiceTestScreen({super.key, required this.gender, required this.onFinished});

  final String gender;
  final ValueChanged<VoiceProfile> onFinished;

  @override
  State<VoiceTestScreen> createState() => _VoiceTestScreenState();
}

class _VoiceTestScreenState extends State<VoiceTestScreen> {
  final _capture = PitchCapture();
  final _player = MelodyPlayer();
  final _attempts = <int, double?>{};
  bool _started = false;
  bool _playing = false;
  bool _listening = false;
  bool _heard = false;
  bool _missed = false;
  VoiceProfile? _profile;
  int? _currentMidi;
  int _index = 0;
  int _generation = 0;

  List<int> get _pitches => testPitchesFor(widget.gender);

  Future<void> _start() async {
    _attempts.clear();
    setState(() {
      _started = true;
      _profile = null;
      _index = 0;
      _missed = false;
    });
    await _playCurrent();
  }

  Future<void> _playCurrent() async {
    final generation = ++_generation;
    final midi = _pitches[_index];
    setState(() {
      _currentMidi = midi;
      _playing = true;
      _listening = false;
      _heard = false;
      _missed = false;
    });
    await _player.playMidi(midi);
    if (!mounted || generation != _generation) return;
    setState(() {
      _playing = false;
      _listening = true;
    });
    final hz = await _capture.comfortablePitch(
      maxDuration: const Duration(seconds: 8),
      stopAfter: 4,
    );
    if (!mounted || generation != _generation) return;
    _attempts[midi] = hz;
    setState(() {
      _listening = false;
      _heard = hz != null;
      _missed = hz == null;
    });
  }

  void _next() {
    if (!_heard) return;
    if (_index + 1 >= _pitches.length) {
      setState(() {
        _profile = profileFromAttempts(gender: widget.gender, attempts: _attempts);
        _started = false;
        _heard = false;
      });
      return;
    }
    setState(() => _index += 1);
    _playCurrent();
  }

  @override
  void dispose() {
    _generation++;
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = _profile;
    final total = _pitches.length;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.findYourVoice)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.humTheNote, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(l10n.voiceListenBody),
            const Spacer(),
            if (profile != null) ...[
              Text(l10n.yourVoiceProfile, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                voiceLabel(l10n, profile.category),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.teal,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.comfortableRange(midiName(profile.minMidi), midiName(profile.maxMidi)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(l10n.adaptedToRange, textAlign: TextAlign.center),
            ] else if (_started) ...[
              Text(
                l10n.voiceTestStep(_index + 1, total),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.teal),
              ),
              if (_currentMidi != null)
                Text(
                  midiName(_currentMidi!),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
              const SizedBox(height: 16),
              if (_playing || _listening)
                const Center(child: CircularProgressIndicator())
              else if (_heard)
                const Icon(Icons.check_circle, key: Key('voice-heard'), color: AppColors.teal, size: 72)
              else if (_missed)
                Text(
                  l10n.couldNotHear,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.w700),
                ),
            ],
            const Spacer(),
            if (profile != null)
              FilledButton(
                key: const Key('voice-continue'),
                onPressed: () => widget.onFinished(profile),
                child: Text(l10n.continueAction),
              )
            else if (!_started)
              FilledButton(
                key: const Key('start-voice-test'),
                onPressed: _start,
                child: Text(l10n.startVoiceTest),
              )
            else if (_missed)
              FilledButton(
                key: const Key('voice-retry'),
                onPressed: _playCurrent,
                child: Text(l10n.tryAgain),
              )
            else if (_heard)
              FilledButton(
                key: const Key('voice-next'),
                onPressed: _next,
                child: Text(l10n.next),
              )
            else
              FilledButton(
                onPressed: null,
                child: Text(l10n.listening),
              ),
          ],
        ),
      ),
    );
  }
}
