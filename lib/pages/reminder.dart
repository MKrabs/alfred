import 'package:alfred/logic/reminder.dart';
import 'package:flutter/material.dart';

class ReminderPage extends StatefulWidget {
  final Color bgc;
  final String nbr;

  const ReminderPage({super.key, required this.bgc, required this.nbr});

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
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  Future<void> _addReminder() async {
    print("Hello");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: ReminderPage.reminders.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == ReminderPage.reminders.length) {
                      return addReminderButton();
                    }
                    return reminderCard(index);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addReminderButton() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 150,
        left: 32,
        right: 32,
      ),
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.new_label_rounded),
        label: const Text("Add"),
      ),
    );
  }

  Widget reminderCard(int index) {
    return Card(
      child: ListTile(
        title: Text(ReminderPage.reminders[index].title),
        subtitle: Text(
            "${ReminderPage.reminders[index].description}"),
        trailing: Text(ReminderPage.reminders[index].date.weekday.toString()),
        onTap: () {
          showReminder(context, index);
        },
      ),
    );
  }

  void showReminder(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: [
            ListTile(
              title: Text(ReminderPage.reminders[index].title),
              subtitle:
                  Text(ReminderPage.reminders[index].date.year.toString()),
              // Text(ReminderPage
              //     .reminders[index].date.month
              //     .toString()),
              // Text(ReminderPage.reminders[index].date.day
              //     .toString()),
              // Text(ReminderPage.reminders[index].time.hour
              //     .toString()),
              // Text(ReminderPage
              //     .reminders[index].time.minute
              //     .toString()),
              // Text(ReminderPage.reminders[index].repeat
              //     .toString()),
            ),
          ],
        );
      },
    );
  }
}