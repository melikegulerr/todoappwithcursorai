import 'package:flutter/material.dart';
import 'dart:math';
import 'package:lottie/lottie.dart';

class ThemeProvider extends ChangeNotifier {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[200],
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.grey,
      primary: Colors.grey[800]!,
      secondary: Colors.grey[600]!,
      background: Colors.grey[200]!,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black),
    ),
    useMaterial3: true,
  );
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SNAP ORDER',
      theme: ThemeProvider.lightTheme,
      home: const IntroPage(),
    );
  }
}

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[200]!,
              Colors.grey[100]!,
            ],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                height: 300,
                child: Lottie.asset(
                  'assets/animations/truck_animation.json',
          controller: _controller,
                  fit: BoxFit.contain,
                  onLoaded: (composition) {
                    _controller.duration = composition.duration;
                    _controller.repeat();
                  },
                  options: LottieOptions(
                    enableMergePaths: true,
                  ),
                  filterQuality: FilterQuality.high,
                  delegates: LottieDelegates(
                    values: [
                      ValueDelegate.color(
                        ['**'],
                        value: Colors.grey[900]!,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SNAP ORDER',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Life is fast, your order should be too!',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MenuPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 20,
                    ),
                    backgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<MenuItem> get filteredItems {
    return menuItems.where((item) {
      final matchesCategory =
          selectedCategory == 'All' || item.kategori == selectedCategory;
      final matchesSearch =
          item.isim.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.aciklama.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black87),
            onPressed: () {
              final ornekUrun = MenuItem(
                isim: 'Sepetinizdeki Ürünler',
                aciklama: 'Sepet özeti',
                resimUrl: 'assets/images/burger-500054_1280 (1).jpg',
                fiyat: 24.99,
                kategori: 'Cart',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(yemek: ornekUrun),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'SNAP ORDER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[200],
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                'All',
                'Main Course',
                'Breakfast',
                'Dessert',
                'Salad',
              ]
                  .map((category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: selectedCategory == category,
                          label: Text(category),
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: Colors.grey[300],
                          checkmarkColor: Colors.grey[800],
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final yemek = filteredItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(yemek: yemek),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          yemek.resimUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      yemek.isim,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '\$${yemek.fiyat}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                yemek.aciklama,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final MenuItem yemek;

  const DetailPage({super.key, required this.yemek});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                yemek.isim,
                style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    yemek.resimUrl,
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      yemek.kategori,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    yemek.aciklama,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${yemek.fiyat}',
                        style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(yemek: yemek),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Order Now',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentPage extends StatelessWidget {
  final MenuItem yemek;

  const PaymentPage({super.key, required this.yemek});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(yemek.isim),
                        Text('\$${yemek.fiyat}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Service Fee'),
                        Text('\$2.00'),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${(yemek.fiyat + 2.00).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Credit/Debit Card'),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order received!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text(
                  'Complete Payment',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  final String isim;
  final String aciklama;
  final String resimUrl;
  final double fiyat;
  final String kategori;

  const MenuItem({
    required this.isim,
    required this.aciklama,
    required this.resimUrl,
    required this.fiyat,
    required this.kategori,
  });
}

final List<MenuItem> menuItems = [
  MenuItem(
    isim: 'Classic Hamburger',
    aciklama: 'Juicy beef patty with fresh vegetables and our signature sauce',
    resimUrl: 'assets/images/burger-500054_1280 (1).jpg',
    fiyat: 14.99,
    kategori: 'Main Course',
  ),
  MenuItem(
    isim: 'Pancakes',
    aciklama: 'Fluffy pancakes served with maple syrup and fresh berries',
    resimUrl: 'assets/images/pancake-3529653_1280.jpg',
    fiyat: 9.99,
    kategori: 'Breakfast',
  ),
  MenuItem(
    isim: 'Greek Salad',
    aciklama: 'Fresh Mediterranean salad with feta cheese and olives',
    resimUrl: 'assets/images/greek-salad.jpg',
    fiyat: 12.99,
    kategori: 'Salad',
  ),
  MenuItem(
    isim: 'Delicious Orange Mousse',
    aciklama: 'Light and airy orange mousse with fresh citrus zest',
    resimUrl: 'assets/images/pastry-2274750_1280.jpg',
    fiyat: 8.99,
    kategori: 'Dessert',
  ),
  MenuItem(
    isim: 'Creamy Indian Chicken Curry',
    aciklama: 'Tender chicken in a rich, aromatic curry sauce',
    resimUrl: 'assets/images/indian-food-3482749_1280 (3).jpg',
    fiyat: 16.99,
    kategori: 'Main Course',
  ),
  MenuItem(
    isim: 'Asparagus Salad',
    aciklama: 'Fresh asparagus with strawberries and special dressing',
    resimUrl: 'assets/images/asparagus-3304997_1280 (1).jpg',
    fiyat: 11.99,
    kategori: 'Salad',
  ),
  MenuItem(
    isim: 'Toast Hawaii',
    aciklama: 'Classic toast with ham, pineapple, and melted cheese',
    resimUrl: 'assets/images/toast-3532016_1280 (1).jpg',
    fiyat: 8.99,
    kategori: 'Breakfast',
  ),
  MenuItem(
    isim: 'Chocolate Souffle',
    aciklama: 'Warm chocolate souffle served with vanilla ice cream',
    resimUrl: 'assets/images/souffle-412785_1280.jpg',
    fiyat: 10.99,
    kategori: 'Dessert',
  ),
  MenuItem(
    isim: 'Wiener Schnitzel',
    aciklama: 'Crispy breaded chicken cutlet served with fresh lemon',
    resimUrl: 'assets/images/schnitzel-3279045_1280 (2).jpg',
    fiyat: 17.99,
    kategori: 'Main Course',
  ),
  MenuItem(
    isim: 'Spaghetti Bolognese',
    aciklama: 'Classic Italian pasta with rich meat sauce and parmesan cheese',
    resimUrl:
        'assets/images/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg',
    fiyat: 15.99,
    kategori: 'Main Course',
  ),
];
