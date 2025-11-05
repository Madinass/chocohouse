import 'package:flutter/material.dart';
import 'models.dart'; 
import 'product_detail_screen.dart'; 
import 'menu_screen.dart'; 
import 'profile_screen.dart'; 
import 'utils.dart'; 

class NotificationScreen extends StatelessWidget {

  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уведомления', style: TextStyle(color: kPrimaryColor)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: kPrimaryColor),
      ),
      body: const Center(child: Text('это страница уведомления.', style: TextStyle(fontSize: 18))),
    );
  }
}



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  String _searchQuery = '';
  List<String> _selectedCategories = [];
  final List<String> _allCategories = dummyProducts.map((p) => p.category).toSet().toList();
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchQueryChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchQueryChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchQueryChanged() {
    if (_searchQuery != _searchController.text) {
      setState(() {
        _searchQuery = _searchController.text;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationScreen()),
    );
  }

  List<Product> _getFilteredProducts() {
    return dummyProducts.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategories.isEmpty || _selectedCategories.contains(product.category);
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _showFilterDialog(BuildContext context) { 
    List<String> tempSelectedCategories = List.from(_selectedCategories);
    
    showDialog(context: context, builder: (BuildContext dialogContext) {
      return StatefulBuilder(builder: (context, setStateSB) {
        return AlertDialog(
          title: const Text('Фильтрация по категориям'), 
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: _allCategories.map((category) {
                final isChecked = tempSelectedCategories.contains(category);
                return CheckboxListTile(
                  title: Text(category), 
                  value: isChecked, 
                  activeColor: kPrimaryColor, 
                  onChanged: (bool? newValue) { 
                    setStateSB(() { 
                      if (newValue!) {
                        tempSelectedCategories.add(category);
                      } else {
                        tempSelectedCategories.remove(category);
                      }
                    }); 
                  },
                );
              }).toList(),
            )
          ), 
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(), 
              child: const Text('Отмена', style: TextStyle(color: Colors.grey))
            ),
            ElevatedButton(
              onPressed: () {
                setState(() { 
                  _selectedCategories = tempSelectedCategories; 
                });
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Фильтр использован: ${_selectedCategories.isEmpty ? 'Все категории' : _selectedCategories.join(', ')}')),
                );
              }, 
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor), 
              child: const Text('Применить', style: TextStyle(color: Colors.white))
            ),
          ],
        );
      },);
    },);
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();
    
    final List<Widget> _widgetOptions = <Widget>[
      HomeContent(
        products: filteredProducts,
        showFilterDialog: _showFilterDialog,
        searchController: _searchController,
      ),
      MenuScreen(
        products: filteredProducts,
        showFilterDialog: _showFilterDialog,
        searchController: _searchController,
      ),
      const ProfileScreen(),
    ];
    
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _buildAppBar(context),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
  
  AppBar _buildAppBar(BuildContext context) { 
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.cake, color: kPrimaryColor, size: 24),
          SizedBox(width: 8),
          Text('Choco House', style: TextStyle(color: kPrimaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: () => _navigateToNotifications(context)),
      ],
    );
  }
  
  Widget _buildBottomNavigationBar() { 
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Меню'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      onTap: _onItemTapped,
    );
  }
}



class HomeContent extends StatelessWidget {
  final Function(BuildContext) showFilterDialog;
  final List<Product> products; 
  final TextEditingController searchController; 

  const HomeContent({
    super.key,
    required this.showFilterDialog,
    required this.products,
    required this.searchController,
  });

