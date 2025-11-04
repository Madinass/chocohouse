import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ____________________________________________________________________
// Розовый Палитра (Макеттегідей)
// ____________________________________________________________________
const Color _mainPink = Color.fromARGB(255, 255, 220, 220); // Ашық розовый фон
const Color _accentPink = Color.fromARGB(255, 236, 100, 130); // Акцент түсі (Батырмалар, тақырыптар)
const Color _darkPink = Color.fromARGB(255, 180, 50, 80);   // Қою розовый мәтін
const Color _whiteColor = Colors.white;                     // Ақ түс
const Color _greyText = Color.fromARGB(255, 100, 100, 100); // Сұр мәтін
const Color _lightGrey = Color.fromARGB(255, 240, 240, 240); // Секция фондары

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // BottomNavigationBar үшін, бірақ бұл дизайн жоқ
  List<dynamic> cakes = [];
  bool isLoading = true;

  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {};

  // Бұл категориялар енді BottomNavigationBar-да емес,
  // ескі дизайндағыдай тек ішкі скроллда қолданылуы мүмкін
  final List<String> _categories = [
    'Кусочки тортов',
    'ПП-моти',
    'Бенто-торты',
    'Акции',
    'Десерты',
  ];

  // Торт түрлері (макеттен алынған)
  final List<Map<String, String>> _cakeTypes = [
    {'title': 'БЕНТО', 'image': 'assets/cake_bento.png', 'description': 'Кусочные торты'},
    {'title': 'МУССОВЫЕ', 'image': 'assets/cake_muss.png', 'description': 'Муссовые торты'},
    {'title': 'ЗАКАЗНЫЕ', 'image': 'assets/cake_classic.png', 'description': 'Заказные торты'},
    {'title': 'ПОРЦИОННЫЕ', 'image': 'assets/cake_portion.png', 'description': 'Порционные торты'},
  ];

  // Начинка түрлері (макеттен алынған)
  final List<Map<String, String>> _fillings = [
    {'name': 'Вишня', 'image': 'assets/filling_cherry.png'},
    {'name': 'Ягоды', 'image': 'assets/filling_berry.png'},
    {'name': 'Шоколад', 'image': 'assets/filling_choco.png'},
    {'name': 'Орехи', 'image': 'assets/filling_nut.png'},
  ];

  // ____________________________________________________________________
  // API және Логика (Өзгеріссіз қалдырамыз)
  // ____________________________________________________________________

  Future<void> fetchCakes() async {
    const String url = 'http://172.20.10.2:5000/api/cakes'; 
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          cakes = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print('Қате статус: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Серверге қосылу қатесі: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteCake(String id) async {
    final url = Uri.parse('http://172.20.10.2:5000/api/cakes/$id');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Торт жойылды ❌')),
        );
        await fetchCakes(); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Жою қатесі 😢')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Қате: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCakes(); 
    for (var category in _categories) {
      _sectionKeys[category] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Макетте BottomNavigationBar жоқ болғандықтан, бұл функция қажет емес
  void _onItemTapped(int index) {
    // setState(() { _selectedIndex = index; });
    // if (index == 0) { _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeOut); }
  }

  // ____________________________________________________________________
  // BUILD МЕТОДЫ
  // ____________________________________________________________________

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _mainPink, 
      
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // АppBar биіктігі
        child: AppBar(
          backgroundColor: _mainPink,
          elevation: 0,
          automaticallyImplyLeading: false, // Артқа батырмасын өшіру
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                _buildTopHeader(), // Жоғарғы мәзір элементтері
                _buildTopNavigation(), // Навигациялық сілтемелер
              ],
            ),
          ),
        ),
      ),
      
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              // "ТОРТЫ РУЧНОЙ РАБОТЫ" секциясы
              _buildHeroSection(context), 
              const SizedBox(height: 20), // Суреттегідей аралық
              
              // "ВЫБЕРИ СВОЙ ВКУСНЫЙ ТОРТИК" секциясы
              _buildCakeSelectionSection(),
              const SizedBox(height: 20),

              // "НАЙДИ ЛЮБИМУЮ НАЧИНКУ" секциясы
              _buildFillingSection(),
              const SizedBox(height: 20),

              // "ПРЕДЛОЖЕНИЕ ЭТОГО МЕСЯЦА" секциясы
              _buildSpecialOfferBanner(context),
              const SizedBox(height: 20),

              // "ЗОНА НАШЕЙ ДОСТАВКИ"
              _buildDeliveryZone(),
              const SizedBox(height: 20),

              // "КОНТАКТЫ И СВЯЗЬ С НАМИ"
              _buildContactSection(),
              const SizedBox(height: 40), // Төменгі бос орын

              // Ең төменгі "ШАБЛОН САЙТА..." баннері
              _buildFooterBanner(),
            ]),
          ),
          // Төменгі бос орын
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
      
      // Макетте BottomNavigationBar жоқ
      // bottomNavigationBar: BottomNavigationBar(...)
    );
  }

  // ____________________________________________________________________
  // ЖАҢАДАН ЖАСАЛҒАН / ҚАЙТА ЖАСАЛҒАН ВИДЖЕТТЕР (МАКЕТКЕ САЙ)
  // ____________________________________________________________________

  // AppBar ішіндегі жоғарғы бөлік (Телефон, Іздеу)
  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.menu, color: _darkPink), // Гамбургер иконкасы
              SizedBox(width: 10),
              Text('Иваново', style: TextStyle(color: _darkPink, fontSize: 13)),
            ],
          ),
          Text('+7 920 340-60-67', style: TextStyle(color: _darkPink, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // AppBar ішіндегі навигациялық сілтемелер (ГЛАВНАЯ, О КОМПАНИИ...)
  Widget _buildTopNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: const [
            _NavLink('ГЛАВНАЯ'),
            _NavLink('О КОМПАНИИ'),
            _NavLink('УСЛОВИЯ'),
            _NavLink('ОПЛАТА'),
            _NavLink('КОНТАКТЫ'),
          ],
        ),
      ),
    );
  }

  // 1. "ТОРТЫ РУЧНОЙ РАБОТЫ" секциясы
  Widget _buildHeroSection(BuildContext context) {
    return Container(
      color: _mainPink, // Фонның түсі
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ТОРТЫ РУЧНОЙ РАБОТЫ',
                  style: TextStyle(
                    fontSize: 20, // Макеттегідей үлкенірек шрифт
                    fontWeight: FontWeight.bold,
                    color: _darkPink,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'С РАЗНООБРАЗНЫМИ НАЧИНКАМИ',
                  style: TextStyle(
                    fontSize: 14, // Кішірек шрифт
                    color: _greyText,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Создадим вкусное настроение по поводу и без повода',
                  style: TextStyle(
                    fontSize: 14,
                    color: _darkPink,
                  ),
                ),
                const SizedBox(height: 20),
                // "ХОЧУ ТОРТ" батырмасы
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentPink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('ХОЧУ ТОРТ', style: TextStyle(color: _whiteColor, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Оң жақтағы торт суреті (макеттегідей үлкенірек)
          Container(
            width: 120, // Кеңірек
            height: 120, // Биігірек
            decoration: BoxDecoration(
              color: _whiteColor, // Ақ фон
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage('assets/cake_hero.png'), 
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. "ВЫБЕРИ СВОЙ ВКУСНЫЙ ТОРТИК" секциясы
  Widget _buildCakeSelectionSection() {
    return Container(
      color: _whiteColor, // Ақ фон
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'ВЫБЕРИ СВОЙ\nВКУСНЫЙ ТОРТИК', // Екі жолға бөлеміз
              style: TextStyle(
                fontSize: 22, // Үлкенірек шрифт
                fontWeight: FontWeight.bold,
                color: _darkPink,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250, // Биіктікті реттеу
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: _cakeTypes.map((type) => _buildCakeTypeCard(type['title']!, type['image']!, type['description']!)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Торт түріне арналған карта (макеттегідей)
  Widget _buildCakeTypeCard(String title, String imagePath, String description) {
    return Container(
      width: 160, // Картаның енін реттеу
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            height: 180, // Картаның биіктігі
            decoration: BoxDecoration(
              color: _mainPink, // Розовый фон
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Image.asset(imagePath, height: 120, fit: BoxFit.cover), 
                ),
                Positioned( // Сол жақ жоғарғы бұрыштағы жеміс
                  top: 10,
                  left: 10,
                  child: Image.asset('assets/strawberry.png', height: 20, width: 20), // Суретті қосу
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _darkPink,
            ),
          ),
          Text(
            description, // Қосымша сипаттама
            style: const TextStyle(
              fontSize: 10,
              color: _greyText,
            ),
          ),
        ],
      ),
    );
  }

  // 3. "НАЙДИ ЛЮБИМУЮ НАЧИНКУ" секциясы
  Widget _buildFillingSection() {
    return Container(
      color: _lightGrey, // Ашық сұр фон
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'НАЙДИ ЛЮБИМУЮ НАЧИНКУ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _darkPink,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100, // Биіктікті реттеу
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: _fillings.map((filling) => _buildFillingItem(filling['image']!, filling['name']!)).toList(),
            ),
          ),
          const SizedBox(height: 10),
          // Оң жақтағы үлкен торт суреті (макеттегідей)
          Align(
            alignment: Alignment.centerRight,
            child: Image.asset('assets/cake_fillings_large.png', height: 150), 
          ),
        ],
      ),
    );
  }

  // Начинка элементі (макеттегідей)
  Widget _buildFillingItem(String imagePath, String name) {
    return Padding(
      padding: const EdgeInsets.only(right: 25.0),
      child: Column(
        children: [
          Container(
            width: 70, // Үлкенірек
            height: 70, // Үлкенірек
            decoration: BoxDecoration(
              color: _whiteColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(imagePath, height: 40, fit: BoxFit.contain), 
            ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(fontSize: 12, color: _darkPink),
          ),
        ],
      ),
    );
  }

  // 4. "ПРЕДЛОЖЕНИЕ ЭТОГО МЕСЯЦА" баннері
  Widget _buildSpecialOfferBanner(BuildContext context) {
    return Container(
      color: _whiteColor, // Ақ фон
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ПРЕДЛОЖЕНИЕ\nЭТОГО МЕСЯЦА', // Екі жолға бөлеміз
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _darkPink,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'При заказе торта украшение в подарок оформление.',
                      style: TextStyle(fontSize: 12, color: _greyText),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'СКИДКА 20%',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _accentPink),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Ассорти торт суреті (Дөңгелек)
              Container(
                width: 120, // Үлкенірек
                height: 120, // Үлкенірек
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage('assets/cake_assorti.png'), 
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // "ХОЧУ ТОРТ" батырмасы
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('ХОЧУ ТОРТ', style: TextStyle(color: _whiteColor, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'ЗАКАЗ ИНДИВИДУАЛЬНОЙ РАЗРАБОТКИ ДИЗАЙНА САЙТА - 89012807479',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: _darkPink, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // 5. "ЗОНА НАШЕЙ ДОСТАВКИ" секциясы
  Widget _buildDeliveryZone() {
    return Container(
      color: _mainPink,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ЗОНА НАШЕЙ ДОСТАВКИ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _darkPink,
            ),
          ),
          const SizedBox(height: 15),
          // Карта суреті
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: _whiteColor,
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage('assets/delivery_map.png'), // Карта суреті
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 6. "КОНТАКТЫ И СВЯЗЬ С НАМИ" секциясы
  Widget _buildContactSection() {
    return Container(
      color: _mainPink,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Сол жақтағы жемістер суреті
          Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/contact_berries.png'), // Жеміс суреті
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'КОНТАКТЫ И СВЯЗЬ С НАМИ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _darkPink,
                  ),
                ),
                const SizedBox(height: 10),
                Text('КОНДИТЕРСКАЯ', style: TextStyle(color: _greyText, fontSize: 12)),
                Text('+7(920)340-60-67', style: TextStyle(color: _darkPink, fontSize: 14)),
                const SizedBox(height: 5),
                Text('ГРАФИК РАБОТЫ:', style: TextStyle(color: _greyText, fontSize: 12)),
                Text('ПН-ВС: 8:00 - 20:00', style: TextStyle(color: _darkPink, fontSize: 14)),
                const SizedBox(height: 10),
                // Байланыс формасы
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Ваше имя',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: _whiteColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Ваш телефон',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: _whiteColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentPink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('ОТПРАВИТЬ', style: TextStyle(color: _whiteColor, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Ең төменгі баннер
  Widget _buildFooterBanner() {
    return Container(
      color: _darkPink, // Қою розовый фон
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: const Center(
        child: Text(
          'ШАБЛОН САЙТА ПО ВЫПЕЧКЕ КОНДИТЕРСКИХ ИЗДЕЛИЙ!!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _whiteColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ____________________________________________________________________
// КӨМЕКШІ ВИДЖЕТТЕР
// ____________________________________________________________________

// Жоғарғы навигациялық сілтемелер үшін
class _NavLink extends StatelessWidget {
  final String title;
  const _NavLink(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          color: _darkPink,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Product Card (Түстері макетке сай өзгертілді)
class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> cake;
  final VoidCallback onDelete;

  const _ProductCard({required this.cake, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: _whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: _mainPink, // Ашық розовый фон
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/cake1.png', // Әлі де осы жерде "торт суреті"
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cake['name'] ?? 'Атауы жоқ',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _darkPink)),
                const SizedBox(height: 4),
                Text(cake['description'] ?? '',
                    style: const TextStyle(fontSize: 10, color: _greyText)),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Text('${cake['price']} тг',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _accentPink)), 
          ),
        ],
      ),
    );
  }
}