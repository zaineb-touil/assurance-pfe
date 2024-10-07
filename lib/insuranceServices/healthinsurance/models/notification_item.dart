import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? status;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.status,
    this.isRead = false,
  });

  factory NotificationItem.fromDocument(DocumentSnapshot doc) {
    return NotificationItem(
      title: doc['title'],
      description: doc['body'],
      icon: Icons.notifications,
      color: Colors.blue,
      isRead: doc['isRead'] ?? false,
      status: doc['status'],
    );
  }
}
