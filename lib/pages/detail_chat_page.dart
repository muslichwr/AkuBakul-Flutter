import 'package:flutter/material.dart';
import '../theme.dart';
import 'dart:async';
import '../widgets/chat_bubble.dart';

class DetailChatPage extends StatefulWidget {
  final String chatName;
  const DetailChatPage({super.key, required this.chatName});

  @override
  State<DetailChatPage> createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [];

  // Simulasi status online/offline dan waktu terakhir online
  bool isOnline = true;
  DateTime lastOnline = DateTime.now().subtract(const Duration(minutes: 3));
  Timer? _timer;

  // Simulasi produk yang sedang ditanyakan
  Map<String, String>? askedProduct = {
    'name': 'iPhone 15 Pro Max',
    'price': 'Rp 25.000.000',
    'image': 'assets/image_shoes.png',
  };

  @override
  void initState() {
    super.initState();
    // Dummy chat: user menanyakan produk, admin membalas, user membalas lagi
    messages = [
      {
        'fromMe': true,
        'text': '',
        'time': '09:00',
        'isProductQuestion': true,
        'product': {
          'name': 'iPhone 15 Pro Max',
          'price': 'Rp 25.000.000',
          'image': 'assets/image_shoes.png',
        },
      },
      {
        'fromMe': false,
        'text': 'Barang tersedia kak, silakan lanjutkan pemesanan.',
        'time': '09:01',
        'isProductQuestion': false,
      },
      {
        'fromMe': true,
        'text': 'Bisa COD?',
        'time': '09:02',
        'isProductQuestion': false,
      },
    ];
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        isOnline = false;
        lastOnline = DateTime.now();
      });
    });
    // Scroll ke bawah setelah build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToLatest());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _scrollToLatest() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _sendMessage({String? quickReply}) {
    final text = quickReply ?? _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add({
        'fromMe': true,
        'text': text,
        'time': 'Now',
        'isProductQuestion': false,
      });
      _controller.clear();
    });
    _scrollToLatest();
    // Simulasi balasan admin
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        messages.add({
          'fromMe': false,
          'text': 'Terima kasih, kami akan segera proses.',
          'time': 'Now',
          'isProductQuestion': false,
        });
      });
      _scrollToLatest();
    });
  }

  String getLastOnlineText() {
    final diff = DateTime.now().difference(lastOnline);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Black,
      appBar: AppBar(
        backgroundColor: Cyan50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            widget.chatName.toLowerCase().contains('toko')
                ? ClipOval(
                  child: Image.asset(
                    'assets/icon_shoplogo.jpg',
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                )
                : const Icon(
                  Icons.support_agent,
                  color: Colors.white,
                  size: 32,
                ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatName,
                  style: primaryTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      isOnline ? Icons.circle : Icons.circle_outlined,
                      color: isOnline ? Cyan : Grey150,
                      size: 10,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isOnline
                          ? 'Online'
                          : 'Offline • Terakhir online ${getLastOnlineText()}',
                      style: secondaryTextStyle.copyWith(
                        fontSize: 12,
                        color: isOnline ? Cyan : Grey150,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                messages.isEmpty
                    ? Center(
                      child: Text(
                        'Belum ada pesan',
                        style: secondaryTextStyle.copyWith(fontSize: 15),
                      ),
                    )
                    : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return ChatBubble(
                          text: msg['text'] ?? '',
                          isMe: msg['fromMe'] ?? false,
                          time: msg['time'] ?? '',
                          isProductQuestion: msg['isProductQuestion'] ?? false,
                          product: msg['product'],
                        );
                      },
                    ),
          ),
          if (askedProduct != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Black,
                border: Border.all(color: Grey100, width: 0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          askedProduct!['image']!,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              askedProduct!['name']!,
                              style: primaryTextStyle.copyWith(
                                fontWeight: medium,
                                fontSize: 13,
                                color: White,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              askedProduct!['price']!,
                              style: secondaryTextStyle.copyWith(
                                fontSize: 12,
                                color: Grey100,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Quick reply di bawah harga
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      minimumSize: Size(0, 28),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      backgroundColor: Cyan30.withOpacity(0.12),
                                      foregroundColor: Cyan,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed:
                                        () => _sendMessage(
                                          quickReply: 'Apakah barang tersedia?',
                                        ),
                                    child: const Text(
                                      'Apakah barang tersedia?',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      minimumSize: Size(0, 28),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      backgroundColor: Cyan30.withOpacity(0.12),
                                      foregroundColor: Cyan,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed:
                                        () => _sendMessage(
                                          quickReply: 'Ada stok?',
                                        ),
                                    child: const Text(
                                      'Ada stok?',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      minimumSize: Size(0, 28),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      backgroundColor: Cyan30.withOpacity(0.12),
                                      foregroundColor: Cyan,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed:
                                        () => _sendMessage(
                                          quickReply: 'Bisa COD?',
                                        ),
                                    child: const Text(
                                      'Bisa COD?',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          askedProduct = null;
                        });
                      },
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Grey50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Container(
            color: Cyan50,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: primaryTextStyle.copyWith(fontSize: 15),
                            decoration: InputDecoration(
                              hintText: 'Tulis pesan...',
                              hintStyle: secondaryTextStyle.copyWith(
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.emoji_emotions, color: Grey150),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Cyan,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
