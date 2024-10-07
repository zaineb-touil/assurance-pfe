import 'dart:async'; // Add this for StreamSubscription
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insurance_pfe/historique.dart';
import 'package:insurance_pfe/nos_agences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  User? user;
  Map<String, dynamic>? userData;
  int myCurrentIndex = 0;
  final _pageController = PageController(initialPage: 0);
  final _controller = NotchBottomBarController(index: 0);
  String userProfilepic = 'https://via.placeholder.com/150';
  String userProfilename = 'Utilisateur';
  bool _isLoading = true;
  int _unreadNotificationsCount = 0;
  StreamSubscription?
      _notificationSubscription; // Add this to manage the subscription

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    getToken();
    _startListeningToNotifications(); // Use this method instead of the previous fetch method
    loadData();
  }

  @override
  void dispose() {
    _notificationSubscription
        ?.cancel(); // Clean up the subscription when the widget is disposed
    super.dispose();
  }

  Future<void> loadData() async {
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() {
        userData = userDoc.data();
      });
    }
  }

  getToken() async {
    String? mytoken = await FirebaseMessaging.instance.getToken();
    print("-----------------------------------------");
    print(mytoken);
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userData.exists) {
          setState(() {
            userProfilename = userData['fullname'] ?? 'Utilisateur';
            userProfilepic = userData['profileImageUrl'] ??
                'https://via.placeholder.com/150';
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startListeningToNotifications() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _notificationSubscription = FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: user.uid)
          .where('isRead', isEqualTo: false)
          .snapshots()
          .listen((snapshot) {
        setState(() {
          _unreadNotificationsCount = snapshot.docs.length;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Redirect to login if user is not authenticated
    if (user == null || !user.emailVerified) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed("login");
      });
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    List<Widget> pages = [
      _buildHomePage(context, user),
      Nosagences(),
      HistoriqueScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? Center(
                child:
                    CircularProgressIndicator()) // Show loading spinner while fetching data
            : PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(pages.length, (index) => pages[index]),
              ),
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: Color.fromARGB(255, 255, 255, 255),
        showLabel: false,
        notchColor: const Color(0xFFF38F1D),
        removeMargins: false,
        bottomBarWidth: 500,
        durationInMilliSeconds: 300,
        bottomBarItems: [
          const BottomBarItem(
            inActiveItem: Icon(
              Icons.home,
              color: const Color(0xFFF38F1D),
            ),
            activeItem: Icon(
              Icons.home,
              color: Colors.white,
            ),
            itemLabel: 'Accueil',
          ),
          const BottomBarItem(
            inActiveItem: Icon(
              Icons.map,
              color: const Color(0xFFF38F1D),
            ),
            activeItem: Icon(
              Icons.map,
              color: Colors.white,
            ),
            itemLabel: 'Carte',
          ),
          const BottomBarItem(
            inActiveItem: Icon(
              Icons.history,
              color: const Color(0xFFF38F1D),
            ),
            activeItem: Icon(
              Icons.history,
              color: Colors.white,
            ),
            itemLabel: 'Historique',
          ),
        ],
        onTap: (index) {
          setState(() {
            myCurrentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        kIconSize: 20,
        kBottomRadius: 20,
      ),
    );
  }

  Widget _buildHomePage(BuildContext context, User user) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFF38F1D), const Color(0xFFEE5E1B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 255, 0, 0),
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),
            height: 150,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('editProfile');
                  },
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(userProfilepic),
                  ),
                ),
                SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bienvenue de retour',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      userProfilename,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pushNamed("notifications");
                      },
                    ),
                    if (_unreadNotificationsCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$_unreadNotificationsCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app, color: Colors.white),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("login", (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildGradientCard(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.withOpacity(0.9),
                        Colors.yellow.withOpacity(0.4)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    title: 'Assurance Santé',
                    subtitle: 'Voir toutes vos assurances ici',
                    icon: Icons.health_and_safety,
                    onTap: () {
                      Navigator.of(context).pushNamed('health');
                    },
                    imageUrl: 'images/health.jpg',
                  ),
                  _buildGradientCard(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withOpacity(0.9),
                        Colors.lightGreen.withOpacity(0.4)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    title: 'Assurance Auto',
                    subtitle: 'Voir toutes vos assurances ici',
                    icon: Icons.directions_car,
                    onTap: () {
                      Navigator.of(context).pushNamed('car');
                    },
                    imageUrl: 'images/images.jpeg',
                  ),
                  _buildGradientCard(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.9),
                        Colors.lightBlue.withOpacity(0.4)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    title: 'Assurance Habitation',
                    subtitle: 'Voir toutes vos assurances ici',
                    icon: Icons.home,
                    onTap: () {
                      Navigator.of(context).pushNamed('homepage');
                    },
                    imageUrl: 'images/home.jpeg',
                  ),
                  _buildGradientCard(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromRGBO(156, 39, 176, 1).withOpacity(0.9),
                        Colors.deepPurple.withOpacity(0.4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    title: 'Assurance Vie',
                    subtitle: 'Voir toutes vos assurances ici',
                    icon: Icons.favorite,
                    onTap: () {
                      Navigator.of(context).pushNamed('life');
                    },
                    imageUrl: 'images/life.jpeg',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientCard({
    required Gradient gradient,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
            gradient: gradient,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
              trailing: Icon(
                icon,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
