import 'package:flutter/material.dart';

import 'src/controller.dart';
import 'src/screens.dart';
import 'src/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HummingbirdApp());
}

class HummingbirdApp extends StatefulWidget {
  const HummingbirdApp({super.key});

  @override
  State<HummingbirdApp> createState() => _HummingbirdAppState();
}

class _HummingbirdAppState extends State<HummingbirdApp> {
  final AlarmController _controller = AlarmController();

  @override
  void initState() {
    super.initState();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hummingbird',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      builder: (context, child) {
        return PhoneFrame(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Stack(
                children: [
                  child ?? const SizedBox.shrink(),
                  if (_controller.ringingAlarm != null)
                    RingingScreen(
                      controller: _controller,
                      alarm: _controller.ringingAlarm!,
                    ),
                ],
              );
            },
          ),
        );
      },
      home: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (!_controller.ready) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (!_controller.onboarded) {
            return WelcomeFlow(controller: _controller);
          }
          return ShellScreen(controller: _controller);
        },
      ),
    );
  }
}
