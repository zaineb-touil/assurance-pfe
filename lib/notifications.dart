import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _markAllNotificationsAsRead();
  }

  Future<void> _markAllNotificationsAsRead() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('notifications').get();

    final WriteBatch batch = FirebaseFirestore.instance.batch();
    for (final DocumentSnapshot doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              color: Color(0xFFf38f1d),
              selectedColor: Color.fromARGB(255, 255, 255, 255),
              fillColor: Color(0xFFf38f1d),
              borderColor: Color(0xFFf38f1d),
              selectedBorderColor: Color(0xFFf38f1d),
              borderWidth: 2,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("Toutes"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("Non lues"),
                )
              ],
              isSelected: [_selectedIndex == 0, _selectedIndex == 1],
              onPressed: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var notifications = snapshot.data!.docs
                    .map((doc) => NotificationItem.fromDocument(doc))
                    .toList();
                var currentNotifications = _selectedIndex == 0
                    ? notifications
                    : notifications
                        .where((notification) => !notification.isRead)
                        .toList();

                if (currentNotifications.isEmpty) {
                  return Center(
                    child: Text(
                      'Vous n\'avez pas de notifications',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: currentNotifications.length,
                  itemBuilder: (context, index) {
                    var notification = currentNotifications[index];

                    return Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      color:
                          notification.isRead ? Colors.white : Colors.grey[200],
                      child: ListTile(
                        leading: Stack(
                          children: [
                            Icon(notification.icon, color: notification.color),
                            if (!notification.isRead)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Icon(
                                  Icons.brightness_1,
                                  size: 10,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          notification.title,
                          style: TextStyle(
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold),
                        ),
                        subtitle: Text(notification.description),
                        trailing: notification.status != null
                            ? Text(
                                notification.status!,
                                style: TextStyle(
                                  color: notification.color,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: ''),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Handle bottom navigation item tap
        },
      ),
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? status;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.status,
    this.isRead = false,
  });

  factory NotificationItem.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String,
        dynamic>?; // Typecast the data to Map<String, dynamic> and handle nullability
    return NotificationItem(
      id: doc.id,
      title: data?['title'] ??
          'No Title', // Using the null-aware operator to provide default values
      description: data?['body'] ?? 'No Description',
      icon: Icons.notifications, // Customize this based on your data
      color: Colors.blue, // Customize this based on your data
      isRead: data?['isRead'] ?? false,
      status: data?['status'],
    );
  }
}
