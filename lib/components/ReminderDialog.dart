import 'package:flutter/material.dart';

import '../logic/reminder.dart';
import '../pages/reminder.dart';

class ReminderDialog extends StatefulWidget {

  @override
  _ReminderDialogState createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _descriptionFieldController =
      TextEditingController();
  DateTime? _dueDate;
  DateTime currentDate = DateTime.now();

  void _saveReminder(Reminder reminder) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await reminder.storeInFirestore().whenComplete(() => () {
            setState(() {
              ReminderPage.reminders.add(reminder);
            });
          });

      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _errorMessage = "An error occured while saving the reminder";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a task to your list'),
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
                initialDate: currentDate,
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
              child: Text(showTime(_dueDate)),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        // add button
        TextButton(
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('ADD'),
          onPressed: () async {
            String? description;
            if (_descriptionFieldController.text.isNotEmpty) {
              description = _descriptionFieldController.text;
            }

            _saveReminder(
              Reminder(
                title: _textFieldController.text,
                description: description,
                date: _dueDate,
                createdAt: DateTime.now(),
              ),
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
