import 'package:alfred/logic/reminder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReminderPage extends StatefulWidget {
  final Color bgc;
  final String nbr;

  const ReminderPage({super.key, required this.bgc, required this.nbr});

  static List<Reminder> reminders =  [
    Reminder(
      title: "First",
      description: "Description 1",
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      title: "Two",
      description: "Description two but a bit longer",
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      title: "tree",
      date: DateTime(2023, 01, 25, 14, 28),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      title: "One",
      description:
      "Description 3 but it's very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very long",
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      title: "Two",
      description: "Description two but a bit longer",
      date: DateTime(2023, 01, 27, 14, 31),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      title: "tree",
      date: DateTime(2023, 02, 22, 14, 28),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      title: "One",
      description: "Description 1",
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      title: "Two",
      description: "Description two but a bit longer",
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      title: "tree",
      date: DateTime(2023, 02, 28, 14, 28),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      title: "One",
      description: "Description 1",
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      title: "Two",
      description: "Description two but a bit longer",
      date: DateTime(2023, 02, 23, 14, 31),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      title: "tree",
      date: DateTime(2023, 02, 23, 14, 28),
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      title: "One",
      description: "Description 1",
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      title: "Two",
      description: "Description much longer !!",
      repeat: Repeat.weekly,
      category: 1,
    ),
    Reminder(
      title: "Last",
      date: DateTime(2023, 03, 23, 14, 28),
      repeat: Repeat.weekly,
      category: 1,
    ),
  ];

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final user = FirebaseAuth.instance.currentUser;

  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _descriptionFieldController =
      TextEditingController();
  final ScrollController _scrollController = ScrollController();

  DateTime? _dueDate;
  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: ReminderPage.reminders.length + 2,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return ListTile(
                  title: Text(
                    "Hello, ${user?.displayName}",
                    textScaleFactor: 2,
                  ),
                  contentPadding: const EdgeInsets.only(top: 30, left: 16),
                );
              }

              if (index == ReminderPage.reminders.length + 1) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    splashColor: Colors.amberAccent.withOpacity(0.7),
                    child: ListTile(
                      title: const Text("Add"),
                      trailing: const Icon(Icons.add_box_rounded),
                      onTap: () {
                        _displayDialog(context);
                      },
                    ),
                  ),
                );
              }

              index -= 1;

              return reminderCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget reminderCard(int index) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.brown.withOpacity(0.7),
        child: ListTile(
          title: Text(ReminderPage.reminders[index].title),
          subtitle: Text(
            "${ReminderPage.reminders[index].description}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.donut_large),
        ),
        onTap: () {
          showReminder(context, index);
        },
      ),
    );
  }

  Future<Future> _displayDialog(BuildContext context, [int? parentId]) async {
    void clearAll() {
      _textFieldController.clear();
      _descriptionFieldController.clear();
      _dueDate = null;
      currentDate = DateTime.now();
    }

    void addReminder(Reminder reminder) {
      setState(() {
        ReminderPage.reminders.add(reminder);
      });
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: const Text('Add a task to your list'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _textFieldController,
                    decoration:
                        const InputDecoration(hintText: 'Enter task here'),
                    validator: (String? value) {
                      return (value == null || value == '')
                          ? 'Field should not be empty.'
                          : null;
                    },
                  ),
                  TextField(
                    controller: _descriptionFieldController,
                    decoration: const InputDecoration(hintText: 'Description'),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: currentDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child!,
                            );
                          },
                        );
                        if (time != null) {
                          setState(() {
                            _dueDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("${showTime(_dueDate)}"),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                // add button
                TextButton(
                  child: const Text('ADD'),
                  onPressed: () async {
                    Navigator.of(context).pop();

                    String? description;
                    if (_descriptionFieldController.text.isNotEmpty) {
                      description = _descriptionFieldController.text;
                    }

                    addReminder(
                      Reminder(
                        title: _textFieldController.text,
                        description: description,
                        date: _dueDate,
                        parentId: parentId,
                      ),
                    );

                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );

                    clearAll();
                  },
                ), // cancel button
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    clearAll();
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  void showReminder(BuildContext context, int index) {
    showModalBottomSheet(
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height / 2,
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  ReminderPage.reminders[index].title,
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineMedium?.fontSize),
                ),
                trailing: const Icon(Icons.title),
              ),
              ListTile(
                trailing: const Icon(Icons.calendar_today_outlined),
                title: Text(
                  "${ReminderPage.reminders[index].createdAt.year}"
                  "/${ReminderPage.reminders[index].createdAt.month}"
                  "/${ReminderPage.reminders[index].createdAt.day}"
                  " - ${ReminderPage.reminders[index].createdAt.hour}"
                  ":${ReminderPage.reminders[index].createdAt.minute}",
                ),
              ),
              ListTile(
                title: Text(
                  ReminderPage.reminders[index].repeat.name.toString(),
                ),
                trailing: const Icon(Icons.event_repeat),
              ),
              ListTile(
                title: Text(
                  ReminderPage.reminders[index].description ?? "No description",
                ),
                trailing: const Icon(Icons.info_outline),
              ),
            ],
          ),
        );
      },
    );
  }

  String showTime(DateTime? dueDate) {
    if (dueDate == null) {
      return "no Date";
    }

    var buffer = StringBuffer();

    final difference = dueDate.difference(currentDate).inDays;
    if (difference < 7) {
      buffer.write("in $difference days");
    } else if (difference < 365) {
      final months = difference ~/ 30;
      buffer.write("in $months months");
    } else {
      buffer.write("$dueDate");
    }

    buffer.write(
      " - ${dueDate.hour.toString().padLeft(2, '0')}:${dueDate.minute.toString().padLeft(2, '0')}",
    );

    return buffer.toString();
  }
}
