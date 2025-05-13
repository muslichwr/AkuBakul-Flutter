import 'package:flutter/material.dart';
import '../theme.dart';
import 'dart:async';
import '../widgets/chat_bubble.dart';
import 'dart:developer' as developer;
import '../services/message_service.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';

class DetailChatPage extends StatefulWidget {
  final String chatName;
  final Map<String, dynamic>? productData;

  const DetailChatPage({
    Key? key,
    this.chatName = 'Toko AkuBakul',
    this.productData,
  }) : super(key: key);

  @override
  State<DetailChatPage> createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final MessageService _messageService = MessageService();

  List<MessageModel> messages = [];
  Map<String, dynamic>? askedProduct;

  // Status
  bool isOnline = true;
  DateTime lastOnline = DateTime.now().subtract(const Duration(minutes: 3));
  Timer? _timer;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeProductData();
    _initializeChat();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          isOnline = false;
          lastOnline = DateTime.now();
        });
      }
    });
  }

  void _initializeProductData() {
    // Jika ada productData dari argumen, gunakan itu
    if (widget.productData != null) {
      developer.log(
        'DetailChatPage: Menerima data produk dari navigator arguments',
      );

      askedProduct = {
        'name': widget.productData!['productName'] ?? 'Produk',
        'price': _formatPrice(widget.productData!['productPrice']),
        'image':
            widget.productData!['productImage'] ?? 'assets/image_shoes.png',
        'id': widget.productData!['productId']?.toString() ?? '0',
      };

      developer.log(
        'DetailChatPage: Produk yang ditanyakan - ${askedProduct!['name']}',
      );
    }
  }

  void _initializeChat() {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user == null) {
        // Jika user belum login, tampilkan pesan dummy saja
        _initializeDummyChat();
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Jika user sudah login dan ada produk yang ditanyakan,
      // tambahkan pesan tanya produk ke Firebase jika belum ada
      if (askedProduct != null) {
        // Kirim pesan ke Firebase sebagai pertanyaan produk
        _sendProductQuestion();
      }

      // Setelah kirim, load pesan dari Firebase
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      developer.log('DetailChatPage - Error initializing chat: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Gagal memuat pesan: $e';
      });
      // Fallback ke chat dummy jika error
      _initializeDummyChat();
    }
  }

  void _initializeDummyChat() {
    if (askedProduct != null) {
      // Simulasikan chat tentang produk
      setState(() {
        messages = [
          MessageModel(
            message: '',
            time: _getCurrentTimeFormatted(),
            isFromMe: true,
            isProductQuestion: true,
            productData: askedProduct,
          ),
          MessageModel(
            message:
                'Halo! Terima kasih telah menghubungi kami tentang ${askedProduct!['name']}. Ada yang bisa kami bantu?',
            time: _getCurrentTimeFormatted(),
            isFromMe: false,
            isProductQuestion: false,
          ),
        ];
      });
    } else {
      // Chat baru tanpa produk
      setState(() {
        messages = [
          MessageModel(
            message: 'Halo! Ada yang bisa kami bantu?',
            time: _getCurrentTimeFormatted(),
            isFromMe: false,
            isProductQuestion: false,
          ),
        ];
      });
    }

    // Scroll ke pesan terakhir
    _scrollToLatest();
  }

  Future<void> _sendProductQuestion() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user == null) return;

      // Tambahkan product question ke Firestore
      await _messageService.addMessage(
        user: authProvider.user!,
        isFromUser: true,
        message: 'Saya tertarik dengan produk ini',
        product: null, // Kita gunakan productData langsung
        productData: askedProduct,
      );

      // Auto reply dari admin
      await Future.delayed(const Duration(seconds: 1));
      await _messageService.addMessage(
        user: authProvider.user!,
        isFromUser: false,
        message:
            'Halo! Terima kasih telah menghubungi kami tentang ${askedProduct!['name']}. Ada yang bisa kami bantu?',
        product: null,
      );
    } catch (e) {
      developer.log('DetailChatPage - Error sending product question: $e');
      // Pesan error - tidak perlu menampilkan ke user
    }
  }

  String _formatPrice(dynamic price) {
    if (price == null) return 'Rp 0';

    // Jika price sudah berupa string dan sudah diformat
    if (price is String && price.startsWith('Rp')) {
      return price;
    }

    // Jika price berupa angka, format ke Rupiah
    if (price is num) {
      return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
    }

    // Fallback
    return 'Rp 0';
  }

  String _getCurrentTimeFormatted() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLatest() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage({String? quickReply}) async {
    final text = quickReply ?? _controller.text.trim();
    if (text.isEmpty) return;

    final currentTime = _getCurrentTimeFormatted();

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Tambahkan pesan ke UI segera untuk responsivitas
      setState(() {
        messages.add(
          MessageModel(
            message: text,
            time: currentTime,
            isFromMe: true,
            isProductQuestion: false,
          ),
        );
        _controller.clear();
      });

      // Scroll ke pesan terakhir
      _scrollToLatest();

      // Kirim pesan ke Firebase jika user login
      if (authProvider.user != null) {
        try {
          await _messageService.addMessage(
            user: authProvider.user!,
            isFromUser: true,
            message: text,
            product: null,
          );
        } catch (e) {
          developer.log('Error saat mengirim pesan ke Firebase: $e');
          // Tetap lanjutkan dengan mode offline
        }
      }

      // Simulasi respons otomatis
      _simulateAdminResponse(text);
    } catch (e) {
      developer.log('DetailChatPage - Error sending message: $e');
      // Tampilkan snackbar error jika gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim pesan: $e'),
          backgroundColor: Red,
        ),
      );
    }
  }

  Future<void> _simulateAdminResponse(String userMessage) async {
    String response = 'Terima kasih atas pertanyaan Anda.';

    // Respons yang lebih natural berdasarkan pertanyaan
    if (userMessage.toLowerCase().contains('tersedia') ||
        userMessage.toLowerCase().contains('stok')) {
      response =
          'Ya, ${askedProduct?['name'] ?? 'produk'} masih tersedia dan siap dikirim.';
    } else if (userMessage.toLowerCase().contains('cod')) {
      response =
          'Ya, kami menerima COD untuk area tertentu. Mohon konfirmasi alamat pengiriman Anda.';
    } else if (userMessage.toLowerCase().contains('diskon') ||
        userMessage.toLowerCase().contains('promo')) {
      response =
          'Saat ini produk sedang ada promo diskon 10% untuk pembelian pertama.';
    } else if (userMessage.toLowerCase().contains('garansi')) {
      response = 'Produk ini memiliki garansi resmi selama 1 tahun.';
    }

    // Delay untuk simulasi ketikan
    await Future.delayed(const Duration(seconds: 2));

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Tambahkan pesan ke UI
      if (mounted) {
        setState(() {
          messages.add(
            MessageModel(
              message: response,
              time: _getCurrentTimeFormatted(),
              isFromMe: false,
              isProductQuestion: false,
            ),
          );
        });

        _scrollToLatest();
      }

      // Kirim pesan respons ke Firebase jika user login
      if (authProvider.user != null) {
        try {
          await _messageService.addMessage(
            user: authProvider.user!,
            isFromUser: false,
            message: response,
            product: null,
          );
        } catch (e) {
          developer.log('Error saat mengirim respons admin ke Firebase: $e');
          // Tetap lanjutkan dengan mode offline
        }
      }
    } catch (e) {
      developer.log('DetailChatPage - Error sending admin response: $e');
    }
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
      appBar: _buildAppBar(),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Cyan),
                ),
              )
              : errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: $errorMessage',
                      style: primaryTextStyle.copyWith(color: White),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _initializeChat,
                      style: ElevatedButton.styleFrom(backgroundColor: Cyan),
                      child: Text('Coba Lagi'),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  Expanded(child: _buildChatList()),
                  if (askedProduct != null) _buildProductBar(),
                  _buildMessageInput(),
                ],
              ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 36,
                      height: 36,
                      color: Cyan,
                      child: Icon(Icons.store, color: White, size: 20),
                    );
                  },
                ),
              )
              : const Icon(Icons.support_agent, color: Colors.white, size: 32),
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
      actions: [
        IconButton(
          icon: Icon(Icons.call, color: White),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Fitur panggilan belum tersedia'),
                backgroundColor: Cyan50,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChatList() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.user != null) {
          // Jika user login, gunakan stream dari Firebase
          return StreamBuilder<List<MessageModel>>(
            stream: _messageService.getMessagesByUserId(
              authProvider.user!.id.toString(),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  messages.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Cyan),
                  ),
                );
              }

              if (snapshot.hasError) {
                developer.log(
                  'DetailChatPage - StreamBuilder error: ${snapshot.error}',
                );

                // Tampilkan pesan error dan gunakan data lokal
                return Center(
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
                        'Menggunakan mode offline sementara',
                        style: secondaryTextStyle.copyWith(
                          fontSize: 14,
                          color: Grey100,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _initializeChat,
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
                    ],
                  ),
                );
              }

              // Gunakan data dari Firebase atau fallback ke data lokal
              final messagesList =
                  snapshot.hasData && snapshot.data!.isNotEmpty
                      ? snapshot.data!
                      : messages;

              if (messagesList.isEmpty) {
                return _buildEmptyChat();
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                itemCount: messagesList.length,
                itemBuilder: (context, index) {
                  final msg = messagesList[index];
                  return ChatBubble(
                    text: msg.message,
                    isMe: msg.isFromMe,
                    time: msg.time,
                    isProductQuestion: msg.isProductQuestion,
                    product: msg.productData,
                  );
                },
              );
            },
          );
        } else {
          // Jika user belum login, gunakan data lokal
          if (messages.isEmpty) {
            return _buildEmptyChat();
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              return ChatBubble(
                text: msg.message,
                isMe: msg.isFromMe,
                time: msg.time,
                isProductQuestion: msg.isProductQuestion,
                product: msg.productData,
              );
            },
          );
        }
      },
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 48, color: Grey150),
          const SizedBox(height: 12),
          Text(
            'Belum ada pesan',
            style: secondaryTextStyle.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            'Mulai chat dengan mengirim pesan',
            style: secondaryTextStyle.copyWith(fontSize: 13, color: Grey100),
          ),
        ],
      ),
    );
  }

  Widget _buildProductBar() {
    return Container(
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
                child: _buildProductImage(),
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
                    _buildQuickReplies(),
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
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    final imageUrl = askedProduct!['image']!;

    // Cek apakah gambar dari asset lokal atau URL
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: 36,
        height: 36,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    } else {
      // Gambar dari URL
      return Image.network(
        imageUrl,
        width: 36,
        height: 36,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 36,
            height: 36,
            color: Grey50,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Cyan),
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          developer.log('DetailChatPage: Error loading product image: $error');
          return _buildFallbackImage();
        },
      );
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      width: 36,
      height: 36,
      color: Grey50,
      child: Icon(Icons.image_not_supported_outlined, color: White, size: 16),
    );
  }

  Widget _buildQuickReplies() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildQuickReplyButton('Apakah barang tersedia?'),
          const SizedBox(width: 8),
          _buildQuickReplyButton('Ada stok?'),
          const SizedBox(width: 8),
          _buildQuickReplyButton('Bisa COD?'),
          const SizedBox(width: 8),
          _buildQuickReplyButton('Ada promo?'),
        ],
      ),
    );
  }

  Widget _buildQuickReplyButton(String text) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        minimumSize: const Size(0, 28),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: Cyan30.withOpacity(0.12),
        foregroundColor: Cyan,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () => _sendMessage(quickReply: text),
      child: Text(text, style: const TextStyle(fontSize: 13)),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      color: Cyan50,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: White),
            onPressed: () {},
          ),
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
                        hintStyle: secondaryTextStyle.copyWith(fontSize: 15),
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
          GestureDetector(
            onTap: () => _sendMessage(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Cyan,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
