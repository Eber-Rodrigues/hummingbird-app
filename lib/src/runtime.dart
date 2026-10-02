import 'package:flutter/widgets.dart';

bool get isWidgetTest => WidgetsBinding.instance.runtimeType.toString().contains('Test');
