import 'package:flutter/material.dart';

class Reminder {
  final int id;
  final String title;
  final String? description;
  final DateTime date;
  final TimeOfDay time;
  final Repeat repeat;
  final int? category;
  final bool isCompleted;
  final TimeOfDay? completedTime;
  final DateTime? completedAt;
  List<Reminder> children;

  Reminder({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    required this.time,
    required this.repeat,
    required this.category,
    this.completedTime,
    this.completedAt,
    this.isCompleted = false,
    this.children = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'time': time.toString(),
      'repeat': repeat.toString(),
      'category': category,
      'isCompleted': isCompleted,
      'completedTime': completedTime,
      'completedAt': completedAt,
      'children': children,
    };
  }

  void addChild(Reminder child) {
    children.add(child);
  }

  void removeChild(Reminder child) {
    children.remove(child);
  }
}

enum Repeat {
  never,
  daily,
  weekly,
  monthly,
  yearly,
}
