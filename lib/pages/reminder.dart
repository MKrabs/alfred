import 'package:alfred/logic/reminder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alfred/components/ReminderDialog.dart';

class ReminderPage extends StatefulWidget {
  final Color bgc;
  final String nbr;

  const ReminderPage({super.key, required this.bgc, required this.nbr});

  static List<Reminder> reminders = [];

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
  void initState() {
    super.initState();
    updateReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await updateReminders();
            },
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
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ReminderDialog();
                            },
                          ).then((value) => () {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 330),
                                  curve: Curves.easeInOut,
                                );
                              });
                          await updateReminders();
                        },
                      ),
                    ),
                  );
                }

                index -= 1;

                return reminderCard(
                  ReminderPage.reminders[index],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> updateReminders() async {
    var reminders = await Reminder.readReminders();
    setState(() {
      ReminderPage.reminders = reminders;
    });
  }

  Widget reminderCard(Reminder reminder) {
    return Card(
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(10),
              bottom: Radius.circular(reminder.children!.isNotEmpty ? 0 : 10),
            ),
            splashColor: Colors.brown.withOpacity(0.7),
            child: ListTile(
              title: Text(reminder.title),
              subtitle: Text(
                "${reminder.description}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: InkWell(
                onTap: () async {
                  var completion = await reminder.updateCompletion(
                    DateTime.now(),
                  );
                  setState(() {
                    reminder.completedAt = completion;
                  });
                },
                onLongPress: () async {
                  var completion = await reminder.updateCompletion(null);
                  setState(() {
                    reminder.completedAt = completion;
                  });
                },
                child: Icon(
                  reminder.completedAt != null
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                ),
              ),
            ),
            onTap: () {
              showReminder(context, reminder);
            },
          ),
          if (reminder.children!.isNotEmpty)
            Column(
              children: [
                Divider(
                  indent: 16,
                  endIndent: 16,
                  height: 1,
                  color: Theme.of(context).dividerColor.withOpacity(0.2),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reminder.children!.length,
                  itemBuilder: (context, childIndex) {
                    if (childIndex == reminder.children!.length - 1) {}

                    return InkWell(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(
                          (childIndex == reminder.children!.length - 1)
                              ? 10
                              : 0,
                        ),
                      ),
                      child: ListTile(
                        dense: true,
                        title: Text(reminder.children![childIndex].title),
                        trailing: InkWell(
                          onTap: () {
                            setState(() {
                              reminder.children![childIndex].done =
                                  !reminder.children![childIndex].done;
                            });
                          },
                          child: Icon(
                            reminder.children![childIndex].done
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  void showReminder(BuildContext context, Reminder reminder) {
    showModalBottomSheet(
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              const SizedBox(height: 16),
              ListTile(
                dense: true,
                title: Text(
                  reminder.title,
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineMedium?.fontSize),
                ),
                trailing: const Icon(Icons.title),
              ),
              ListTile(
                trailing: Icon(
                  reminder.completedAt != null
                      ? Icons.event_available
                      : Icons.event_busy,
                ),
                title:
                    Text(formatDate(reminder.createdAt) ?? "No creation date."),
                subtitle: Text(formatDate(reminder.completedAt) ?? "Open"),
              ),
              ListTile(
                title: Text(
                  reminder.description ?? "No description",
                ),
                trailing: const Icon(Icons.info_outline),
              ),
              ListTile(
                title: Center(
                  child: Text(
                    reminder.id ?? "No id ???",
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                      color: Theme.of(context).hintColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                trailing: const Icon(Icons.fingerprint),
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

    buffer.write(
      "${dueDate.hour.toString().padLeft(2, '0')}:${dueDate.minute.toString().padLeft(2, '0')} - ",
    );

    final difference = dueDate.difference(currentDate).inDays;
    if (difference < 7) {
      buffer.write("in $difference days");
    } else if (difference < 365) {
      final months = difference ~/ 30;
      buffer.write("in $months months");
    } else {
      buffer.write("$dueDate");
    }

    return buffer.toString();
  }

  String? formatDate(DateTime? date) {
    if (date == null) {
      return null;
    }

    var buffer = StringBuffer();

    buffer.write(date.hour.toString().padLeft(2, '0'));
    buffer.write(":");
    buffer.write(date.minute.toString().padLeft(2, '0'));
    buffer.write(" - ");
    buffer.write(date.year.toString().padLeft(4, '0'));
    buffer.write("/");
    buffer.write(date.month.toString().padLeft(2, '0'));
    buffer.write("/");
    buffer.write(date.day.toString().padLeft(2, '0'));

    return buffer.toString();
  }
}
