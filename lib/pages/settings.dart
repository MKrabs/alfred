import 'package:alfred/logic/reminder.dart';
import 'package:flutter/material.dart';

import '../components/switch.dart';

class SettingsPage extends StatefulWidget {
  final Color bgc;
  final String nbr;

  const SettingsPage({super.key, required this.bgc, required this.nbr});

  static List<Reminder> reminders = [
    Reminder(
      id: 0,
      title: "One",
      description: "Description 1",
      date: DateTime(2023, 01, 23),
      time: const TimeOfDay(hour: 14, minute: 28),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      id: 1,
      title: "Two",
      description: "Description two but a bit longer",
      date: DateTime(2023, 01, 24),
      time: const TimeOfDay(hour: 14, minute: 31),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      id: 2,
      title: "tree",
      date: DateTime(2023, 01, 25),
      time: const TimeOfDay(hour: 14, minute: 28),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      id: 0,
      title: "One",
      description:
          "Description 3 but it's very very very very very very very long",
      date: DateTime(2023, 01, 26),
      time: const TimeOfDay(hour: 14, minute: 28),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      id: 1,
      title: "Two",
      description: "Description two but a bit longer",
      date: DateTime(2023, 01, 27),
      time: const TimeOfDay(hour: 14, minute: 31),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      id: 2,
      title: "tree",
      date: DateTime(2023, 01, 22),
      time: const TimeOfDay(hour: 14, minute: 28),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      id: 0,
      title: "One",
      description: "Description 1",
      date: DateTime(2023, 01, 21),
      time: const TimeOfDay(hour: 14, minute: 28),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      id: 1,
      title: "Two",
      description: "Description two but a bit longer",
      date: DateTime(2023, 01, 28),
      time: const TimeOfDay(hour: 14, minute: 31),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      id: 2,
      title: "tree",
      date: DateTime(2023, 01, 28),
      time: const TimeOfDay(hour: 14, minute: 28),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      id: 0,
      title: "One",
      description: "Description 1",
      date: DateTime(2023, 01, 29),
      time: const TimeOfDay(hour: 14, minute: 28),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      id: 1,
      title: "Two",
      description: "Description two but a bit longer",
      date: DateTime(2023, 01, 23),
      time: const TimeOfDay(hour: 14, minute: 31),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      id: 2,
      title: "tree",
      date: DateTime(2023, 01, 23),
      time: const TimeOfDay(hour: 14, minute: 28),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      id: 0,
      title: "One",
      description: "Description 1",
      date: DateTime(2023, 01, 23),
      time: const TimeOfDay(hour: 14, minute: 28),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      id: 1,
      title: "Two",
      description: "Description much longer !!",
      date: DateTime(2023, 01, 23),
      time: const TimeOfDay(hour: 14, minute: 31),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      id: 2,
      title: "tree",
      date: DateTime(2023, 01, 23),
      time: const TimeOfDay(hour: 14, minute: 28),
      repeat: Repeat.weekly,
      category: 1,
    ),
  ];

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Color bgc;
  bool light0 = true;
  dynamic light1;
  bool light2 = true;

  @override
  void initState() {
    super.initState();
    bgc = widget.bgc;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgc,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SafeArea(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ReorderableListView(
                    onReorder: (int oldIndex, int newIndex) {},
                    children: [
                      SwitchListTile(
                        key: const ValueKey(12),
                        title: Text("Settings $light0"),
                        value: light0,
                        onChanged: (bool value) {
                          setState(() {
                            light0 = value;
                          });
                        },
                      ),
                      const ListTile(
                        key: ValueKey(13),
                        title: Text("Settings"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
