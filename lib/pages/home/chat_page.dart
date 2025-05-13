import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/chat_tile.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  // Ganti isi dummyChats di sini untuk mengatur tampilan
  final List<Map<String, String>> dummyChats = const [
    {
      'name': 'Admin Toko',
      'lastMessage': 'Pesanan Anda sudah dikirim.',
      'time': 'now', // Akan tampil 'Now'
    },
    {
      'name': 'Support',
      'lastMessage': 'Ada yang bisa kami bantu?',
      'time': 'baru saja', // Akan tampil 'Now'
    },
    {
      'name': 'Support',
      'lastMessage': 'Silakan cek email Anda.',
      'time': '10:00', // Akan tampil '10:00'
    },
  ];

  @override
  Widget build(BuildContext context) {
    bool isEmpty = dummyChats.isEmpty;
    return SafeArea(
      child: isEmpty ? _buildEmptyState(context) : _buildChatList(),
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
                // Navigasi ke halaman Home/Store
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: const Icon(Icons.storefront, color: Colors.white),
              label: Text(
                'Explore Store',
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      itemCount: dummyChats.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final chat = dummyChats[index];
        return ChatTile(
          name: chat['name']!,
          lastMessage: chat['lastMessage']!,
          time: chat['time']!,
        );
      },
    );
  }
}
