import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hummingbird/l10n/app_localizations.dart';

import 'alarm_vibration.dart';
import 'controller.dart';
import 'humming.dart';
import 'l10n_text.dart';
import 'melody_player.dart';
import 'models.dart';
import 'pitch_capture.dart';
import 'shake_to_stop.dart';
import 'theme.dart';
import 'voice_profile.dart';
import 'voice_test_screen.dart';
import 'wake_prompt.dart';

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.width = 280});

  final double width;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ClipRect(
      child: Align(
        alignment: Alignment.center,
        heightFactor: 0.24,
        child: Image.asset(
          dark ? 'assets/images/wordmark_dark.png' : 'assets/images/wordmark.png',
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
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ColoredBox(
      color: dark ? const Color(0xFF011E2E) : const Color(0xFFE4EDF3),
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
                          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
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
    final l10n = AppLocalizations.of(context);
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
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.alarm_outlined),
            selectedIcon: const Icon(Icons.alarm),
            label: l10n.navAlarms,
          ),
          NavigationDestination(
            icon: const Icon(Icons.graphic_eq_outlined),
            selectedIcon: const Icon(Icons.graphic_eq),
            label: l10n.navVoice,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(l10n.navAlarms),
      ),
      floatingActionButton: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          key: const Key('add-alarm'),
          shape: const CircleBorder(),
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.white,
          onPressed: () => _openEditor(context),
          child: const Icon(Icons.add, size: 30),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
        children: [
          _HomeSceneCard(controller: controller),
          const SizedBox(height: 16),
          if (controller.alarms.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 48),
              child: Text(l10n.noAlarms, textAlign: TextAlign.center),
            )
          else
            for (final alarm in controller.alarms) ...[
              _AlarmCard(
                alarm: alarm,
                use24Hour: controller.use24Hour,
                onChanged: (enabled) => controller.setEnabled(alarm, enabled),
                onEdit: () => _openEditor(context, alarm),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, [AlarmItem? alarm]) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CreateAlarmPage(controller: controller, existing: alarm)),
    );
  }
}

const _sceneAssets = [
  'assets/images/scene_rest.jpg',
  'assets/images/scene_wake.jpg',
  'assets/images/scene_forest.jpg',
];

class _HomeSceneCard extends StatelessWidget {
  const _HomeSceneCard({required this.controller});

