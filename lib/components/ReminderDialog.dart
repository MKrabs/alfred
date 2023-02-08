import 'package:flutter/material.dart';

import '../logic/reminder.dart';
import '../logic/timeformat.dart';
import '../pages/reminder.dart';

class ReminderDialog extends StatefulWidget {
  final Reminder? rem;

  const ReminderDialog({super.key, this.rem});

  @override
  _ReminderDialogState createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  Reminder? reminder;
  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _descriptionFieldController =
      TextEditingController();
  DateTime? _dueDate;
  DateTime currentDate = DateTime.now();

  void _saveReminder(Reminder reminder, {Reminder? update}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (update != null) {
        await update.updateReminder(reminder);
      } else {
        await reminder.storeInFirestore().whenComplete(() => () {
              setState(() {
                ReminderPage.reminders.add(reminder);
              });
            });
      }
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _errorMessage = "An error occured while saving the reminder";
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    reminder = widget.rem;
    _textFieldController.text = "${reminder?.title}";
    if (reminder?.description != null) {
      _descriptionFieldController.text = "${reminder?.description}";
    }
    if (reminder?.date != null) {
      _dueDate = reminder?.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: (reminder == null)
          ? const Text('Add a task to your list')
          : Text("Edit: ${reminder!.title}", maxLines: 1),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Enter task here'),
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
                initialDate: _dueDate ?? currentDate,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                // ignore: use_build_context_synchronously
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
              child: Text(TimeFormat.formatDate(_dueDate)),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        // add button
        TextButton(
          child: _isLoading
              ? const CircularProgressIndicator()
              : reminder == null
                  ? const Text('ADD')
                  : const Text("UPDATE"),
          onPressed: () async {
            _saveReminder(
              Reminder(
                title: _textFieldController.text,
                description: _descriptionFieldController.text,
                date: _dueDate,
                createdAt: DateTime.now(),
              ),
              update: reminder,
            );
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
  }

  void clearAll() {
    _textFieldController.clear();
    _descriptionFieldController.clear();
    _dueDate = null;
    currentDate = DateTime.now();
  }
}
