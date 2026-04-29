import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isNew;

  const NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.isNew = false,
  });
}