  Widget _imageErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(color: Colors.grey[200], alignment: Alignment.center, child: const Text('Image Error', style: TextStyle(color: Colors.grey)));
  }

  List<Product> _getPopularProducts(List<Product> allProducts) {
    final Map<String, Product> popularMap = {};
    for (var product in allProducts) {
      if (!popularMap.containsKey(product.category)) {
        popularMap[product.category] = product;
      }
    }
    return popularMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildSearchBarAndFilter(context), 
            const SizedBox(height: 20),
            _buildSpecialOfferWidget(context),
            const SizedBox(height: 30),
            _buildPopularProductsHeader(),
            _buildPopularProductsList(context), 
            const SizedBox(height: 30),
            _buildAdvertisementWidget(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  Widget _buildSearchBarAndFilter(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Поиск', 
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => showFilterDialog(context),
          ),
        ),
      ],
    );
  }
  
  
  Widget _buildSpecialOfferWidget(BuildContext context) { 
    return Container(
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
      height: 180,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 193, 135, 203), 
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Positioned(left: 0, top: 5, bottom: 5, child: Image.asset('assets/special_offer_image_1.png', width: 100, fit: BoxFit.contain, errorBuilder: _imageErrorBuilder)),
          Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('Подари торт своему близкому уже сейчас', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 35, 
              child: ElevatedButton(
                
                onPressed: () {
                  launchTelegramChat(context); 
                }, 
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: kPrimaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 20)), 
                child: const Text('Заказать', style: TextStyle(fontWeight: FontWeight.bold))
              )
            ),
          ],)),
          Positioned(right: 0, bottom: 5, child: Image.asset('assets/special_offer_image_2.png', width: 90, height: 90, fit: BoxFit.contain, errorBuilder: _imageErrorBuilder)),
        ],
      ),
    );
  }

  
  Widget _buildPopularProductsHeader() { 
    return const Padding(
      padding: EdgeInsets.only(bottom: 15.0),
      child: Text('Наши популярные продукты', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPopularProductsList(BuildContext context) {
    final List<Product> productsToShow;
    
    if (searchController.text.isNotEmpty || products.length != dummyProducts.length) {
      productsToShow = products;
    } else {
      productsToShow = _getPopularProducts(dummyProducts);
    }

    return SizedBox(
      height: 280, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: productsToShow.length,
        itemBuilder: (context, index) {
          final product = productsToShow[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
              );
            },
            child: _buildProductCard(product),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(product.imagePath, height: 130, width: double.infinity, fit: BoxFit.cover, errorBuilder: _imageErrorBuilder), 
          ),
          Padding(
            padding: const EdgeInsets.all(10), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis), 
                const SizedBox(height: 6),
                Text('${product.weight} | ${product.calories.toStringAsFixed(0)} ккал', style: const TextStyle(fontSize: 12, color: Colors.grey)), 
                const SizedBox(height: 10), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16)), 
                    SizedBox(
                      height: 35, 
                      child: ElevatedButton(
                        onPressed: () {
                           
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Заказать', style: TextStyle(fontSize: 13, color: Colors.white)), 
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvertisementWidget() { 
    return Container(height: 200, width: double.infinity, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey[200]),
      child: ClipRRect(borderRadius: BorderRadius.circular(15),
        child: Image.asset('assets/advertisement_banner.png', fit: BoxFit.cover, errorBuilder: _imageErrorBuilder),
      ),
    );
  }
}

// // lib/home_screen.dart (ЖАҢАРТЫЛҒАН ТОЛЫҚ КОД)

// import 'package:flutter/material.dart';
// import 'models.dart'; 
// import 'product_detail_screen.dart'; 
// import 'menu_screen.dart'; 
// import 'profile_screen.dart'; // 🟢 ProfileScreen импорты

// // --- Stub беттер (өзгеріссіз) ---
// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Уведомления', style: TextStyle(color: kPrimaryColor)),
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: kPrimaryColor),
//       ),
//       body: const Center(child: Text('это страница уведомления.', style: TextStyle(fontSize: 18))),
//     );
//   }
// }

// // -------------------------------------------------------------------
// // HomeScreen (StatefulWidget) - Басты экран
// // -------------------------------------------------------------------

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
  
//   // 🟢 Іздеу және фильтр стейттері (Екі экранға ортақ)
//   String _searchQuery = '';
//   List<String> _selectedCategories = [];
//   final List<String> _allCategories = dummyProducts.map((p) => p.category).toSet().toList();
  
//   int _selectedIndex = 0;
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // 🟢 Іздеу мәселесін шешу үшін контроллерді тыңдаймыз
//     _searchController.addListener(_onSearchQueryChanged);
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchQueryChanged);
//     _searchController.dispose();
//     super.dispose();
//   }

//   // Іздеу стейтін жаңарту функциясы
//   void _onSearchQueryChanged() {
//     // Тек мәтін өзгерсе ғана setState шақырамыз
//     if (_searchQuery != _searchController.text) {
//       setState(() {
//         _searchQuery = _searchController.text;
//       });
//     }
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   void _navigateToNotifications(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const NotificationScreen()),
//     );
//   }

//   // 🟢 Өнімдерді сүзу логикасы (Екі экранға да қажет)
//   List<Product> _getFilteredProducts() {
//     return dummyProducts.where((product) {
//       final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
//       final matchesCategory = _selectedCategories.isEmpty || _selectedCategories.contains(product.category);
//       return matchesSearch && matchesCategory;
//     }).toList();
//   }

//   // 🟢 Фильтр диалогын көрсету (Өзгеріссіз)
//   void _showFilterDialog(BuildContext context) { 
//     List<String> tempSelectedCategories = List.from(_selectedCategories);
    
//     showDialog(context: context, builder: (BuildContext dialogContext) {
//       return StatefulBuilder(builder: (context, setStateSB) {
//         // ... (Фильтр диалог коды өзгеріссіз) ...
//         return AlertDialog(
//           title: const Text('Фильтрация по категориям'), 
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min, 
//               children: _allCategories.map((category) {
//                 final isChecked = tempSelectedCategories.contains(category);
//                 return CheckboxListTile(
//                   title: Text(category), 
//                   value: isChecked, 
//                   activeColor: kPrimaryColor, 
//                   onChanged: (bool? newValue) { 
//                     setStateSB(() { 
//                       if (newValue!) {
//                         tempSelectedCategories.add(category);
//                       } else {
//                         tempSelectedCategories.remove(category);
//                       }
//                     }); 
//                   },
//                 );
//               }).toList(),
//             )
//           ), 
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(dialogContext).pop(), 
//               child: const Text('Отмена', style: TextStyle(color: Colors.grey))
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() { 
//                   _selectedCategories = tempSelectedCategories; 
//                 });
//                 Navigator.of(dialogContext).pop();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Фильтр использован: ${_selectedCategories.isEmpty ? 'Все категории' : _selectedCategories.join(', ')}')),
//                 );
//               }, 
//               style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor), 
//               child: const Text('Применить', style: TextStyle(color: Colors.white))
//             ),
//           ],
//         );
//       },);
//     },);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filteredProducts = _getFilteredProducts();
    
//     // 🟢 _widgetOptions ТІЗІМІН ЖАҢАРТУ
//     final List<Widget> _widgetOptions = <Widget>[
//       HomeContent(
//         products: filteredProducts,
//         showFilterDialog: _showFilterDialog,
//         searchController: _searchController,
//       ),
//       MenuScreen(
//         products: filteredProducts,
//         showFilterDialog: _showFilterDialog,
//         searchController: _searchController,
//       ),
//       // 🟢 Профиль бетін қостық
//       const ProfileScreen(),
//     ];
    
//     return Scaffold(
//       backgroundColor: kBackgroundColor,
//       appBar: _buildAppBar(context),
//       body: _widgetOptions.elementAt(_selectedIndex),
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }
  
//   // AppBar (Өзгеріссіз)
//   AppBar _buildAppBar(BuildContext context) { 
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       title: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: const [
//           Icon(Icons.cake, color: kPrimaryColor, size: 24),
//           SizedBox(width: 8),
//           Text('Choco House', style: TextStyle(color: kPrimaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
//         ],
//       ),
//       actions: [
//         IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: () => _navigateToNotifications(context)),
//       ],
//     );
//   }
  
//   // BottomNavigationBar (Өзгеріссіз)
//   Widget _buildBottomNavigationBar() { 
//     return BottomNavigationBar(
//       items: const <BottomNavigationBarItem>[
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
//         BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Меню'),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
//       ],
//       currentIndex: _selectedIndex,
//       selectedItemColor: kPrimaryColor,
//       unselectedItemColor: Colors.grey,
//       backgroundColor: Colors.white,
//       onTap: _onItemTapped,
//     );
//   }
// }

// // -------------------------------------------------------------------
// // HomeContent (StatelessWidget) - Бас экранның мазмұны
// // -------------------------------------------------------------------

// class HomeContent extends StatelessWidget {
//   final Function(BuildContext) showFilterDialog;
//   final List<Product> products; 
//   final TextEditingController searchController; 

//   const HomeContent({
//     super.key,
//     required this.showFilterDialog,
//     required this.products,
//     required this.searchController,
//   });

//   // Сурет қатесін өңдеуші (Өзгеріссіз)
//   Widget _imageErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
//     return Container(color: Colors.grey[200], alignment: Alignment.center, child: const Text('Image Error', style: TextStyle(color: Colors.grey)));
//   }

//   // 🟢 Барлық категориялардан 1 өнімді таңдап алу логикасы
//   List<Product> _getPopularProducts(List<Product> allProducts) {
//     final Map<String, Product> popularMap = {};
//     for (var product in allProducts) {
//       // Әр категориядан тек бірінші кездескен өнімді аламыз
//       if (!popularMap.containsKey(product.category)) {
//         popularMap[product.category] = product;
//       }
//     }
//     return popularMap.values.toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//             _buildSearchBarAndFilter(context), 
//             const SizedBox(height: 20),
//             _buildSpecialOfferWidget(context),
//             const SizedBox(height: 30),
//             _buildPopularProductsHeader(),
//             _buildPopularProductsList(context), // 🟢 Жаңа логиканы қолданамыз
//             const SizedBox(height: 30),
//             _buildAdvertisementWidget(),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   // Іздеу жолағы және Фильтрация (Өзгеріссіз)
//   Widget _buildSearchBarAndFilter(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: Colors.grey.shade200),
//             ),
//             child: TextField(
//               controller: searchController,
//               decoration: const InputDecoration(
//                 hintText: 'Поиск', 
//                 border: InputBorder.none,
//                 prefixIcon: Icon(Icons.search, color: Colors.grey),
//                 contentPadding: EdgeInsets.symmetric(vertical: 14),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: kPrimaryColor,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: IconButton(
//             icon: const Icon(Icons.filter_list, color: Colors.white),
//             onPressed: () => showFilterDialog(context),
//           ),
//         ),
//       ],
//     );
//   }
  
//   // Арнайы ұсыныс (Өзгеріссіз)
//   Widget _buildSpecialOfferWidget(BuildContext context) { 
//     return Container(
//       padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
//       height: 180,
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 193, 135, 203), 
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Stack(
//         children: [
//           Positioned(left: 0, top: 5, bottom: 5, child: Image.asset('assets/special_offer_image_1.png', width: 100, fit: BoxFit.contain, errorBuilder: _imageErrorBuilder)),
//           Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             const Text('Подари торт своему близкому уже сейчас', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             SizedBox(height: 35, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: kPrimaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 20)), child: const Text('Заказать', style: TextStyle(fontWeight: FontWeight.bold)))),
//           ],)),
//           Positioned(right: 0, bottom: 5, child: Image.asset('assets/special_offer_image_2.png', width: 90, height: 90, fit: BoxFit.contain, errorBuilder: _imageErrorBuilder)),
//         ],
//       ),
//     );
//   }

//   Widget _buildPopularProductsHeader() { 
//     return const Padding(
//       padding: EdgeInsets.only(bottom: 15.0),
//       child: Text('Наши популярные продукты', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//     );
//   }

//   Widget _buildPopularProductsList(BuildContext context) {
//     final List<Product> productsToShow;
    
//     // 🟢 Логика: Егер іздеу немесе фильтр қолданылса, сүзілген тізімді көрсетеміз.
//     if (searchController.text.isNotEmpty || products.length != dummyProducts.length) {
//       productsToShow = products;
//     } else {
//       // Әйтпесе, әр категориядан бір өнімді көрсетеміз.
//       productsToShow = _getPopularProducts(dummyProducts);
//     }

//     return SizedBox(
//       height: 280, 
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: productsToShow.length,
//         itemBuilder: (context, index) {
//           final product = productsToShow[index];
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
//               );
//             },
//             child: _buildProductCard(product),
//           );
//         },
//       ),
//     );
//   }

//   // Өнім картасы (Өлшемі үлкейтілген, өзгеріссіз)
//   Widget _buildProductCard(Product product) {
//     return Container(
//       width: 180,
//       margin: const EdgeInsets.only(right: 15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
//             child: Image.asset(product.imagePath, height: 130, width: double.infinity, fit: BoxFit.cover, errorBuilder: _imageErrorBuilder), 
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10), 
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis), 
//                 const SizedBox(height: 6),
//                 Text('${product.weight} | ${product.calories.toStringAsFixed(0)} ккал', style: const TextStyle(fontSize: 12, color: Colors.grey)), 
//                 const SizedBox(height: 10), 
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16)), 
//                     SizedBox(
//                       height: 35, 
//                       child: ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: kPrimaryColor,
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                         ),
//                         child: const Text('Заказать', style: TextStyle(fontSize: 13, color: Colors.white)), 
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAdvertisementWidget() { 
//     return Container(height: 200, width: double.infinity, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey[200]),
//       child: ClipRRect(borderRadius: BorderRadius.circular(15),
//         child: Image.asset('assets/advertisement_banner.png', fit: BoxFit.cover, errorBuilder: _imageErrorBuilder),
//       ),
//     );
//   }
// }