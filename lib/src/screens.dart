import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'controller.dart';
import 'models.dart';
import 'theme.dart';

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.width = 280});

  final double width;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: Alignment.center,
        heightFactor: 0.24,
        child: Image.asset(
          'assets/images/wordmark.png',
          width: width,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}

class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;
    return ColoredBox(
      color: const Color(0xFFE4EDF3),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const width = 390.0;
          const height = 844.0;
          final scale = math.min(
            (constraints.maxWidth - 28) / width,
            (constraints.maxHeight - 28) / height,
          );
          final fitted = scale.isFinite ? scale.clamp(0.35, 1.15) : 1.0;
          return Center(
            child: SizedBox(
              width: width * fitted,
              height: height * fitted,
              child: FittedBox(
                child: SizedBox(
                  width: width,
                  height: height,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFF111418),
                      borderRadius: BorderRadius.circular(42),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33023047),
                          blurRadius: 28,
                          offset: Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                            textScaler: TextScaler.noScaling,
                          ),
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class WelcomeFlow extends StatefulWidget {
  const WelcomeFlow({super.key, required this.controller});

  final AlarmController controller;

  @override
  State<WelcomeFlow> createState() => _WelcomeFlowState();
}

class _WelcomeFlowState extends State<WelcomeFlow> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    return switch (_step) {
      0 => _WelcomePage(onContinue: () => setState(() => _step = 1)),
      1 => _VoicePage(
          step: 1,
          controller: widget.controller,
          onSkip: widget.controller.finishOnboarding,
          onContinue: () => setState(() => _step = 2),
        ),
      _ => _VoicePage(
          step: 2,
          controller: widget.controller,
          onSkip: widget.controller.finishOnboarding,
          onContinue: widget.controller.finishOnboarding,
        ),
    };
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            children: [
              const Spacer(),
              Image.asset('assets/images/logo.png', width: 168, height: 168),
              const SizedBox(height: 28),
              const BrandWordmark(),
              const SizedBox(height: 12),
              Text(
                'Wake up to your own melody',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.deep.withValues(alpha: 0.72),
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Spacer(),
              FilledButton(onPressed: onContinue, child: const Text('Create Account')),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onContinue,
                child: const Text('I Already Have an Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VoicePage extends StatefulWidget {
  const _VoicePage({
    required this.step,
    required this.controller,
    required this.onSkip,
    required this.onContinue,
  });

  final int step;
  final AlarmController controller;
  final VoidCallback onSkip;
  final VoidCallback onContinue;

  @override
  State<_VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<_VoicePage> {
  String? _note;

  Future<void> _probe() async {
    final sample = await widget.controller.humming.listen(maxDuration: const Duration(seconds: 5));
    if (!mounted) return;
    setState(() => _note = sample.message);
  }

  @override
  Widget build(BuildContext context) {
    final second = widget.step == 2;
    return Scaffold(
      appBar: AppBar(
        title: Text(second ? 'Your voice range' : "Let's test your voice"),
        actions: [
          TextButton(onPressed: widget.onSkip, child: const Text('Skip for now')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              second ? 'Voice Test  2/2' : 'Voice Test  1/2',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.teal),
            ),
            const SizedBox(height: 8),
            Text(
              second
                  ? 'This range will later pick a melody difficulty. Humming is not recorded in this phase.'
                  : "We'll use your voice later to stop an alarm. For now, stopping is a button.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 28),
            Expanded(
              child: Center(
                child: second ? const _RangeCard() : const _MicStub(),
              ),
            ),
            if (_note != null) ...[
              Text(_note!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
            ],
            if (!second)
              OutlinedButton(onPressed: _probe, child: const Text('Check the humming module')),
            if (!second) const SizedBox(height: 12),
            FilledButton(
              onPressed: widget.onContinue,
              child: Text(second ? 'Continue' : 'Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MicStub extends StatelessWidget {
  const _MicStub();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.sky,
      ),
      child: const Icon(Icons.mic_none_rounded, size: 72, color: AppColors.deep),
    );
  }
}

class _RangeCard extends StatelessWidget {
  const _RangeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Detected range', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Waiting for the humming module',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.teal,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 16),
          const _Chip(label: 'Recommended difficulty  ·  Medium'),
        ],
      ),
    );
  }
}

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key, required this.controller});

  final AlarmController controller;

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      AlarmsPage(controller: widget.controller),
      VoiceStudioPage(controller: widget.controller),
      ProfilePage(controller: widget.controller),
    ];
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.alarm_outlined), selectedIcon: Icon(Icons.alarm), label: 'Alarms'),
          NavigationDestination(icon: Icon(Icons.graphic_eq_outlined), selectedIcon: Icon(Icons.graphic_eq), label: 'Test Voice'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class AlarmsPage extends StatelessWidget {
  const AlarmsPage({super.key, required this.controller});

  final AlarmController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Alarms'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Image.asset('assets/images/logo.png', width: 36, height: 36),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            children: [
              FilledButton.icon(
                onPressed: () => _openEditor(context),
                icon: const Icon(Icons.add),
                label: const Text('Create Alarm'),
              ),
              const SizedBox(height: 16),
              if (controller.alarms.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 48),
                  child: Text('No alarms yet.', textAlign: TextAlign.center),
                )
              else
                for (final alarm in controller.alarms) ...[
                  _AlarmCard(
                    alarm: alarm,
                    onChanged: (enabled) => controller.setEnabled(alarm, enabled),
                    onEdit: () => _openEditor(context, alarm),
                    onPreview: () => controller.preview(alarm),
                  ),
                  const SizedBox(height: 12),
                ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _openEditor(BuildContext context, [AlarmItem? alarm]) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CreateAlarmPage(controller: controller, existing: alarm)),
    );
  }
}

