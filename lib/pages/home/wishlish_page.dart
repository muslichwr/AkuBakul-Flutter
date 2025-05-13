import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/wishlist_product_card.dart';
import '../../widgets/wishlist_delete_dialog.dart';
import '../../providers/wishlist_provider.dart';
import '../../models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    print('WishlistPage: Halaman wishlist diinisialisasi');
  }

  void showDeleteDialog(ProductModel product) {
    print(
      'WishlistPage: Menampilkan dialog hapus untuk produk: ${product.name}',
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: Cyan50,
      builder:
          (_) => WishlistDeleteDialog(
            onDelete: () {
              print(
                'WishlistPage: Menghapus produk dari wishlist: ${product.name}',
              );
              Provider.of<WishlistProvider>(
                context,
                listen: false,
              ).setProduct(product);
              Navigator.pop(context);
            },
            onCancel: () {
              print(
                'WishlistPage: Membatalkan penghapusan produk: ${product.name}',
              );
              Navigator.pop(context);
            },
            productName: product.name,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WishlistProvider wishlistProvider = Provider.of<WishlistProvider>(context);
    List<ProductModel> wishlistItems = wishlistProvider.wishlist;

    print(
      'WishlistPage: Membangun halaman wishlist dengan ${wishlistItems.length} produk',
    );

    return Scaffold(
      backgroundColor: Black,
      appBar: AppBar(
        backgroundColor: Cyan50,
        elevation: 0,
        leading:
            Navigator.canPop(context)
                ? IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: White),
                  onPressed: () => Navigator.pop(context),
                )
                : null,
        title: Text(
          'Wishlist',
          style: primaryTextStyle.copyWith(fontWeight: bold, fontSize: 18),
        ),
        centerTitle: false,
      ),
      body:
          wishlistItems.isEmpty
              ? _EmptyWishlist()
              : _WishlistList(
                wishlistItems: wishlistItems,
                onDelete: showDeleteDialog,
              ),
    );
  }
}

// Widget untuk tampilan kosong
class _EmptyWishlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('WishlistPage: Menampilkan tampilan wishlist kosong');
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/image_wishlist_empty.png', width: 180),
            const SizedBox(height: 32),
            Text(
              'Wishlist Anda kosong',
              style: primaryTextStyle.copyWith(fontWeight: bold, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'Ketuk tombol hati untuk menyimpan produk favorit Anda.',
              style: secondaryTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Jelajahi Kategori',
              onPressed: () {
                print('WishlistPage: Navigasi ke halaman kategori');
                // Navigasi ke kategori
                Navigator.pushNamed(context, '/categories');
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget untuk list produk wishlist
class _WishlistList extends StatelessWidget {
  final List<ProductModel> wishlistItems;
  final Function(ProductModel) onDelete;

  const _WishlistList({required this.wishlistItems, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    print(
      'WishlistPage: Membangun list produk wishlist dengan ${wishlistItems.length} item',
    );
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: wishlistItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 0),
      itemBuilder: (context, index) {
        final product = wishlistItems[index];
        String imageUrl = 'assets/image_placeholder.png';
        bool isNetworkImage = false;

        if (product.galleries.isNotEmpty) {
          imageUrl = product.galleries[0].url;
          isNetworkImage = true;
          print(
            'WishlistPage: Memuat gambar network untuk ${product.name}: $imageUrl',
          );
        } else {
          print(
            'WishlistPage: Produk ${product.name} tidak memiliki gambar, menggunakan placeholder',
          );
        }

        return WishlistProductCard(
          image: imageUrl,
          isNetworkImage: isNetworkImage,
          name: product.name,
          price: product.price,
          // Untuk oldPrice, kita bisa menggunakan price karena tidak ada field oldPrice di model
          oldPrice: product.price,
          qty: 1, // Default quantity
          onDelete: () => onDelete(product),
          onQtyChanged: (qty) {
            print(
              'WishlistPage: Mengubah kuantitas produk ${product.name} menjadi $qty',
            );
            // Karena tidak ada fitur untuk mengubah kuantitas di provider, kita hanya log
          },
          isLast: index == wishlistItems.length - 1,
        );
      },
    );
  }
}
