import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class Reminder {
  late final String id;
  late List<Reminder>? children;
  final String title;
  late final String? description;
  late final DateTime? createdAt;
  final DateTime? date;
  final Repeat repeat;
  final int? category;
  late DateTime? completedAt;

  Reminder({
    required this.title,
    this.children = const [],
    this.description,
    this.date,
    this.repeat = Repeat.never,
    this.category,
  }) {
    id = const Uuid().v4();
    createdAt = DateTime.now();
    completedAt = null;
  }

  void addChild(Reminder child) {
    children!.add(child);
  }

  bool removeChild(Reminder child) {
    return children!.remove(child);
  }

  Reminder.fromMap(Map<String, dynamic> data)
      : id = data['id'] ?? const Uuid().v1(),
        title = data['title'],
        children = data['children'],
        description = data['description'],
        createdAt = (data['createdAt'] as Timestamp).toDate(),
        date = (data['date'] as Timestamp).toDate(),
        repeat = Repeat.values[data['repeat']],
        category = data['category'],
        completedAt = (data['completedAt'] as Timestamp).toDate();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'children': children,
      'description': description,
      'createdAt': createdAt,
      'date': date,
      'repeat': repeat.index,
      'category': category,
      'completedAt': completedAt,
    };
  }
}

enum Repeat {
  never,
  daily,
  weekly,
  monthly,
  yearly;
}
