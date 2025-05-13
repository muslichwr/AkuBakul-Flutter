import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import 'dart:async';
import 'package:akubakul/providers/product_provider.dart';
import 'package:akubakul/providers/wishlist_provider.dart';
import 'package:akubakul/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/cart_provider.dart';
import 'dart:developer' as developer;
import 'package:akubakul/pages/detail_chat_page.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  const ProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  bool isFavorite = false;
  int selectedColor = 0;
  int quantity = 1;
  int currentImageIndex = 0;
  bool isReadMore = false;
  bool showCartNotif = false;
  bool showWishlistNotif = false;
  final PageController _imageController = PageController();
  late AnimationController _favAnimController;
  Timer? _notifTimer;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Mengatur status bar dan navigation bar agar sesuai dengan desain
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    _favAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      lowerBound: 0.8,
      upperBound: 1.2,
      value: 1.0,
    );

    getInit();
  }

  getInit() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      print('ProductPage: Memuat produk dengan ID: ${widget.productId}');
      int productId = int.parse(widget.productId);

      final success = await Provider.of<ProductProvider>(
        context,
        listen: false,
      ).getProductById(productId);

      print('ProductPage: Hasil memuat produk - success: $success');

      if (!success) {
        setState(() {
          errorMessage = 'Produk tidak ditemukan';
        });
      } else {
        // Cek status wishlist saat produk berhasil dimuat
        checkWishlistStatus();
      }
    } catch (e) {
      print('ProductPage: Error parsing product ID: ${widget.productId} - $e');
      setState(() {
        errorMessage = 'ID produk tidak valid';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void checkWishlistStatus() {
    ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    WishlistProvider wishlistProvider = Provider.of<WishlistProvider>(
      context,
      listen: false,
    );
    ProductModel? product = productProvider.selectedProduct;

    if (product != null) {
      bool isWishlisted = wishlistProvider.isWishList(product);
      print(
        'ProductPage: Cek status wishlist untuk ${product.name}: ${isWishlisted ? 'Sudah di wishlist' : 'Belum di wishlist'}',
      );
      setState(() {
        isFavorite = isWishlisted;
      });
    }
  }

  void toggleWishlist() async {
    ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    WishlistProvider wishlistProvider = Provider.of<WishlistProvider>(
      context,
      listen: false,
    );
    ProductModel? product = productProvider.selectedProduct;

    if (product != null) {
      // Karena perilaku setProduct di WishlistProvider berlawanan dengan isFavorite,
      // perlu kita ubah implementasinya sedikit
      print(
        'ProductPage: ${isFavorite ? 'Menghapus dari' : 'Menambahkan ke'} wishlist: ${product.name}',
      );
      wishlistProvider.setProduct(product);
      setState(() {
        isFavorite = !isFavorite;
        showWishlistNotif = true;
      });

      await _favAnimController.forward(from: 0.8);
      await _favAnimController.reverse();

      _notifTimer?.cancel();
      _notifTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            showWishlistNotif = false;
          });
        }
      });
    }
  }

  // Fungsi untuk mencoba memuat ulang produk
  void _retryLoading() {
    getInit();
  }

  @override
  void dispose() {
    _imageController.dispose();
    _favAnimController.dispose();
    _notifTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    ProductModel? product = productProvider.selectedProduct;

    return Scaffold(
      backgroundColor: Black,
      body: SafeArea(
        child:
            isLoading
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Cyan),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Memuat produk...',
                        style: primaryTextStyle.copyWith(
                          color: White,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
                : errorMessage != null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage!,
                        style: primaryTextStyle.copyWith(
                          color: White,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _retryLoading,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Cyan,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Coba Lagi',
                              style: primaryTextStyle.copyWith(color: Black),
                            ),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Grey50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Kembali',
                              style: primaryTextStyle.copyWith(color: White),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                : product == null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Produk tidak ditemukan',
                        style: primaryTextStyle.copyWith(
                          color: White,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _retryLoading,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Cyan,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Coba Lagi',
                              style: primaryTextStyle.copyWith(color: Black),
                            ),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Grey50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Kembali',
                              style: primaryTextStyle.copyWith(color: White),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                : Stack(
                  children: [
                    // Background
                    Container(color: Black),
                    // Content
                    Column(
                      children: [
                        _buildHeader(),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                _buildProductImageCarousel(product),
                                _buildProductDetailCard(product),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                        _buildBottomActions(),
                      ],
                    ),
                    _buildCartNotif(),
                    _buildWishlistNotif(),
                  ],
                ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
          ),
          Row(
            children: [
              _circleIcon('assets/icon_search-normal.png'),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _navigateToChat(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Grey50,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icon_chat.png',
                      width: 20,
                      height: 20,
                      color: White,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.chat_bubble_outline,
                          size: 20,
                          color: White,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/cart'),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Grey50,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icon_shoppingcart.png',
                      width: 20,
                      height: 20,
                      color: White,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(String asset) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: Grey50, shape: BoxShape.circle),
      child: Center(
        child: Image.asset(asset, width: 20, height: 20, color: White),
      ),
    );
  }

  Widget _buildProductImageCarousel(ProductModel product) {
    final images = product.galleries;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: AspectRatio(
            aspectRatio: 1.0, // 1:1, full-width square
            child: PageView.builder(
              controller: _imageController,
              onPageChanged: (index) {
                setState(() {
                  currentImageIndex = index;
                });
              },
              itemCount: images.length,
              itemBuilder: (context, index) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: Image.network(
                    images[index].url,
                    key: ValueKey(images[index].url),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                          valueColor: AlwaysStoppedAnimation(Cyan),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 64,
                          color: White.withOpacity(0.5),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        // Carousel Indicator
        Positioned(
          bottom: 18,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: currentImageIndex == index ? 18 : 7,
                height: 7,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color:
                      currentImageIndex == index
                          ? White
                          : White.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        // Favorite Button
        Positioned(
          top: 18,
          right: 18,
          child: GestureDetector(
            onTap: toggleWishlist,
            child: AnimatedBuilder(
              animation: _favAnimController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _favAnimController.value,
                  child: child,
                );
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: White,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Black.withOpacity(0.10),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 22,
                  color: isFavorite ? Red : Black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetailCard(ProductModel product) {
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    List<String> tagsList = product.tags.split(',');

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        padding: const EdgeInsets.only(top: 0),
        decoration: BoxDecoration(
          color: Grey50,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Black.withOpacity(0.10),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _badge(
                    '${product.category.name}',
                    Cyan,
                    White,
                    fontWeight: semibold,
                  ),
                  const SizedBox(width: 8),
                  if (tagsList.isNotEmpty && tagsList[0].isNotEmpty)
                    _badge(
                      tagsList[0],
                      White,
                      Cyan,
                      fontWeight: semibold,
                      bgOpacity: 0.13,
                    ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatter.format(product.price),
                        style: primaryTextStyle.copyWith(
                          fontSize: 22,
                          fontWeight: bold,
                          color: White,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                product.name,
                style: primaryTextStyle.copyWith(
                  fontSize: 19,
                  fontWeight: bold,
                  color: White,
                ),
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 14),
              AnimatedCrossFade(
                firstChild: Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: primaryTextStyle.copyWith(
                    fontSize: 14,
                    color: Grey100,
                    height: 1.5,
                  ),
                ),
                secondChild: Text(
                  product.description,
                  style: primaryTextStyle.copyWith(
                    fontSize: 14,
                    color: Grey100,
                    height: 1.5,
                  ),
                ),
                crossFadeState:
                    isReadMore
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 350),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isReadMore = !isReadMore;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    isReadMore ? 'Tutup' : 'Baca selengkapnya',
                    style: titleTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semibold,
                      color: Cyan,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Jumlah',
                style: primaryTextStyle.copyWith(
                  fontSize: 15,
                  fontWeight: semibold,
                  color: White,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _qtyButton(Icons.remove, () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      }),
                      Container(
                        width: 38,
                        alignment: Alignment.center,
                        child: Text(
                          quantity.toString(),
                          style: primaryTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: bold,
                            color: White,
                          ),
                        ),
                      ),
                      _qtyButton(Icons.add, () {
                        setState(() {
                          quantity++;
                        });
                      }),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(
    String text,
    Color bg,
    Color fg, {
    FontWeight fontWeight = FontWeight.w500,
    double bgOpacity = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg.withOpacity(bgOpacity),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: primaryTextStyle.copyWith(
          fontSize: 12,
          fontWeight: fontWeight,
          color: fg,
        ),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Grey100.withOpacity(0.10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: White, size: 18),
      ),
    );
  }

  Widget _buildCartNotif() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      top: showCartNotif ? 24 : -80,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: Grey50,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Black.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Cyan, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Produk berhasil ditambahkan ke cart',
                  style: primaryTextStyle.copyWith(fontSize: 14, color: White),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/cart');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Lihat Cart',
                    style: titleTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: bold,
                      color: Cyan,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistNotif() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      top: showWishlistNotif ? 24 : -80,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: Grey50,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Black.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Red : Cyan,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isFavorite
                      ? 'Produk ditambahkan ke wishlist'
                      : 'Produk dihapus dari wishlist',
                  style: primaryTextStyle.copyWith(fontSize: 14, color: White),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  print('ProductPage: Navigasi ke halaman wishlist');
                  Navigator.pushNamed(context, '/wishlist');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Lihat Wishlist',
                    style: titleTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: bold,
                      color: Cyan,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Black.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Tombol chat
          Container(
            width: 54,
            height: 54,
            margin: const EdgeInsets.only(right: 14),
            child: TextButton(
              onPressed: _navigateToChat,
              style: TextButton.styleFrom(
                backgroundColor: Grey50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icon_chat.png',
                  width: 24,
                  height: 24,
                  color: Cyan,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.chat_bubble_outline,
                      size: 24,
                      color: Cyan,
                    );
                  },
                ),
              ),
            ),
          ),
          // Tombol beli & tambah cart
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Cyan, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.transparent,
              ),
              onPressed: () {},
              child: Text(
                'Beli Sekarang',
                style: titleTextStyle.copyWith(
                  color: White,
                  fontWeight: bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Cyan,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final product =
                        Provider.of<ProductProvider>(
                          context,
                          listen: false,
                        ).selectedProduct;

                    if (product != null) {
                      developer.log(
                        'ProductPage - addToCart: menambahkan ${product.name} ke keranjang',
                      );

                      // Menambahkan produk ke keranjang
                      cartProvider.addCart(product);

                      // Cek jumlah item di keranjang setelah menambahkan
                      developer.log(
                        'ProductPage - addToCart: jumlah keranjang sekarang: ${cartProvider.carts.length}',
                      );

                      setState(() {
                        showCartNotif = true;
                      });

                      _notifTimer?.cancel();
                      _notifTimer = Timer(const Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() {
                            showCartNotif = false;
                          });
                        }
                      });
                    } else {
                      developer.log(
                        'ProductPage - addToCart: ERROR - product is null',
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart, color: Black, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Tambah ke Cart',
                        style: primaryTextStyle.copyWith(
                          color: Black,
                          fontWeight: bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk navigasi ke halaman detail chat
  void _navigateToChat() {
    ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    ProductModel? product = productProvider.selectedProduct;

    if (product != null) {
      developer.log(
        'ProductPage - navigateToChat: Membuka chat untuk produk ${product.name}',
      );

      // Navigasi ke halaman chat dengan parameter produk
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => DetailChatPage(
                productData: {
                  'productId': product.id,
                  'productName': product.name,
                  'productImage':
                      product.galleries.isNotEmpty
                          ? product.galleries[0].url
                          : '',
                  'productPrice': product.price,
                },
              ),
        ),
      );
    } else {
      developer.log('ProductPage - navigateToChat: ERROR - product is null');

      // Fallback jika produk tidak tersedia
      Navigator.pushNamed(context, '/detail-chat');
    }
  }
}
