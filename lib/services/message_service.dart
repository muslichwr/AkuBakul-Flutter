import 'package:akubakul/models/product_model.dart';
import 'package:akubakul/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:akubakul/models/message_model.dart';
import 'dart:developer' as developer;

class MessageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Fungsi untuk menambahkan pesan baru
  Future<void> addMessage({
    required UserModel user,
    required bool isFromUser,
    required String message,
    ProductModel? product,
    Map<String, dynamic>? productData,
  }) async {
    try {
      // Buat data pesan dasar
      Map<String, dynamic> messageData = {
        'isFromUser': isFromUser,
        'message': message,
        'time': _formatTimeForMessage(),
        'timestamp':
            FieldValue.serverTimestamp(), // Menggunakan server timestamp
      };

      // Tambahkan data produk jika ada
      if (productData != null) {
        messageData['product'] = productData;
        messageData['isProductQuestion'] = message.isEmpty;
      } else if (product != null) {
        // Extract data produk yang relevan
        final extractedProductData = {
          'id': product.id.toString(),
          'name': product.name,
          'price': product.price.toString(),
          'image': product.galleries.isNotEmpty ? product.galleries[0].url : '',
          'category': product.category.name,
          'tags': product.tags,
          'description': product.description,
        };
        messageData['product'] = extractedProductData;
        messageData['isProductQuestion'] = message.isEmpty;
      } else {
        messageData['isProductQuestion'] = false;
      }

      // Simpan pesan dalam chat room berdasarkan user_id
      // Ini menghindari kebutuhan untuk query dengan filter AND sort
      String chatId = 'user_${user.id}';

      await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(messageData)
          .then(
            (_) => developer.log('Pesan berhasil ditambahkan ke room $chatId'),
          );

      // Update info chat room
      await firestore.collection('chats').doc(chatId).set({
        'userId': user.id,
        'userName': user.name,
        'userImage': user.profilePhotoUrl,
        'lastMessage': message.isEmpty ? 'Menanyakan tentang produk' : message,
        'lastMessageTime': _formatTimeForMessage(),
        'lastUpdated': FieldValue.serverTimestamp(),
        'unreadCount': 0, // Bisa digunakan nanti untuk notifikasi
      }, SetOptions(merge: true));

      return;
    } catch (e) {
      developer.log('Error mengirim pesan: $e');
      throw Exception('Pesan gagal dikirim: $e');
    }
  }

  // Format waktu untuk ditampilkan di chat
  String _formatTimeForMessage() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  // Mendapatkan pesan untuk user tertentu
  Stream<List<MessageModel>> getMessagesByUserId(String userId) {
    try {
      // Gunakan struktur baru yang tidak memerlukan composite index
      String chatId = 'user_$userId';

      return firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy(
            'timestamp',
            descending: false,
          ) // Ini hanya memerlukan single field index
          .snapshots()
          .map((QuerySnapshot snapshot) {
            var result =
                snapshot.docs.map<MessageModel>((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;

                  // Konversi data Firestore ke MessageModel
                  return MessageModel(
                    message: data['message'] ?? '',
                    time: data['time'] ?? _formatTimeForMessage(),
                    isFromMe: data['isFromUser'] ?? false,
                    isProductQuestion: data['isProductQuestion'] ?? false,
                    productData: data['product'],
                  );
                }).toList();

            return result;
          });
    } catch (e) {
      developer.log('Gagal mengambil pesan: $e');
      // Kembalikan stream kosong jika terjadi error
      return Stream.value([]);
    }
  }

  // Mendapatkan daftar chat room untuk halaman chat
  Stream<List<Map<String, dynamic>>> getChatRooms() {
    try {
      return firestore
          .collection('chats')
          .orderBy('lastUpdated', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList();
          });
    } catch (e) {
      developer.log('Gagal mengambil daftar chat: $e');
      return Stream.value([]);
    }
  }
}
