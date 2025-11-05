import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'models.dart'; 
import 'utils.dart'; 

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  Widget _buildKbsuItem(String title, double value, String unit, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.5), width: 2),
          ),
          child: Center(
            child: Text(
              '${value.toStringAsFixed(1)} $unit',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
  
  Widget _imageErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Text('Image Error', style: TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Количество',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: kPrimaryColor),
                onPressed: _decrementQuantity,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '$_quantity',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryColor),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: kPrimaryColor),
                onPressed: _incrementQuantity,
              ),
            ],
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final double totalPrice = widget.product.price * _quantity;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset(
              widget.product.imagePath, 
              fit: BoxFit.cover,
              errorBuilder: _imageErrorBuilder,
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.35,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.product.weight,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    _buildQuantitySelector(),
                    const SizedBox(height: 20),

                    const Text('Описание', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(
                      widget.product.description,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 30),

                    const Text('Энергетическая ценность', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildKbsuItem('Каллории', widget.product.kbsu['Калории']!, 'ккал', Colors.orange.shade700),
                        _buildKbsuItem('Белки', widget.product.kbsu['Белки']!, 'г', Colors.green.shade700),
                        _buildKbsuItem('Жиры', widget.product.kbsu['Жиры']!, 'г', Colors.brown.shade700),
                        _buildKbsuItem('Углеводы', widget.product.kbsu['Углеводы']!, 'г', Colors.blue.shade700),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Общая Стоимость', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kPrimaryColor),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      launchTelegramChat(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor, 
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text('Заказать', style: TextStyle(fontSize: 18, color: Colors.white)),
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
// // lib/product_detail_screen.dart (ТЕК ТЕЛЕГРАМ ҚОСЫМШАСЫН АШАТЫН НҰСҚА)

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart'; 
// import 'models.dart'; 

// // -------------------------------------------------------------------
// // PRODUCT DETAIL SCREEN (StatefulWidget)
// // -------------------------------------------------------------------

// class ProductDetailScreen extends StatefulWidget {
//   final Product product;
//   const ProductDetailScreen({super.key, required this.product});

//   @override
//   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// }

// class _ProductDetailScreenState extends State<ProductDetailScreen> {
//   // ... (Өзгеріссіз қалдырылған _quantity, _incrementQuantity, _decrementQuantity)
//   int _quantity = 1;

//   void _incrementQuantity() {
//     setState(() {
//       _quantity++;
//     });
//   }

//   void _decrementQuantity() {
//     setState(() {
//       if (_quantity > 1) {
//         _quantity--;
//       }
//     });
//   }

//   // 🟢 ЖАҢАРТЫЛҒАН: Тек Telegram қосымшасын тікелей ашады. Сайтқа жібермейді.
//   Future<void> _launchTelegramChat() async {
    
//     // ⚠️ Бұл жерге өзіңіздің нақты Telegram username-іңізді жазыңыз!
//     const yourUsername = 'zhuka00z'; 
    
//     // Тікелей Telegram қосымшасын ашуға тырысатын tg:// схемасы
//     final tgUrl = 'tg://resolve?domain=$yourUsername'; 
//     final tgUri = Uri.parse(tgUrl);

//     try {
//       // LaunchMode.externalApplication қолданушыны тікелей сыртқы қосымшаға (Telegram-ға) жібереді.
//       // ⚠️ Резервтік HTTPS сілтемесін толығымен алып тастадық.
//       if (await launchUrl(tgUri, mode: LaunchMode.externalApplication)) {
//         // Сәтті ашылды
//       } else {
//         // Егер тікелей Telegram қосымшасын ашу сәтсіз болса
//         if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Telegram қосымшасын ашу мүмкін болмады. Қосымшаның орнатылғанын тексеріңіз.')),
//             );
//         }
//       }
//     } catch (e) {
//       // Қате болған жағдайда (мысалы, URL дұрыс емес немесе рұқсат жоқ)
//        if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Қате: Telegram сілтемесін ашу сәтсіз аяқталды.')),
//             );
//         }
//     }
//   }
  
//   // ... (КБЖУ виджеті, Сурет қатесі виджеті, Санды таңдау виджеті өзгеріссіз)
//   Widget _buildKbsuItem(String title, double value, String unit, Color color) {
//     return Column(
//       children: [
//         Container(
//           width: 80,
//           height: 80,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: color.withOpacity(0.5), width: 2),
//           ),
//           child: Center(
//             child: Text(
//               '${value.toStringAsFixed(1)} $unit',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
//             ),
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
//       ],
//     );
//   }
  
//   Widget _imageErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
//     return Container(
//       color: Colors.grey[200],
//       alignment: Alignment.center,
//       child: const Text('Image Error', style: TextStyle(color: Colors.grey)),
//     );
//   }

//   Widget _buildQuantitySelector() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           'Количество',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             color: kPrimaryColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.remove, color: kPrimaryColor),
//                 onPressed: _decrementQuantity,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Text(
//                   '$_quantity',
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryColor),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.add, color: kPrimaryColor),
//                 onPressed: _incrementQuantity,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double totalPrice = widget.product.price * _quantity;

//     return Scaffold(
//       backgroundColor: kBackgroundColor,
//       body: Stack(
//         children: [
//           // Жоғарғы сурет бөлігі
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             height: MediaQuery.of(context).size.height * 0.4,
//             child: Image.asset(
//               widget.product.imagePath, 
//               fit: BoxFit.cover,
//               errorBuilder: _imageErrorBuilder,
//             ),
//           ),
//           // Артқа және Жабу батырмалары 
//           Positioned(
//             top: 40,
//             left: 10,
//             child: Container(
//               decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
//               child: IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Colors.black),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 40,
//             right: 10,
//             child: Container(
//               decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
//               child: IconButton(
//                 icon: const Icon(Icons.close, color: Colors.black),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),
//           ),
//           // Негізгі сипаттама бөлігі
//           Positioned.fill(
//             top: MediaQuery.of(context).size.height * 0.35,
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//               ),
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(25),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.product.name,
//                       style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       widget.product.weight,
//                       style: const TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                     const SizedBox(height: 20),
                    
//                     // 🟢 САНЫН ТАҢДАУ БӨЛІМІ
//                     _buildQuantitySelector(),
//                     const SizedBox(height: 20),

//                     const Text('Описание', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 10),
//                     Text(
//                       widget.product.description,
//                       style: const TextStyle(fontSize: 16, height: 1.5),
//                     ),
//                     const SizedBox(height: 30),

//                     // КБЖУ бөлігі
//                     const Text('Энергетическая ценность', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 15),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         _buildKbsuItem('Каллории', widget.product.kbsu['Калории']!, 'ккал', Colors.orange.shade700),
//                         _buildKbsuItem('Белки', widget.product.kbsu['Белки']!, 'г', Colors.green.shade700),
//                         _buildKbsuItem('Жиры', widget.product.kbsu['Жиры']!, 'г', Colors.brown.shade700),
//                         _buildKbsuItem('Углеводы', widget.product.kbsu['Углеводы']!, 'г', Colors.blue.shade700),
//                       ],
//                     ),
//                     const SizedBox(height: 50),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // Төменгі Баға және Заказ батырмасы
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Общая Стоимость', style: TextStyle(fontSize: 14, color: Colors.grey)),
//                       // 🟢 Есептелген баға
//                       Text(
//                         '\$${totalPrice.toStringAsFixed(2)}',
//                         style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kPrimaryColor),
//                       ),
//                     ],
//                   ),
//                   ElevatedButton(
//                     onPressed: _launchTelegramChat, // 🟢 Жаңа функцияны шақырамыз
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: kPrimaryColor, 
//                       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                     ),
//                     child: const Text('Заказать', style: TextStyle(fontSize: 18, color: Colors.white)),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
