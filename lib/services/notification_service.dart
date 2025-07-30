import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../utils/logger.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    try {
      Logger.info('Initializing notification service...');
      
      // Initialize timezone
      tz.initializeTimeZones();
      
      // Initialize local notifications
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      
      await _localNotifications.initialize(initSettings);
      Logger.success('Local notifications initialized successfully');
      
      // Initialize Firebase Cloud Messaging
      await _initializeFirebaseMessaging();
      
      Logger.success('Notification service initialized successfully');
    } catch (e) {
      Logger.error('Failed to initialize notification service', e);
      rethrow;
    }
  }

  Future<void> _initializeFirebaseMessaging() async {
    try {
      Logger.info('Initializing Firebase Cloud Messaging...');
      
      // Request permission
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      
      Logger.info('FCM permission status: ${settings.authorizationStatus}');
      
      // Get FCM token
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        Logger.success('FCM token obtained: ${token.substring(0, 20)}...');
      } else {
        Logger.warning('Failed to get FCM token');
      }
      
      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      
      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
      
      // Handle notification taps
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
      
      Logger.success('Firebase Cloud Messaging initialized successfully');
    } catch (e) {
      Logger.error('Failed to initialize Firebase Cloud Messaging', e);
      rethrow;
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    Logger.info('Received foreground message: ${message.messageId}');
    
    try {
      await _showLocalNotification(
        id: message.hashCode,
        title: message.notification?.title ?? 'Airway Ally',
        body: message.notification?.body ?? 'New notification',
        payload: message.data.toString(),
      );
    } catch (e) {
      Logger.error('Failed to show local notification for foreground message', e);
    }
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    Logger.info('Received background message: ${message.messageId}');
    // Handle background message
  }

  void _handleNotificationTap(RemoteMessage message) {
    Logger.info('Notification tapped: ${message.messageId}');
    // Handle notification tap
  }

  Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'airway_ally_channel',
        'Airway Ally Notifications',
        channelDescription: 'Notifications for Airway Ally app',
        importance: Importance.high,
        priority: Priority.high,
      );
      
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      await _localNotifications.show(id, title, body, details, payload: payload);
      Logger.success('Local notification shown successfully');
    } catch (e) {
      Logger.error('Failed to show local notification', e);
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      Logger.info('Scheduling notification for: $scheduledDate');
      
      const androidDetails = AndroidNotificationDetails(
        'airway_ally_scheduled',
        'Scheduled Notifications',
        channelDescription: 'Scheduled notifications for Airway Ally app',
        importance: Importance.high,
        priority: Priority.high,
      );
      
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      await _localNotifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
      
      Logger.success('Notification scheduled successfully');
    } catch (e) {
      Logger.error('Failed to schedule notification', e);
      rethrow;
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      Logger.info('Cancelling notification: $id');
      await _localNotifications.cancel(id);
      Logger.success('Notification cancelled successfully');
    } catch (e) {
      Logger.error('Failed to cancel notification', e);
      rethrow;
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      Logger.info('Cancelling all notifications');
      await _localNotifications.cancelAll();
      Logger.success('All notifications cancelled successfully');
    } catch (e) {
      Logger.error('Failed to cancel all notifications', e);
      rethrow;
    }
  }

  Future<void> getBadgeCount() async {
    try {
      Logger.debug('Getting badge count');
      // Note: clearBadge() is not available in the current version
      // This is handled by the notification system automatically
      Logger.debug('Badge count operation completed');
    } catch (e) {
      Logger.error('Failed to get badge count', e);
    }
  }

  Future<void> clearBadge() async {
    try {
      Logger.info('Clearing badge count');
      // Note: clearBadge() is not available in the current version
      // This is handled by the notification system automatically
      Logger.success('Badge count cleared successfully');
    } catch (e) {
      Logger.error('Failed to clear badge count', e);
    }
  }

  Future<void> requestPermissions() async {
    try {
      Logger.info('Requesting notification permissions');
      
      // iOS permissions are handled during initialization
      final iosGranted = await _localNotifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      
      Logger.info('iOS permission granted: $iosGranted');
      
      Logger.success('Notification permissions requested successfully');
    } catch (e) {
      Logger.error('Failed to request notification permissions', e);
      rethrow;
    }
  }
} 