class _AlarmCard extends StatelessWidget {
  const _AlarmCard({
    required this.alarm,
    required this.onChanged,
    required this.onEdit,
    required this.onPreview,
  });

  final AlarmItem alarm;
  final ValueChanged<bool> onChanged;
  final VoidCallback onEdit;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final melody = melodyById(alarm.melodyId);
    return Material(
      color: AppColors.mist,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      alarm.timeLabel,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: alarm.enabled ? AppColors.deep : AppColors.deep.withValues(alpha: 0.35),
                          ),
                    ),
                  ),
                  Switch(value: alarm.enabled, onChanged: onChanged),
                ],
              ),
              Text(alarm.label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('${melody.name}  ·  ${alarm.difficulty}  ·  ${alarm.tolerance}'),
              const SizedBox(height: 10),
              Row(
                children: [
                  _DayDots(weekdays: alarm.weekdays),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Test ring',
                    onPressed: alarm.enabled ? onPreview : null,
                    icon: const Icon(Icons.play_circle_outline),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayDots extends StatelessWidget {
  const _DayDots({required this.weekdays});

  final Set<int> weekdays;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var day = 1; day <= 7; day++) ...[
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: weekdays.contains(day) ? AppColors.teal : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: weekdays.contains(day) ? AppColors.teal : AppColors.line,
              ),
            ),
            child: Text(
              dayLetters[day - 1],
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: weekdays.contains(day) ? AppColors.white : AppColors.deep.withValues(alpha: 0.45),
              ),
            ),
          ),
          if (day != 7) const SizedBox(width: 4),
        ],
      ],
    );
  }
}

class CreateAlarmPage extends StatefulWidget {
  const CreateAlarmPage({super.key, required this.controller, this.existing});

  final AlarmController controller;
  final AlarmItem? existing;

  @override
  State<CreateAlarmPage> createState() => _CreateAlarmPageState();
}

