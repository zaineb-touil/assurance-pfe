import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:insurance_pfe/auth/signup.dart';
import 'package:insurance_pfe/insuranceServices/healthinsurance/controllers/health_insurance_controller.dart';
import 'package:insurance_pfe/insuranceServices/healthinsurance/views/health_insurance_view.dart';
import 'package:insurance_pfe/insuranceServices/healthinsurance/views/stripe_payment_page.dart';
import 'package:insurance_pfe/insuranceServices/homeinsurance/views/home_insurance_view.dart';
import 'package:insurance_pfe/insuranceServices/lifeinsurance/views/life_insurance_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Onboboarding/onboarding_view.dart';
import 'auth/login.dart';
import 'editProfile.dart';
import 'historique.dart';
import 'homepage.dart';
import 'insuranceServices/carinsurance/views/car_insurance_view.dart';
import 'nos_agences.dart';
import 'notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await saveNotificationToFirestore(message);
  print('Handling a background message: ${message.messageId}');
}

Future<void> saveNotificationToFirestore(RemoteMessage message) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': user.uid,
        'title': message.notification?.title ?? 'No title',
        'body': message.notification?.body ?? 'No body',
        'timestamp': Timestamp.now(),
      });
      print("Notification saved to Firestore");
    } else {
      print("No user is logged in");
    }
  } catch (e) {
    print("Error saving notification to Firestore: $e");
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey =
      'pk_test_51Ohy7OL6Yy5J7SIThZYg8qaV58w4xNPWHQAwKH976vYL8VJZimNvtzy3o4Yq69eIl6lJj5AuItkvcFwMBvqhdVfd00XG2Cfvzx';

  await initializeDateFormatting('fr_FR', null);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text("Error initializing app"),
              ),
            ),
          );
        } else {
          final onboarding = snapshot.data as bool;
          return MyAppContent(onboarding: onboarding);
        }
      },
    );
  }

  Future<bool> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("onboarding") ?? false;
  }
}

class MyAppContent extends StatefulWidget {
  final bool onboarding;
  const MyAppContent({super.key, required this.onboarding});

  @override
  State<MyAppContent> createState() => _MyAppContentState();
}

class _MyAppContentState extends State<MyAppContent> {
  late FirebaseMessaging _messaging;
  late String _token;

  @override
  void initState() {
    super.initState();
    _listenToAuthState();
    _initializeFirebaseMessaging();
  }

  void _listenToAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  void _initializeFirebaseMessaging() {
    _messaging = FirebaseMessaging.instance;

    _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a foreground message');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              '@mipmap/ic_launcher',
              'high_importance_channel',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    _messaging.getToken().then((String? token) {
      assert(token != null);
      setState(() {
        _token = token!;
      });
      print('Token: $_token');
    });
  }

  void _sendInitializationNotification() {
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
    flutterLocalNotificationsPlugin.show(
      0,
      'App Initialized',
      'Welcome to the app!',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          titleTextStyle: TextStyle(
            color: Colors.orange,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.orange),
        ),
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: _determineHome(),
      routes: {
        "signup": (context) => SignUp(),
        "login": (context) => Login(),
        "homepage": (context) => Homepage(),
        "editProfile": (context) => EditProfile(),
        "nosagences": (context) => Nosagences(),
        "historique": (context) => HistoriqueScreen(),
        "health": (context) => HealthInsuranceView(),
        "life": (context) => LifeInsuranceView(),
        "home": (context) => HomeInsuranceView(),
        "car": (context) => CarInsuranceView(),
        "notifications": (context) => NotificationScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/payment') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return StripePaymentPage(
                total: args['total'],
                controller: args['controller'],
              );
            },
          );
        }
        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => Homepage());
      },
    );
  }

  Widget _determineHome() {
    if (!widget.onboarding) {
      return OnboardingView();
    } else {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        return Homepage();
      } else {
        return Login();
      }
    }
  }
}
