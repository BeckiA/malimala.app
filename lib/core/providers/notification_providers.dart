import 'package:flutter/material.dart';
import 'package:waloma/core/model/notification_model/UserNotificcation.dart';

class NotificationProvider extends ChangeNotifier {
  List<UserNotification> _notifications = [];
  int _unreadCount = 0;

  List<UserNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  void setNotifications(List<Map<String, dynamic>> notifications) {
    _notifications = notifications.map<UserNotification>((notification) {
      return UserNotification.fromJson(notification);
    }).toList();

    _unreadCount = _notifications.where((n) => !n.isRead).length;
    notifyListeners();
  }
}
