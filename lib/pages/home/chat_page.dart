import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/chat_tile.dart';
import '../../services/message_service.dart';
import '../../models/message_model.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'dart:developer' as developer;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final MessageService _messageService = MessageService();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initChatPage();
  }

  void _initChatPage() async {
    try {
      // Gunakan AuthProvider untuk mendapatkan user yang sedang login
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      developer.log('ChatPage - Error initializing: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat pesan. Silakan coba lagi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          _isLoading
              ? _buildLoadingState()
              : _errorMessage != null
              ? _buildErrorState()
              : _buildChatContent(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Cyan)),
          const SizedBox(height: 16),
          Text(
            'Memuat pesan...',
            style: primaryTextStyle.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Red, size: 60),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'Terjadi kesalahan',
            style: primaryTextStyle.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 160,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _initChatPage();
              },
              child: Text(
                'Coba Lagi',
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 16,
                  color: Black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatContent() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Jika user belum login, tampilkan pesan untuk login
        if (authProvider.user == null) {
          return _buildLoginPrompt();
        }

        // Gunakan StreamBuilder untuk menampilkan data yang realtime
        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: _messageService.getChatRooms(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            if (snapshot.hasError) {
              developer.log(
                'ChatPage - StreamBuilder error: ${snapshot.error}',
              );

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Red, size: 50),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak dapat terhubung ke database',
                        style: primaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semibold,
                          color: White,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Silakan periksa koneksi internet Anda dan coba lagi',
                        style: secondaryTextStyle.copyWith(
                          fontSize: 14,
                          color: Grey100,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          _initChatPage();
                        },
                        icon: Icon(Icons.refresh, color: Black, size: 18),
                        label: Text(
                          'Coba Lagi',
                          style: primaryTextStyle.copyWith(color: Black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Cyan,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/detail-chat');
                        },
                        child: Text(
                          'Mulai Chat Baru',
                          style: primaryTextStyle.copyWith(
                            color: Cyan,
                            fontWeight: medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Jika tidak ada data chat, tampilkan empty state
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState(context);
            }

            // Data chat rooms sudah tersedia
            final chatRooms = snapshot.data!;

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              itemCount: chatRooms.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final room = chatRooms[index];

                return ChatTile(
                  name: 'Admin',
                  lastMessage: room['lastMessage'] ?? 'Tidak ada pesan',
                  time: room['lastMessageTime'] ?? '',
                  onTap: () {
                    // Ambil user_id dari room ID (format: user_123)
                    String roomId = room['id'] ?? '';

                    Navigator.pushNamed(
                      context,
                      '/detail-chat',
                      arguments: {'chatName': 'Toko AkuBakul'},
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_circle_outlined, color: Cyan, size: 60),
          const SizedBox(height: 16),
          Text(
            'Login untuk melihat chat',
            style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Silakan login untuk melihat\nriwayat chat Anda',
            style: secondaryTextStyle.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 160,
            height: 44,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/sign-in');
              },
              icon: const Icon(Icons.login, color: Colors.black),
              label: Text(
                'Login',
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 16,
                  color: Black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Cyan.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 60,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum ada pesan',
            style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Yuk, mulai chat dengan support kami\natau eksplor toko untuk belanja!',
            style: secondaryTextStyle.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 160,
            height: 44,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/detail-chat');
              },
              icon: const Icon(Icons.chat, color: Colors.black),
              label: Text(
                'Mulai Chat',
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 16,
                  color: Black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 160,
            height: 44,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Cyan),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Navigasi ke halaman Home/Store
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: Icon(Icons.storefront, color: White),
              label: Text(
                'Explore Store',
                style: primaryTextStyle.copyWith(
                  fontWeight: medium,
                  fontSize: 16,
                  color: White,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
