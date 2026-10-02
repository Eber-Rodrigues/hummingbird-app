import 'package:flutter/material.dart';
import 'package:hummingbird/l10n/app_localizations.dart';

import 'src/controller.dart';
import 'src/screens.dart';
import 'src/setup_flow.dart';
import 'src/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HummingbirdApp());
}

class HummingbirdApp extends StatefulWidget {
  const HummingbirdApp({super.key, this.decisionAfter = const Duration(minutes: 2)});

  final Duration decisionAfter;

  @override
  State<HummingbirdApp> createState() => _HummingbirdAppState();
}

class _HummingbirdAppState extends State<HummingbirdApp> {
  late final AlarmController _controller = AlarmController(decisionAfter: widget.decisionAfter);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onController);
    _controller.load();
  }

  void _onController() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onController);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hummingbird',
      debugShowCheckedModeBanner: false,
      locale: Locale(_controller.languageCode),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: _controller.darkMode ? ThemeMode.dark : ThemeMode.light,
      builder: (context, child) {
        return PhoneFrame(
          child: Stack(
            children: [
              child ?? const SizedBox.shrink(),
              if (_controller.ringingAlarm != null)
                RingingScreen(
                  controller: _controller,
                  alarm: _controller.ringingAlarm!,
                ),
            ],
          ),
        );
      },
      home: !_controller.ready
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : !_controller.isReadyForHome
              ? SetupFlow(controller: _controller)
              : ShellScreen(controller: _controller),
    );
  }
}