  final AlarmController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scene = _sceneAssets[controller.homeScene.clamp(0, _sceneAssets.length - 1)];
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 196,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(scene, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x22023047), Color(0xCC023047)],
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.displayName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonal(
                    key: const Key('change-scene'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.deep,
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      textStyle: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    onPressed: () => _pickScene(context),
                    child: Text(l10n.changeScene),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickScene(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.changeScene, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                for (var i = 0; i < _sceneAssets.length; i++) ...[
                  InkWell(
                    key: Key('scene-$i'),
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      controller.setHomeScene(i);
                      Navigator.of(context).pop();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 92,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(_sceneAssets[i], fit: BoxFit.cover),
                            if (controller.homeScene == i)
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: Icon(Icons.check_circle, color: AppColors.white),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AlarmCard extends StatefulWidget {
  const _AlarmCard({
    required this.alarm,
    required this.use24Hour,
    required this.onChanged,
    required this.onEdit,
  });

  final AlarmItem alarm;
  final bool use24Hour;
  final ValueChanged<bool> onChanged;
  final VoidCallback onEdit;

  @override
  State<_AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<_AlarmCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final alarm = widget.alarm;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final name = alarm.label.trim().isEmpty ? melodyTitle(l10n, alarm.melodyId) : alarm.label;
    return Material(
      color: appCard(context),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => setState(() => _open = !_open),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatClockLocalized(l10n, alarm.hour, alarm.minute, use24Hour: widget.use24Hour),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: alarm.enabled ? onSurface : appMuted(context),
                    ),
              ),
              const SizedBox(height: 2),
              Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              if (_open) ...[
                const SizedBox(height: 12),
                Text(
                  '${melodyTitle(l10n, alarm.melodyId)}  ·  ${difficultyLabel(l10n, alarm.difficulty)}  ·  ${toleranceLabel(l10n, alarm.tolerance)}',
                ),
                const SizedBox(height: 10),
                _DayDots(weekdays: alarm.weekdays),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text(alarm.enabled ? l10n.alarmOn : l10n.alarmOff)),
                    Switch(value: alarm.enabled, onChanged: widget.onChanged),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(onPressed: widget.onEdit, child: Text(l10n.editDetails)),
                ),
              ],
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
    final letters = dayLettersFor(Localizations.localeOf(context));
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
              border: Border.all(color: weekdays.contains(day) ? AppColors.teal : appLine(context)),
            ),
            child: Text(
              letters[day - 1],
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: weekdays.contains(day) ? AppColors.white : appMuted(context),
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
  late int _hour;
  late int _minute;
  late Set<int> _days;
  late String _melodyId;
  late String _difficulty;
  late String _tolerance;
  late bool _enabled;
  late final TextEditingController _name;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _hour = existing?.hour ?? 7;
    _minute = existing?.minute ?? 0;
    _days = existing == null ? {1, 2, 3, 4, 5} : {...existing.weekdays};
    final allowed = melodiesForVoice(widget.controller.voice);
    _melodyId = existing?.melodyId ?? allowed.first.id;
    _difficulty = existing?.difficulty ?? 'Medium';
    _tolerance = existing?.tolerance ?? 'Normal';
    _enabled = existing?.enabled ?? true;
    _name = TextEditingController(text: existing?.label ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  List<Melody> get _melodyChoices {
    final allowed = melodiesForVoice(widget.controller.voice);
    if (allowed.any((melody) => melody.id == _melodyId)) return allowed;
    return [melodyById(_melodyId), ...allowed.where((melody) => melody.id != _melodyId)];
  }

  int get _hour12 => _hour % 12 == 0 ? 12 : _hour % 12;

  bool get _pm => _hour >= 12;

  void _setHour12(int hour12, bool pm) {
    if (hour12 == 12) {
      _hour = pm ? 12 : 0;
    } else {
      _hour = pm ? hour12 + 12 : hour12;
    }
  }

  Future<void> _save() async {
    final typed = _name.text.trim();
    final alarm = AlarmItem(
      id: widget.existing?.id ?? widget.controller.nextId(),
      hour: _hour,
      minute: _minute,
      weekdays: _days,
      melodyId: _melodyId,
      difficulty: _difficulty,
      tolerance: _tolerance,
      enabled: _enabled,
      label: typed.isEmpty ? melodyById(_melodyId).name : typed,
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
    final l10n = AppLocalizations.of(context);
    final letters = dayLettersFor(Localizations.localeOf(context));
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? l10n.createAlarm : l10n.editAlarmTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        children: [
          TextField(
            key: const Key('alarm-name'),
            controller: _name,
            decoration: InputDecoration(labelText: l10n.alarmName, hintText: l10n.alarmNameHint),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: Row(
              children: [
                if (widget.controller.use24Hour)
                  Expanded(
                    child: _Drum(
                      key: const ValueKey('hour-24-drum'),
                      itemCount: 24,
                      initialItem: _hour,
                      label: (index) => index.toString().padLeft(2, '0'),
                      onChanged: (index) => setState(() => _hour = index),
                    ),
                  )
                else
                  Expanded(
                    child: _Drum(
                      key: const ValueKey('hour-12-drum'),
                      itemCount: 12,
                      initialItem: _hour12 - 1,
                      label: (index) => '${index + 1}',
                      onChanged: (index) => setState(() => _setHour12(index + 1, _pm)),
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
                if (!widget.controller.use24Hour)
                  Expanded(
                    child: _Drum(
                      itemCount: 2,
                      initialItem: _pm ? 1 : 0,
                      label: (index) => index == 0 ? l10n.am : l10n.pm,
                      onChanged: (index) => setState(() => _setHour12(_hour12, index == 1)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatClockLocalized(l10n, _hour, _minute, use24Hour: widget.controller.use24Hour),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          _SectionLabel(l10n.repeat),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var day = 1; day <= 7; day++)
                _DayButton(
                  letter: letters[day - 1],
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
            _days.isEmpty ? l10n.ringsOnce : l10n.repeatsOnDays,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 18),
          _SectionLabel(l10n.melody),
          const SizedBox(height: 8),
          if (widget.controller.voice != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.melodyForVoice(voiceLabel(l10n, widget.controller.voice!)),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          for (final melody in _melodyChoices)
            _ChoiceTile(
              title: melodyTitle(l10n, melody.id),
              subtitle: melodyDetail(l10n, melody.id),
              selected: _melodyId == melody.id,
              onTap: () => setState(() => _melodyId = melody.id),
            ),
          const SizedBox(height: 18),
          _SectionLabel(l10n.difficulty),
          const SizedBox(height: 8),
          _Segmented(
            values: difficulties,
            label: (value) => difficultyLabel(l10n, value),
            selected: _difficulty,
            onChanged: (value) => setState(() => _difficulty = value),
          ),
          const SizedBox(height: 18),
          _SectionLabel(l10n.tolerance),
          const SizedBox(height: 8),
          _Segmented(
            values: tolerances,
            label: (value) => toleranceLabel(l10n, value),
            selected: _tolerance,
            onChanged: (value) => setState(() => _tolerance = value),
          ),
          const SizedBox(height: 8),
          Text(l10n.hummingSavedHint, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 22),
          FilledButton(onPressed: _save, child: Text(l10n.saveAlarm)),
          if (widget.existing != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: _delete, child: Text(l10n.deleteAlarm)),
          ],
        ],
      ),
    );
  }
}

class _Drum extends StatefulWidget {
  const _Drum({
    super.key,
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
          onSelectedItemChanged: (index) {
            final count = widget.itemCount;
            final wrapped = index % count;
            widget.onChanged(wrapped < 0 ? wrapped + count : wrapped);
          },
          childDelegate: ListWheelChildLoopingListDelegate(
            children: [
              for (var index = 0; index < widget.itemCount; index++)
                Center(
                  child: Text(
                    widget.label(index),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
            ],
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
          color: selected ? AppColors.teal : Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(color: selected ? AppColors.teal : appLine(context)),
        ),
        child: Text(
          letter,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: selected ? AppColors.white : Theme.of(context).colorScheme.onSurface,
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
        color: selected ? AppColors.sky.withValues(alpha: 0.35) : appCard(context),
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
  const _Segmented({
    required this.values,
    required this.label,
    required this.selected,
    required this.onChanged,
  });

  final List<String> values;
  final String Function(String value) label;
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
                label: Center(child: Text(label(value))),
                selected: selected == value,
                onSelected: (_) => onChanged(value),
                selectedColor: AppColors.teal,
                backgroundColor: appCard(context),
                labelStyle: TextStyle(
                  color: selected == value ? AppColors.white : Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
                showCheckmark: false,
                side: BorderSide(color: selected == value ? AppColors.teal : appLine(context)),
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
    final l10n = AppLocalizations.of(context);
    final profile = controller.voiceProfile;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.findYourVoice)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          Text(
            l10n.voiceHeadline,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(l10n.voiceBody),
          const SizedBox(height: 20),
          if (profile != null) ...[
            Text(l10n.yourVoiceProfile, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(l10n.voiceTypeLine(voiceLabel(l10n, profile.category))),
            Text(l10n.genderLine(genderLabel(l10n, profile.gender))),
            Text(l10n.comfortableRange(midiName(profile.minMidi), midiName(profile.maxMidi))),
            if (profile.testedAt != null) Text(l10n.lastTested(_shortDate(profile.testedAt!))),
            const SizedBox(height: 8),
            Text(l10n.adaptedToRange),
          ] else
            Text(l10n.voiceTestNeeded),
          const SizedBox(height: 20),
          FilledButton(
            key: const Key('retake-voice-test'),
            onPressed: () {
              final gender = controller.gender ?? 'female';
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VoiceTestScreen(
                    gender: gender,
                    onFinished: (profile) async {
                      await controller.saveVoiceProfile(profile);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
            child: Text(profile == null ? l10n.startVoiceTest : l10n.retakeVoiceTest),
          ),
        ],
      ),
    );
  }
}

String _shortDate(DateTime date) {
  final local = date.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}-$month-$day';
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
    final l10n = AppLocalizations.of(context);
    final code = widget.controller.languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          const BrandWordmark(width: 260),
          const SizedBox(height: 24),
          TextField(
            controller: _name,
            maxLength: 10,
            decoration: InputDecoration(labelText: l10n.nameLabel, counterText: ''),
            onSubmitted: widget.controller.setDisplayName,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => widget.controller.setDisplayName(_name.text),
            child: Text(l10n.saveName),
          ),
          const SizedBox(height: 28),
          _SectionLabel(l10n.voiceProfile),
          const SizedBox(height: 8),
          if (widget.controller.voiceProfile != null) ...[
            Text(l10n.genderLine(genderLabel(l10n, widget.controller.voiceProfile!.gender))),
            Text(l10n.voiceTypeLine(voiceLabel(l10n, widget.controller.voiceProfile!.category))),
            Text(
              l10n.comfortableRange(
                midiName(widget.controller.voiceProfile!.minMidi),
                midiName(widget.controller.voiceProfile!.maxMidi),
              ),
            ),
            if (widget.controller.voiceProfile!.testedAt != null)
              Text(l10n.lastTested(_shortDate(widget.controller.voiceProfile!.testedAt!))),
            const SizedBox(height: 4),
            Text(l10n.adaptedToRange),
          ] else
            Text(l10n.voiceTestNeeded),
          const SizedBox(height: 12),
          OutlinedButton(
            key: const Key('settings-retake-voice'),
            onPressed: () {
              final gender = widget.controller.gender ?? 'female';
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VoiceTestScreen(
                    gender: gender,
                    onFinished: (profile) async {
                      await widget.controller.saveVoiceProfile(profile);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
            child: Text(l10n.retakeVoiceTest),
          ),
          const SizedBox(height: 28),
          _SectionLabel(l10n.hourSystem),
          const SizedBox(height: 8),
          _LanguageTile(
            key: const Key('hour-24'),
            label: l10n.hour24,
            selected: widget.controller.use24Hour,
            onTap: () => widget.controller.setUse24Hour(true),
          ),
          _LanguageTile(
            key: const Key('hour-12'),
            label: l10n.hour12,
            selected: !widget.controller.use24Hour,
            onTap: () => widget.controller.setUse24Hour(false),
          ),
          const SizedBox(height: 16),
          Material(
            color: appCard(context),
            borderRadius: BorderRadius.circular(16),
            child: SwitchListTile(
              key: const Key('vibrate-alarm'),
              title: Text(l10n.vibrateWithAlarm),
              value: widget.controller.vibrateOnAlarm,
              onChanged: (value) => widget.controller.setVibrateOnAlarm(value),
            ),
          ),
          const SizedBox(height: 12),
          Material(
            color: appCard(context),
            borderRadius: BorderRadius.circular(16),
            child: SwitchListTile(
              key: const Key('dark-mode'),
              title: Text(l10n.darkMode),
              value: widget.controller.darkMode,
              onChanged: (value) => widget.controller.setDarkMode(value),
            ),
          ),
          const SizedBox(height: 16),
          _SectionLabel(l10n.language),
          const SizedBox(height: 8),
          _LanguageTile(
            key: const Key('language-en'),
            label: l10n.languageEnglish,
            selected: code == 'en',
            onTap: () => widget.controller.setLanguage('en'),
          ),
          _LanguageTile(
            key: const Key('language-pt'),
            label: l10n.languagePortuguese,
            selected: code == 'pt',
            onTap: () => widget.controller.setLanguage('pt'),
          ),
          _LanguageTile(
            key: const Key('language-es'),
            label: l10n.languageSpanish,
            selected: code == 'es',
            onTap: () => widget.controller.setLanguage('es'),
          ),
          const SizedBox(height: 16),
          Text(l10n.savedOnDevice, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: appMuted(context))),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({super.key, required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? AppColors.sky.withValues(alpha: 0.35) : appCard(context),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800))),
                if (selected) const Icon(Icons.check_circle, color: AppColors.teal),
              ],
            ),
          ),
        ),
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
  final _player = MelodyPlayer();
  final _vibration = AlarmVibration();
  final _pitch = PitchCapture();
  final _shake = ShakeToStop();
  final _prompt = WakePrompt();
  Timer? _phaseTimer;
  bool _playing = true;
  bool _shaking = false;
  bool _holdInstead = false;
  Timer? _holdTimer;
  int _failures = 0;
  int _generation = 0;
  HummingOutcome? _outcome;
  List<int> _notes = const [];

  @override
  void initState() {
    super.initState();
    unawaited(widget.controller.releaseNativeLoop());
    if (widget.controller.vibrateOnAlarm) unawaited(_vibration.start());
    _shake.start(() {
      unawaited(widget.controller.stopRinging());
    }, onUnavailable: () {
      if (mounted) setState(() => _holdInstead = true);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _beginCycle();
    });
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _holdTimer?.cancel();
    _shake.stop();
    unawaited(_vibration.stop());
    _pulse.dispose();
    unawaited(_player.dispose());
    super.dispose();
  }

  List<int> _plannedNotes() {
    final profile = widget.controller.melodyProfile();
    final count = _failures >= 5 ? 3 : noteCountFor(widget.alarm.difficulty);
    return fitMelody(
      contour: contourFor(widget.alarm.melodyId),
      noteCount: count,
      safeMin: profile.safeMin,
      safeMax: profile.safeMax,
    );
  }

  void _beginCycle() {
    if (!mounted || widget.controller.ringingAlarm == null) return;
    if (_failures >= 10) {
      _enterShake();
      return;
    }
    final notes = _plannedNotes();
    setState(() {
      _playing = true;
      _shaking = false;
      _notes = notes;
    });
    unawaited(_player.playNotes(notes, alarm: true));
    _phaseTimer?.cancel();
    _phaseTimer = Timer(Duration(milliseconds: notes.length * 400), () => _listen(notes));
  }

  Future<void> _listen(List<int> notes) async {
    if (!mounted || widget.controller.ringingAlarm == null) return;
    final generation = ++_generation;
    setState(() => _playing = false);
    await _player.stop();
    final heard = await _pitch.listenContour(maxDuration: Duration(milliseconds: notes.length * 400 + 3000));
    if (!mounted || generation != _generation || widget.controller.ringingAlarm == null) return;
    final match = widget.controller.humming.evaluate(
      melodyId: widget.alarm.melodyId,
      difficulty: notes.length <= 3 ? 'Easy' : widget.alarm.difficulty,
      tolerance: _failures >= 5 ? 'Relaxed' : widget.alarm.tolerance,
      semitones: heard,
      shape: [for (final note in notes) note.toDouble()],
    );
    if (match.outcome == HummingOutcome.matched) {
      await widget.controller.stopRinging();
      return;
    }
    _failures++;
    if (mounted) setState(() => _outcome = match.outcome);
    _beginCycle();
  }

  void _enterShake() {
    if (_shaking) return;
    _phaseTimer?.cancel();
    unawaited(_player.stop());
    setState(() {
      _shaking = true;
      _playing = false;
    });
    unawaited(_prompt.speak(Localizations.localeOf(context).languageCode));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final alarm = widget.alarm;
    final outcome = _outcome;
    final feedback = switch (outcome) {
      HummingOutcome.missed => _failures >= 5 ? l10n.easierMelody : l10n.humMissed(toleranceLabel(l10n, alarm.tolerance)),
      HummingOutcome.tooShort => l10n.humTooShort,
      _ => null,
    };
    return Material(
      color: AppColors.deep,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset('assets/images/logo.png', width: 48, height: 48),
              ),
              const SizedBox(height: 12),
              Text(
                formatClockLocalized(l10n, alarm.hour, alarm.minute, use24Hour: widget.controller.use24Hour),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                _shaking ? l10n.shakeToStop : (_playing ? l10n.melodyPlaying : l10n.humItBack),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.sky,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _pulse,
                builder: (context, _) {
                  return Icon(
                    _shaking ? Icons.vibration : Icons.graphic_eq,
                    size: 36 + (_pulse.value * 8),
                    color: AppColors.amber,
                  );
                },
              ),
              Text(
                melodyTitle(l10n, alarm.melodyId),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const Spacer(),
              Text(
                l10n.shakeAlways,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.sky,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              if (feedback != null && !_shaking)
                Text(
                  feedback,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.amber,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              if (_holdInstead)
                GestureDetector(
                  key: const Key('hold-to-stop'),
                  onTapDown: (_) {
                    _holdTimer?.cancel();
                    _holdTimer = Timer(const Duration(seconds: 4), () {
                      unawaited(widget.controller.stopRinging());
                    });
                  },
                  onTapUp: (_) => _holdTimer?.cancel(),
                  onTapCancel: () => _holdTimer?.cancel(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: AppColors.amber,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Text(
                      l10n.holdToStop,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.deep,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                ),
              if (_notes.isNotEmpty && !_shaking)
                Text(
                  _notes.map(midiName).join('  '),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.sky),
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
