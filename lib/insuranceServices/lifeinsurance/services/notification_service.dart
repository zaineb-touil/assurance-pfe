import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class NotificationService1 {
  static Future<void> sendNotification(
      {required String title, required String message}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': user.uid,
        'title': title,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }
}
