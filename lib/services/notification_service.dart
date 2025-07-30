import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone data
      tz.initializeTimeZones();
      
      // Request permission for iOS
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print('User granted permission: ${settings.authorizationStatus}');

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification taps
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Get initial message if app was opened from notification
      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      // Get FCM token
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        print('FCM Token: $token');
        // TODO: Send token to your backend
      }

      // Token refresh listener
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        print('FCM Token refreshed: $newToken');
        // TODO: Send new token to your backend
      });

      _isInitialized = true;
      print('Notification service initialized successfully');
    } catch (e) {
      print('Error initializing notification service: $e');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle local notification tap
    print('Local notification tapped: ${response.payload}');
    // TODO: Navigate to appropriate screen based on payload
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Received foreground message: ${message.messageId}');
    
    // Show local notification
    await _showLocalNotification(
      id: message.hashCode,
      title: message.notification?.title ?? 'New Message',
      body: message.notification?.body ?? '',
      payload: json.encode(message.data),
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    print('Notification tapped: ${message.messageId}');
    print('Data: ${message.data}');
    
    // TODO: Navigate to appropriate screen based on message data
    // Example:
    // if (message.data['type'] == 'chat') {
    //   Navigator.pushNamed(context, '/chat', arguments: message.data['chatId']);
    // }
  }

  Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'airway_ally_channel',
      'Airway Ally Notifications',
      channelDescription: 'Notifications for Airway Ally app',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Send local notification
  Future<void> sendLocalNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    await _showLocalNotification(
      id: id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      payload: payload,
    );
  }

  // Schedule local notification
  Future<void> scheduleLocalNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    int? id,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'airway_ally_scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'Scheduled notifications for Airway Ally app',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _localNotifications.zonedSchedule(
      id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  // Get badge count
  Future<int> getBadgeCount() async {
    return await _localNotifications.getNotificationAppLaunchDetails().then((details) {
      return details?.notificationResponse?.payload != null ? 1 : 0;
    });
  }

  // Clear badge
  Future<void> clearBadge() async {
    // Note: clearBadge() is not available in FlutterLocalNotificationsPlugin
    // This would need to be handled platform-specific or through Firebase Messaging
    print('Badge clearing not implemented - would need platform-specific implementation');
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }

  // Send test notification
  Future<void> sendTestNotification() async {
    await sendLocalNotification(
      title: 'Test Notification',
      body: 'This is a test notification from Airway Ally',
      payload: json.encode({'type': 'test', 'timestamp': DateTime.now().toIso8601String()}),
    );
  }

  // Send flight reminder notification
  Future<void> sendFlightReminder({
    required String flightNumber,
    required String departureTime,
    required String gate,
  }) async {
    await sendLocalNotification(
      title: 'Flight Reminder',
      body: 'Flight $flightNumber departs in 2 hours. Gate: $gate',
      payload: json.encode({
        'type': 'flight_reminder',
        'flightNumber': flightNumber,
        'departureTime': departureTime,
        'gate': gate,
      }),
    );
  }

  // Send chat notification
  Future<void> sendChatNotification({
    required String senderName,
    required String message,
    required String chatId,
  }) async {
    await sendLocalNotification(
      title: 'New message from $senderName',
      body: message,
      payload: json.encode({
        'type': 'chat',
        'chatId': chatId,
        'senderName': senderName,
      }),
    );
  }

  // Send matching notification
  Future<void> sendMatchingNotification({
    required String type, // 'request' or 'match'
    required String message,
  }) async {
    await sendLocalNotification(
      title: type == 'request' ? 'New Help Request' : 'Match Found!',
      body: message,
      payload: json.encode({
        'type': 'matching',
        'subtype': type,
      }),
    );
  }

  // Send document reminder
  Future<void> sendDocumentReminder({
    required String documentType,
    required String dueDate,
  }) async {
    await sendLocalNotification(
      title: 'Document Reminder',
      body: 'Your $documentType is due on $dueDate',
      payload: json.encode({
        'type': 'document_reminder',
        'documentType': documentType,
        'dueDate': dueDate,
      }),
    );
  }
}

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');
  print('Data: ${message.data}');
  
  // You can perform background tasks here
  // For example, update local storage, sync data, etc.
}

// Notification types
class NotificationTypes {
  static const String flightReminder = 'flight_reminder';
  static const String chat = 'chat';
  static const String matching = 'matching';
  static const String documentReminder = 'document_reminder';
  static const String general = 'general';
}

// Notification channels
class NotificationChannels {
  static const String general = 'airway_ally_channel';
  static const String scheduled = 'airway_ally_scheduled_channel';
  static const String urgent = 'airway_ally_urgent_channel';
} 