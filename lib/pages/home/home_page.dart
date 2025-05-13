import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/product_card.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _bannerData = [
    {
      'image': 'assets/image_banner.png',
      'title': 'Exclusive Sales',
      'subtitle': 'On Headphones',
      'discount': '30% OFF',
      'gradient': [Colors.blue.withOpacity(0.8), Colors.cyan.withOpacity(0.8)],
    },
    {
      'image': 'assets/image_shoes.png',
      'title': 'New Collections',
      'subtitle': 'Premium Shoes',
      'discount': '25% OFF',
      'gradient': [
        Colors.purple.withOpacity(0.8),
        Colors.pink.withOpacity(0.8),
      ],
    },
    {
      'image': 'assets/image_shoes.png',
      'title': 'Season Sale',
      'subtitle': 'Best Fashion',
      'discount': '40% OFF',
      'gradient': [
        Colors.orange.withOpacity(0.8),
        Colors.amber.withOpacity(0.8),
      ],
    },
    {
      'image': 'assets/image_shoes.png',
      'title': 'Flash Deals',
      'subtitle': 'Limited Offer',
      'discount': '20% OFF',
      'gradient': [Colors.green.withOpacity(0.8), Colors.teal.withOpacity(0.8)],
    },
    {
      'image': 'assets/image_shoes.png',
      'title': 'Special Discount',
      'subtitle': 'For Today',
      'discount': '35% OFF',
      'gradient': [
        Colors.red.withOpacity(0.8),
        Colors.redAccent.withOpacity(0.8),
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).getProducts();
    });
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _bannerData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildBanner(),
            _buildCategories(),
            _buildLatestProducts(),
          ],
        ),
      ),
    );
  }

  // HEADER SECTION
  Widget _buildHeader() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.user;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: defaultMargin,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/image_splash.png',
                  width: 154,
                  height: 52,
                  fit: BoxFit.contain,
                ),
              ),
              // Action Buttons
              Row(
                children: [
                  // Search Icon
                  Container(
                    width: 30,
                    height: 30,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/icon_search-normal.png',
                        width: 30,
                        height: 30,
                        color: White,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Profile Icon
                  GestureDetector(
                    onTap: () {
                      // TODO: Navigasi ke halaman profile atau login
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Grey50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            user != null && user.profilePhotoUrl.isNotEmpty
                                ? Image.network(
                                  user.profilePhotoUrl,
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                )
                                : Image.asset(
                                  'assets/icon_user.png',
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // BANNER SECTION
  Widget _buildBanner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 15),
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          // PageView Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: PageView.builder(
              controller: _pageController,
              itemCount: _bannerData.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return _buildBannerItem(index);
              },
            ),
          ),

          // Progress Indicators - tetap di posisi yang sama
          Positioned(
            bottom: 20,
            right: 20,
            child: Row(
              children: List.generate(
                _bannerData.length,
                (i) => _buildIndicator(i == _currentPage),
              ),
            ),
          ),

          // Gesture area
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                // Handle banner tap
              },
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  // Swipe right - previous page
                  if (_currentPage > 0) {
                    _pageController.animateToPage(
                      _currentPage - 1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                } else if (details.primaryVelocity! < 0) {
                  // Swipe left - next page
                  if (_currentPage < _bannerData.length - 1) {
                    _pageController.animateToPage(
                      _currentPage + 1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerItem(int index) {
    final item = _bannerData[index];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: item['gradient'],
        ),
        image: DecorationImage(
          image: AssetImage(item['image']),
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(Colors.black26, BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Discount badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: White.withOpacity(0.5), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: Cyan,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    item['discount'],
                    style: primaryTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: semibold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Title with animation
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.2),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                item['subtitle'],
                key: ValueKey<String>(item['subtitle']),
                style: primaryTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: regular,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.2),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                item['title'],
                key: ValueKey<String>(item['title']),
                style: primaryTextStyle.copyWith(
                  fontSize: 22,
                  fontWeight: extrabold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      width: isActive ? 16 : 4,
      height: 4,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: isActive ? Cyan : White.withOpacity(0.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  // CATEGORIES SECTION
  Widget _buildCategories() {
    final categories = [
      {'name': 'Electronics', 'icon': 'assets/icon_category_electronic.png'},
      {'name': 'Fashion', 'icon': 'assets/icon_category.png'},
      {'name': 'Furniture', 'icon': 'assets/icon_category.png'},
      {'name': 'Industrial', 'icon': 'assets/icon_category.png'},
    ];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semibold,
                ),
              ),
              Text(
                'SEE ALL',
                style: titleTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          height: 80,
          margin: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                categories.map((cat) {
                  return Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () {},
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              border: Border.all(color: Grey50, width: 1.2),
                            ),
                            child: Center(
                              child: Image.asset(
                                cat['icon']!,
                                width: 28,
                                height: 28,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cat['name']!,
                            style: primaryTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: medium,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  // LATEST PRODUCTS SECTION
  Widget _buildLatestProducts() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        final products = productProvider.products;
        return Column(
          children: [
            const SizedBox(height: 25),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Latest Products',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semibold,
                    ),
                  ),
                  Text(
                    'SEE ALL',
                    style: titleTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Products
            products.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final imageUrl =
                        (product.galleries.isNotEmpty &&
                                product.galleries[0].url != null &&
                                product.galleries[0].url.isNotEmpty)
                            ? product.galleries[0].url
                            : 'assets/image_not_available.png';
                    return ProductCard(
                      name: product.name,
                      price: product.price,
                      image: imageUrl,
                      colors: const [
                        'Blue',
                        'Green',
                        'Red',
                        'Yellow',
                        'Black',
                      ], // TODO: mapping warna dari backend jika ada
                      id: product.id.toString(),
                    );
                  },
                ),
            const SizedBox(height: 30),
          ],
        );
      },
    );
  }
}

class ProductColorPicker extends StatelessWidget {
  final List<Color> colors;
  final int selected;
  final ValueChanged<int> onChanged;
  const ProductColorPicker({
    super.key,
    required this.colors,
    required this.selected,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(colors.length, (i) {
        return GestureDetector(
          onTap: () => onChanged(i),
          child: Container(
            margin: EdgeInsets.only(right: 8),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: colors[i],
              shape: BoxShape.circle,
              border: Border.all(
                color: selected == i ? Cyan : Colors.transparent,
                width: 2,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class ProductQuantitySelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const ProductQuantitySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove, color: White),
          onPressed: value > 1 ? () => onChanged(value - 1) : null,
        ),
        Text('$value', style: primaryTextStyle.copyWith(fontSize: 16)),
        IconButton(
          icon: Icon(Icons.add, color: White),
          onPressed: () => onChanged(value + 1),
        ),
      ],
    );
  }
}

class ProductActionButtons extends StatelessWidget {
  final VoidCallback onBuyNow;
  final VoidCallback onAddToCart;
  const ProductActionButtons({
    super.key,
    required this.onBuyNow,
    required this.onAddToCart,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onBuyNow,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Cyan),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text("Buy Now", style: titleTextStyle.copyWith(color: Cyan)),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onAddToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Cyan,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Add To Cart",
              style: primaryTextStyle.copyWith(color: Black),
            ),
          ),
        ),
      ],
    );
  }
}
