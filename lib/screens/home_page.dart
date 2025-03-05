import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:test_app/constants/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.themeColor,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 45, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test App',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 15),
                  screenWidth < 600
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildButtons(),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildButtons(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildButtons() {
    return [
      InkWell(
        onTap: _requestLocationPermission,
        child: Container(
          alignment: Alignment.center,
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.buttonColor1,
          ),
          child: Text(
            'Request Location Permission',
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      SizedBox(height: 15),
      InkWell(
        onTap: _requestNotificationPermission,
        child: Container(
          alignment: Alignment.center,
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.buttonColor2,
          ),
          child: Text(
            'Request Notification Permission',
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      SizedBox(height: 15),
      InkWell(
        onTap: () => locationStart('Test App'),
        child: Container(
          alignment: Alignment.center,
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.buttonColor3,
          ),
          child: Text(
            'Start Location Update',
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      SizedBox(height: 15),
      InkWell(
        onTap: () => locationStop('Test App'),
        child: Container(
          alignment: Alignment.center,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.buttonColor4,
          ),
          child: Text(
            'Stop Location Update',
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    ];
  }

  Future<void> locationStart(String s) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Update'),
          content: Text('Do you want to start location updates?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog before showing notification

                const AndroidNotificationDetails androidDetails =
                AndroidNotificationDetails(
                  'Test App',
                  'Test App',
                  importance: Importance.max,
                  priority: Priority.high,
                );

                const NotificationDetails notificationDetails =
                NotificationDetails(android: androidDetails);

                await flutterLocalNotificationsPlugin.show(
                  0,
                  s,
                  'Location update started',
                  notificationDetails,
                  payload: 'notification_payload',
                );
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  Future<void> locationStop(String s) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'Test App',
      'Test App',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      s,
      'Location update stopped',
      notificationDetails,
      payload: 'notification_payload',
    );
  }

  Future<void> _requestLocationPermission() async {
    if (await Permission.location.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location Permission Already Granted')),
      );
      return;
    }

    var status = await Permission.location.request();

    if (status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location Permission Granted')),
      );
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location Permission Denied')),
      );
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Location Permission Permanently Denied. Enable it in settings.')),
      );
      openAppSettings();
    }
  }

  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification Permission Already Granted')),
      );
      return;
    }

    var status = await Permission.notification.request();

    if (status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification Permission Granted')),
      );
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification Permission Denied')),
      );
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Notification Permission Permanently Denied. Enable it in settings.')),
      );
      openAppSettings();
    }
  }
}
