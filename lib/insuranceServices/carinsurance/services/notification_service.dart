import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static void showNotification(
      FlutterLocalNotificationsPlugin plugin, RemoteMessage message) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    plugin.show(
      0,
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? 'You have received a new notification.',
      platformChannelSpecifics,
      payload: 'submission',
    );
  }
}