class _CreateAlarmPageState extends State<CreateAlarmPage> {
  late int _hour12;
  late int _minute;
  late bool _pm;
  late Set<int> _days;
  late String _melodyId;
  late String _difficulty;
  late String _tolerance;
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    final hour = existing?.hour ?? 7;
    _pm = hour >= 12;
    _hour12 = hour % 12 == 0 ? 12 : hour % 12;
    _minute = existing?.minute ?? 0;
    _days = existing == null ? {1, 2, 3, 4, 5} : {...existing.weekdays};
    _melodyId = existing?.melodyId ?? melodies.first.id;
    _difficulty = existing?.difficulty ?? 'Medium';
    _tolerance = existing?.tolerance ?? 'Normal';
    _enabled = existing?.enabled ?? true;
  }

  int get _hour24 {
    if (_hour12 == 12) return _pm ? 12 : 0;
    return _pm ? _hour12 + 12 : _hour12;
  }

  Future<void> _save() async {
    final melody = melodyById(_melodyId);
    final alarm = AlarmItem(
      id: widget.existing?.id ?? widget.controller.nextId(),
      hour: _hour24,
      minute: _minute,
      weekdays: _days,
      melodyId: _melodyId,
      difficulty: _difficulty,
      tolerance: _tolerance,
      enabled: _enabled,
      label: melody.name,
    );
    await widget.controller.saveAlarm(alarm);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final existing = widget.existing;
    if (existing == null) return;
    await widget.controller.deleteAlarm(existing.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Create Alarm' : 'Edit Alarm'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        children: [
          SizedBox(
            height: 180,
            child: Row(
              children: [
                Expanded(
                  child: _Drum(
                    itemCount: 12,
                    initialItem: _hour12 - 1,
                    label: (index) => '${index + 1}',
                    onChanged: (index) => setState(() => _hour12 = index + 1),
                  ),
                ),
                Expanded(
                  child: _Drum(
                    itemCount: 60,
                    initialItem: _minute,
                    label: (index) => index.toString().padLeft(2, '0'),
                    onChanged: (index) => setState(() => _minute = index),
                  ),
                ),
                Expanded(
                  child: _Drum(
                    itemCount: 2,
                    initialItem: _pm ? 1 : 0,
                    label: (index) => index == 0 ? 'AM' : 'PM',
                    onChanged: (index) => setState(() => _pm = index == 1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatClock(_hour24, _minute),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          const _SectionLabel('Repeat'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var day = 1; day <= 7; day++)
                _DayButton(
                  letter: dayLetters[day - 1],
                  selected: _days.contains(day),
                  onTap: () => setState(() {
                    if (_days.contains(day)) {
                      _days.remove(day);
                    } else {
                      _days.add(day);
                    }
                  }),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _days.isEmpty ? 'Rings once, then turns off.' : 'Repeats on the selected days.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 18),
          const _SectionLabel('Melody'),
          const SizedBox(height: 8),
          for (final melody in melodies)
            _ChoiceTile(
              title: melody.name,
              subtitle: melody.detail,
              selected: _melodyId == melody.id,
              onTap: () => setState(() => _melodyId = melody.id),
            ),
          const SizedBox(height: 18),
          const _SectionLabel('Difficulty'),
          const SizedBox(height: 8),
          _Segmented(
            values: difficulties,
            selected: _difficulty,
            onChanged: (value) => setState(() => _difficulty = value),
          ),
          const SizedBox(height: 18),
          const _SectionLabel('Tolerance'),
          const SizedBox(height: 8),
          _Segmented(
            values: tolerances,
            selected: _tolerance,
            onChanged: (value) => setState(() => _tolerance = value),
          ),
          const SizedBox(height: 8),
          Text(
            'Difficulty and tolerance are saved for the humming module. They do not change the stop button.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 22),
          FilledButton(onPressed: _save, child: const Text('Save Alarm')),
          if (widget.existing != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: _delete, child: const Text('Delete alarm')),
          ],
        ],
      ),
    );
  }
}

class _Drum extends StatefulWidget {
  const _Drum({
    required this.itemCount,
    required this.initialItem,
    required this.label,
    required this.onChanged,
  });

  final int itemCount;
  final int initialItem;
  final String Function(int index) label;
  final ValueChanged<int> onChanged;

  @override
  State<_Drum> createState() => _DrumState();
}

class _DrumState extends State<_Drum> {
  late final FixedExtentScrollController _controller = FixedExtentScrollController(
    initialItem: widget.initialItem,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: AppColors.sky.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        ListWheelScrollView.useDelegate(
          controller: _controller,
          itemExtent: 48,
          perspective: 0.003,
          diameterRatio: 1.4,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: widget.onChanged,
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: widget.itemCount,
            builder: (context, index) {
              return Center(
                child: Text(
                  widget.label(index),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DayButton extends StatelessWidget {
  const _DayButton({required this.letter, required this.selected, required this.onTap});

  final String letter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.teal : AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(color: selected ? AppColors.teal : AppColors.line),
        ),
        child: Text(
          letter,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: selected ? AppColors.white : AppColors.deep,
          ),
        ),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? AppColors.sky.withValues(alpha: 0.35) : AppColors.mist,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.music_note, color: selected ? AppColors.orange : AppColors.teal),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                      Text(subtitle),
                    ],
                  ),
                ),
                if (selected) const Icon(Icons.check_circle, color: AppColors.teal),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Segmented extends StatelessWidget {
  const _Segmented({required this.values, required this.selected, required this.onChanged});

  final List<String> values;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final value in values)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Center(child: Text(value)),
                selected: selected == value,
                onSelected: (_) => onChanged(value),
                selectedColor: AppColors.teal,
                labelStyle: TextStyle(
                  color: selected == value ? AppColors.white : AppColors.deep,
                  fontWeight: FontWeight.w800,
                ),
                showCheckmark: false,
                side: BorderSide(color: selected == value ? AppColors.teal : AppColors.line),
              ),
            ),
          ),
      ],
    );
  }
}

