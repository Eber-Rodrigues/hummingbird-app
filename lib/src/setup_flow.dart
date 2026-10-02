import 'package:flutter/material.dart';
import 'package:hummingbird/l10n/app_localizations.dart';

import 'controller.dart';
import 'permissions.dart';
import 'screens.dart';
import 'theme.dart';
import 'voice_test_screen.dart';

class SetupFlow extends StatefulWidget {
  const SetupFlow({super.key, required this.controller});

  final AlarmController controller;

  @override
  State<SetupFlow> createState() => _SetupFlowState();
}

class _SetupFlowState extends State<SetupFlow> {
  bool _micReady = false;
  bool _permissionsReady = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    if (!controller.nameChosen) {
      return _NamePage(onNext: controller.chooseName);
    }
    if (controller.gender == null) {
      return _GenderPage(onNext: controller.setGender);
    }
    if (controller.voice == null) {
      if (!_micReady) {
        return _MicPermissionPage(onContinue: () async {
          await requestMicrophonePermission();
          if (mounted) setState(() => _micReady = true);
        });
      }
      return VoiceTestScreen(gender: controller.gender!, onFinished: controller.saveVoiceProfile);
    }
    if (!_permissionsReady) {
      return _PermissionsPage(onContinue: () async {
        await requestAlarmPermissions();
        if (mounted) setState(() => _permissionsReady = true);
      });
    }
    return _ShakePage(onContinue: controller.acknowledgePermissions);
  }
}

class _NamePage extends StatefulWidget {
  const _NamePage({required this.onNext});

  final ValueChanged<String> onNext;

  @override
  State<_NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<_NamePage> {
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ready = _name.text.trim().isNotEmpty;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              const _StepBar(step: 1, total: 6),
              const SizedBox(height: 28),
              Image.asset('assets/images/logo.png', width: 92, height: 92),
              const SizedBox(height: 8),
              const BrandWordmark(width: 220),
              const Spacer(),
              Text(
                l10n.whatsYourName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('onboard-name'),
                controller: _name,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
                maxLength: 10,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.teal,
                      fontWeight: FontWeight.w800,
                    ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: l10n.nameHint,
                  border: InputBorder.none,
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.sky, width: 2)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.teal, width: 2.4)),
                ),
                onChanged: (_) => setState(() {}),
                onSubmitted: ready ? widget.onNext : null,
              ),
              const Spacer(),
              FilledButton(
                key: const Key('name-next'),
                onPressed: ready ? () => widget.onNext(_name.text) : null,
                child: Text(l10n.continueAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepBar extends StatelessWidget {
  const _StepBar({required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: LinearProgressIndicator(
        value: step / total,
        minHeight: 10,
        color: AppColors.teal,
        backgroundColor: AppColors.sky.withValues(alpha: 0.45),
      ),
    );
  }
}

class _GenderPage extends StatefulWidget {
  const _GenderPage({required this.onNext});

  final ValueChanged<String> onNext;

  @override
  State<_GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<_GenderPage> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _StepBar(step: 2, total: 6),
              const SizedBox(height: 28),
              const Center(child: Image(image: AssetImage('assets/images/logo.png'), width: 92, height: 92)),
              const SizedBox(height: 20),
              Text(
                l10n.genderTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 28),
              _GenderChoice(
                key: const Key('gender-male'),
                label: l10n.male,
                selected: _selected == 'male',
                onTap: () => setState(() => _selected = 'male'),
              ),
              const SizedBox(height: 12),
              _GenderChoice(
                key: const Key('gender-female'),
                label: l10n.female,
                selected: _selected == 'female',
                onTap: () => setState(() => _selected = 'female'),
              ),
              const Spacer(),
              FilledButton(
                key: const Key('gender-next'),
                onPressed: _selected == null ? null : () => widget.onNext(_selected!),
                child: Text(l10n.continueAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenderChoice extends StatelessWidget {
  const _GenderChoice({super.key, required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.teal : AppColors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: selected ? AppColors.teal : AppColors.sky, width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    letterSpacing: 0.6,
                    color: selected ? AppColors.white : AppColors.deep,
                  ),
                ),
              ),
              if (selected) const Icon(Icons.check_circle, color: AppColors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShakePage extends StatelessWidget {
  const _ShakePage({required this.onContinue});

  final Future<void> Function() onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              const _StepBar(step: 6, total: 6),
              const SizedBox(height: 28),
              const Center(child: Image(image: AssetImage('assets/images/logo.png'), width: 92, height: 92)),
              const SizedBox(height: 20),
              Text(
                l10n.shakeOnboardTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.shakeOnboardBody,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              const Icon(Icons.vibration, color: AppColors.teal, size: 56),
              const Spacer(),
              FilledButton(
                key: const Key('shake-continue'),
                onPressed: onContinue,
                child: Text(l10n.continueAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MicPermissionPage extends StatelessWidget {
  const _MicPermissionPage({required this.onContinue});

  final Future<void> Function() onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.micPermissionTitle)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.mic_none, color: AppColors.teal, size: 48),
            const SizedBox(height: 16),
            Text(l10n.micPermissionBody, style: Theme.of(context).textTheme.bodyLarge),
            const Spacer(),
            FilledButton(
              key: const Key('mic-allow'),
              onPressed: onContinue,
              child: Text(l10n.allowMicrophone),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionsPage extends StatelessWidget {
  const _PermissionsPage({required this.onContinue});

  final Future<void> Function() onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.permissionsTitle)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.permissionsBody, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            const _PermissionRow(icon: Icons.alarm, labelKey: _PermissionKind.alarm),
            const _PermissionRow(icon: Icons.notifications_active_outlined, labelKey: _PermissionKind.notification),
            const Spacer(),
            FilledButton(
              key: const Key('permissions-continue'),
              onPressed: onContinue,
              child: Text(l10n.allowAndContinue),
            ),
          ],
        ),
      ),
    );
  }
}

enum _PermissionKind { alarm, notification }

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({required this.icon, required this.labelKey});

  final IconData icon;
  final _PermissionKind labelKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = switch (labelKey) {
      _PermissionKind.alarm => l10n.permissionsAlarm,
      _PermissionKind.notification => l10n.permissionsNotification,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.teal),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}
