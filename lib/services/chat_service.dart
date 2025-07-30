import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/logger.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserConversations() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      Logger.warning('No authenticated user found for chat conversations');
      return Stream.value([]);
    }

    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: currentUser.uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id,
                'name': data['name'] ?? 'Unknown',
                'last': data['lastMessage'] ?? 'No messages',
                'time': _formatTime(data['lastMessageTime'] as Timestamp?),
                'unread': data['unreadCount'] ?? 0,
                'isOnline': data['isOnline'] ?? false,
                'avatar': data['avatar'] ?? 'U',
              };
            }).toList());
  }

  Stream<List<Map<String, dynamic>>> getConversationMessages(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id,
                'text': data['text'] ?? '',
                'senderId': data['senderId'] ?? '',
                'timestamp': (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
                'isRead': data['isRead'] ?? false,
              };
            }).toList());
  }

  Future<void> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        Logger.error('No authenticated user found for sending message');
        throw Exception('User not authenticated');
      }

      Logger.info('Sending message to conversation: $conversationId');

      // Add message to conversation
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add({
        'text': text,
        'senderId': currentUser.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      // Update conversation metadata
      await _firestore.collection('conversations').doc(conversationId).update({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadCount': FieldValue.increment(1),
      });

      Logger.success('Message sent successfully');
    } catch (e) {
      Logger.error('Failed to send message', e);
      rethrow;
    }
  }

  Future<String> createConversation({
    required String name,
    required List<String> participantIds,
  }) async {
    try {
      Logger.info('Creating new conversation: $name');

      final docRef = await _firestore.collection('conversations').add({
        'name': name,
        'participants': participantIds,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadCount': 0,
      });

      Logger.success('Conversation created successfully: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      Logger.error('Failed to create conversation', e);
      rethrow;
    }
  }

  Future<void> markMessagesAsRead(String conversationId) async {
    try {
      Logger.info('Marking messages as read for conversation: $conversationId');

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        Logger.warning('No authenticated user found for marking messages as read');
        return;
      }

      // Mark all unread messages as read
      final messagesQuery = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .where('senderId', isNotEqualTo: currentUser.uid)
          .get();

      final batch = _firestore.batch();
      for (final doc in messagesQuery.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();

      // Reset unread count
      await _firestore.collection('conversations').doc(conversationId).update({
        'unreadCount': 0,
      });

      Logger.success('Messages marked as read successfully');
    } catch (e) {
      Logger.error('Failed to mark messages as read', e);
      rethrow;
    }
  }

  Stream<bool> getUserOnlineStatus(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.data()?['isOnline'] ?? false);
  }

  Future<void> updateOnlineStatus(bool isOnline) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        Logger.warning('No authenticated user found for updating online status');
        return;
      }

      Logger.info('Updating online status: $isOnline');

      await _firestore.collection('users').doc(currentUser.uid).update({
        'isOnline': isOnline,
        'lastActive': FieldValue.serverTimestamp(),
      });

      Logger.success('Online status updated successfully');
    } catch (e) {
      Logger.error('Failed to update online status', e);
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> searchConversations(String query) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      Logger.warning('No authenticated user found for searching conversations');
      return Stream.value([]);
    }

    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: currentUser.uid)
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: '$query\uf8ff')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id,
                'name': data['name'] ?? 'Unknown',
                'last': data['lastMessage'] ?? 'No messages',
                'time': _formatTime(data['lastMessageTime'] as Timestamp?),
                'unread': data['unreadCount'] ?? 0,
                'isOnline': data['isOnline'] ?? false,
                'avatar': data['avatar'] ?? 'U',
              };
            }).toList());
  }

  Future<List<Map<String, dynamic>>> getConversationParticipants(String conversationId) async {
    try {
      Logger.info('Getting participants for conversation: $conversationId');

      final doc = await _firestore.collection('conversations').doc(conversationId).get();
      if (!doc.exists) {
        Logger.warning('Conversation not found: $conversationId');
        return [];
      }

      final participantIds = List<String>.from(doc.data()?['participants'] ?? []);
      final participants = <Map<String, dynamic>>[];

      for (final userId in participantIds) {
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          participants.add({
            'id': userId,
            'name': userData['name'] ?? 'Unknown',
            'email': userData['email'] ?? '',
            'isOnline': userData['isOnline'] ?? false,
            'avatar': userData['avatar'] ?? 'U',
          });
        }
      }

      Logger.success('Retrieved ${participants.length} participants');
      return participants;
    } catch (e) {
      Logger.error('Failed to get conversation participants', e);
      rethrow;
    }
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    
    final now = DateTime.now();
    final messageTime = timestamp.toDate();
    final difference = now.difference(messageTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${messageTime.day}/${messageTime.month}/${messageTime.year}';
    }
  }
} 