class VoiceStudioPage extends StatelessWidget {
  const VoiceStudioPage({super.key, required this.controller});

  final AlarmController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Voice')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: _MicStub()),
            const SizedBox(height: 24),
            Text(
              'Humming is a module, not this phase.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Later, a match against the saved melody, difficulty, and tolerance will stop the alarm. Today the stop button does that.',
            ),
            const Spacer(),
            FilledButton(
              onPressed: () async {
                final sample = await controller.humming.listen(maxDuration: const Duration(seconds: 4));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(sample.message)));
              },
              child: const Text('Try the humming module'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.controller});

  final AlarmController controller;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController _name = TextEditingController(text: widget.controller.displayName);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const BrandWordmark(width: 260),
          const SizedBox(height: 24),
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            onSubmitted: widget.controller.setDisplayName,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => widget.controller.setDisplayName(_name.text),
            child: const Text('Save name'),
          ),
          const SizedBox(height: 24),
          const _SectionLabel('Saved for later'),
          const SizedBox(height: 8),
          const Text('Melodies, difficulty, and tolerance stay on this device. There is no account server in this phase.'),
        ],
      ),
    );
  }
}

class RingingScreen extends StatefulWidget {
  const RingingScreen({super.key, required this.controller, required this.alarm});

  final AlarmController controller;
  final AlarmItem alarm;

  @override
  State<RingingScreen> createState() => _RingingScreenState();
}

class _RingingScreenState extends State<RingingScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alarm = widget.alarm;
    return Material(
      color: AppColors.deep,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset('assets/images/logo.png', width: 56, height: 56),
              ),
              const Spacer(),
              Text(
                alarm.timeLabel,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Wake up with your melody',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.sky,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 28),
              AnimatedBuilder(
                animation: _pulse,
                builder: (context, _) {
                  return Icon(
                    Icons.graphic_eq,
                    size: 72 + (_pulse.value * 10),
                    color: AppColors.amber,
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                alarm.label,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: AppColors.white,
                  ),
                  onPressed: widget.controller.stopRinging,
                  child: const Text('Stop'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
