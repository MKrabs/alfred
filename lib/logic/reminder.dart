import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Reminder {
  late final String? id;
  late List<Tasks>? children;
  final String title;
  late final String? description;
  late final DateTime? createdAt;
  final DateTime? date;
  late DateTime? completedAt;

  Reminder({
    this.id,
    required this.title,
    this.children = const [],
    this.description,
    this.date,
    this.completedAt,
    this.createdAt,
  });

  void addChild(Tasks child) {
    children!.add(child);
  }

  bool removeChild(Tasks child) {
    return children!.remove(child);
  }

  Future<void> storeInFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .collection("reminders")
        .add({
      "title": title,
      "description": description,
      "createdAt": createdAt,
      "date": date,
      "completedAt": completedAt,
      "tasks": children
          ?.map((task) =>
      {
        "title": task.title,
        "description": task.description,
        "done": task.done,
      })
          .toList(),
    });
  }

  static Future<List<Reminder>> readReminders() async {
    List<Reminder> reminders = [];
    final user = FirebaseAuth.instance.currentUser;

    var snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .collection("reminders")
        .get();

    for (var doc in snap.docs) {
      var data = doc.data();
      List<Tasks> tasks = [];
      for (var task in (data["tasks"] as List)) {
        tasks.add(Tasks(
          title: task["title"],
          description: task["description"],
          done: task["done"],
        ));
      }
      reminders.add(Reminder(
        id: doc.id,
        title: data["title"],
        description: data["description"],
        createdAt: data["createdAt"] != null
            ? (data["createdAt"] as Timestamp).toDate()
            : null,
        date:
        data["date"] != null ? (data["date"] as Timestamp).toDate() : null,
        completedAt: data["completedAt"] != null
            ? (data["completedAt"] as Timestamp).toDate()
            : null,
        children: tasks,
      ));
    }

    return reminders;
  }

  Future<DateTime?> updateCompletion(DateTime? dateTime) async {
    final user = FirebaseAuth.instance.currentUser;

    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .collection("reminders")
        .doc(id);

    await docRef.update({
      "completedAt": dateTime,
    });

    return dateTime;
  }
}

class Tasks {
  final String title;
  final String? description;
  late bool done;

  Tasks({
    required this.title,
    this.description,
    this.done = false,
  });
}
