import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class Reminder {
  late final String? id;
  String? parentId;
  final String title;
  final String? description;
  late final DateTime? createdAt;
  final DateTime? date;
  final Repeat repeat;
  final int? category;
  late final DateTime? completedAt;

  Reminder({
    required this.title,
    this.parentId,
    this.description,
    this.date,
    this.repeat = Repeat.never,
    this.category,
  }) {
    id = const Uuid().v4();
    createdAt = DateTime.now();
  }

  void addChild(Reminder child) {
    child.parentId = id;
  }

  void removeChild(Reminder child) {
    child.parentId = null;
  }

  Reminder.fromMap(Map<String, dynamic> data)
      : id = data['id'] ?? Uuid().v1(),
        title = data['title'],
        parentId = data['parentId'],
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
      'parentId': parentId,
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
