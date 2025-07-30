import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class DocumentsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get real-time stream of user documents
  Stream<List<Map<String, dynamic>>> getUserDocuments() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('documents')
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'category': data['category'] ?? 'Other',
          'size': data['size'] ?? '0 MB',
          'uploadDate': (data['uploadDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          'type': data['type'] ?? 'pdf',
          'isImportant': data['isImportant'] ?? false,
          'url': data['url'] ?? '',
          'isRealData': true,
        };
      }).toList();
    });
  }

  // Add new document
  Future<void> addDocument({
    required String name,
    required String category,
    required File file,
    bool isImportant = false,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      // Upload file to Firebase Storage
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_$name';
      final storageRef = _storage.ref().child('documents/${user.uid}/$fileName');
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Save document info to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('documents')
          .add({
        'name': name,
        'category': category,
        'size': '${(file.lengthSync() / 1024 / 1024).toStringAsFixed(1)} MB',
        'uploadDate': Timestamp.now(),
        'type': _getFileType(name),
        'isImportant': isImportant,
        'url': downloadUrl,
      });
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  // Update document
  Future<void> updateDocument({
    required String documentId,
    String? name,
    String? category,
    bool? isImportant,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (category != null) updates['category'] = category;
    if (isImportant != null) updates['isImportant'] = isImportant;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('documents')
        .doc(documentId)
        .update(updates);
  }

  // Delete document
  Future<void> deleteDocument(String documentId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      // Get document data to delete from storage
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('documents')
          .doc(documentId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        final url = data['url'] as String?;
        
        if (url != null && url.isNotEmpty) {
          // Delete from Firebase Storage
          final storageRef = _storage.refFromURL(url);
          await storageRef.delete();
        }
      }

      // Delete from Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('documents')
          .doc(documentId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  // Get document categories
  List<String> getCategories() {
    return [
      'All',
      'Travel Documents',
      'Flight Documents',
      'Accommodation',
      'Health Documents',
      'Insurance',
      'Other',
    ];
  }

  // Get file type from filename
  String _getFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'pdf';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return 'image';
      case 'doc':
      case 'docx':
        return 'document';
      case 'xls':
      case 'xlsx':
        return 'spreadsheet';
      default:
        return 'other';
    }
  }

  // Search documents
  Stream<List<Map<String, dynamic>>> searchDocuments(String query) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('documents')
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'name': data['name'] ?? '',
              'category': data['category'] ?? 'Other',
              'size': data['size'] ?? '0 MB',
              'uploadDate': (data['uploadDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
              'type': data['type'] ?? 'pdf',
              'isImportant': data['isImportant'] ?? false,
              'url': data['url'] ?? '',
              'isRealData': true,
            };
          })
          .where((doc) =>
              doc['name'].toLowerCase().contains(query.toLowerCase()) ||
              doc['category'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Filter documents by category
  Stream<List<Map<String, dynamic>>> getDocumentsByCategory(String category) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    if (category == 'All') {
      return getUserDocuments();
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('documents')
        .where('category', isEqualTo: category)
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'category': data['category'] ?? 'Other',
          'size': data['size'] ?? '0 MB',
          'uploadDate': (data['uploadDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          'type': data['type'] ?? 'pdf',
          'isImportant': data['isImportant'] ?? false,
          'url': data['url'] ?? '',
          'isRealData': true,
        };
      }).toList();
    });
  }
} 