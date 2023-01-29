import 'dart:math';

import 'package:flutter/material.dart';

class Reminder {
  late final int id;
  int? parentId;
  final String title;
  final String? description;
  late final DateTime createdAt;
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
    id = Random().nextInt(100);
    createdAt = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'date': date?.toIso8601String(),
      'repeat': repeat.toString(),
      'category': category,
      'completedAt': completedAt,
      'parent': parentId,
    };
  }

  void addChild(Reminder child) {
    child.parentId = id;
  }

  void removeChild(Reminder child) {
    child.parentId = null;
  }
}

enum Repeat {
  never,
  daily,
  weekly,
  monthly,
  yearly,
}
