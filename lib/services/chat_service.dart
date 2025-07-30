import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get real-time conversations for current user
  Stream<List<Map<String, dynamic>>> getUserConversations() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: user.uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? 'Unknown',
          'last': data['lastMessage'] ?? '',
          'unread': data['unreadCount'] ?? 0,
          'time': _formatTime((data['lastMessageTime'] as Timestamp?)?.toDate()),
          'avatar': data['avatar'] ?? 'U',
          'isOnline': data['isOnline'] ?? false,
          'participants': data['participants'] ?? [],
          'isRealData': true,
        };
      }).toList();
    });
  }

  // Get real-time messages for a conversation
  Stream<List<Map<String, dynamic>>> getConversationMessages(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'text': data['text'] ?? '',
          'senderId': data['senderId'] ?? '',
          'senderName': data['senderName'] ?? '',
          'timestamp': (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          'isRead': data['isRead'] ?? false,
          'isRealData': true,
        };
      }).toList();
    });
  }

  // Send a message
  Future<void> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      // Add message to conversation
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add({
        'text': text,
        'senderId': user.uid,
        'senderName': user.displayName ?? user.email ?? 'Unknown',
        'timestamp': Timestamp.now(),
        'isRead': false,
      });

      // Update conversation with last message
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .update({
        'lastMessage': text,
        'lastMessageTime': Timestamp.now(),
        'lastSenderId': user.uid,
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Create a new conversation
  Future<String> createConversation({
    required String name,
    required List<String> participantIds,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      final docRef = await _firestore.collection('conversations').add({
        'name': name,
        'participants': participantIds,
        'createdBy': user.uid,
        'createdAt': Timestamp.now(),
        'lastMessage': '',
        'lastMessageTime': Timestamp.now(),
        'unreadCount': 0,
        'avatar': name.isNotEmpty ? name[0].toUpperCase() : 'C',
        'isOnline': false,
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create conversation: $e');
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String conversationId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Get unread messages
      final unreadMessages = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .where('senderId', isNotEqualTo: user.uid)
          .where('isRead', isEqualTo: false)
          .get();

      // Mark them as read
      final batch = _firestore.batch();
      for (final doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();

      // Update conversation unread count
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .update({'unreadCount': 0});
    } catch (e) {
      print('Failed to mark messages as read: $e');
    }
  }

  // Get user's online status
  Stream<bool> getUserOnlineStatus(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.data()?['isOnline'] ?? false);
  }

  // Update user's online status
  Future<void> updateOnlineStatus(bool isOnline) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({
        'isOnline': isOnline,
        'lastSeen': Timestamp.now(),
      });
    } catch (e) {
      print('Failed to update online status: $e');
    }
  }

  // Search conversations
  Stream<List<Map<String, dynamic>>> searchConversations(String query) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: user.uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'name': data['name'] ?? 'Unknown',
              'last': data['lastMessage'] ?? '',
              'unread': data['unreadCount'] ?? 0,
              'time': _formatTime((data['lastMessageTime'] as Timestamp?)?.toDate()),
              'avatar': data['avatar'] ?? 'U',
              'isOnline': data['isOnline'] ?? false,
              'participants': data['participants'] ?? [],
              'isRealData': true,
            };
          })
          .where((conv) =>
              conv['name'].toLowerCase().contains(query.toLowerCase()) ||
              conv['last'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Get conversation participants
  Future<List<Map<String, dynamic>>> getConversationParticipants(String conversationId) async {
    try {
      final doc = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .get();

      if (!doc.exists) return [];

      final data = doc.data()!;
      final participantIds = List<String>.from(data['participants'] ?? []);

      final participants = <Map<String, dynamic>>[];
      for (final userId in participantIds) {
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          participants.add({
            'id': userId,
            'name': userData['name'] ?? userData['email'] ?? 'Unknown',
            'avatar': userData['name']?.isNotEmpty == true 
                ? userData['name'][0].toUpperCase() 
                : 'U',
            'isOnline': userData['isOnline'] ?? false,
          });
        }
      }

      return participants;
    } catch (e) {
      print('Failed to get conversation participants: $e');
      return [];
    }
  }

  // Format time for display
  String _formatTime(DateTime? time) {
    if (time == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
} 