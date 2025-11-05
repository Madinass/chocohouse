import 'package:flutter/material.dart';
const Color kPrimaryColor = Color(0xFF9C27B0); 
const Color kBackgroundColor = Color(0xFFF5F5F5); 

class Product {
  final String name;
  final double price;
  final String imagePath;
  final String weight; 
  final double calories; 
  final String description; 
  final Map<String, double> kbsu; 
  final String category; 

  Product({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.weight,
    required this.calories,
    required this.description,
    required this.kbsu,
    required this.category, 
  });
}

final List<Product> dummyProducts = [
  Product(name: 'Торт "Медовик"', price: 5.50, imagePath: 'assets/product_1.png', weight: '3 кг', calories: 970.0, description: 'Классический медовый торт, пропитанный нежным сметанным кремом.', kbsu: {'Калории': 970.0, 'Белки': 8.0, 'Жиры': 15.0, 'Углеводы': 45.0}, category: 'Торты'),
  Product(name: 'Торт "Сникерс"', price: 6.50, imagePath: 'assets/tort_snikers.png', weight: '150 гр', calories: 450.0, description: 'Шоколадный бисквит, арахис, карамель и сливочный крем.', kbsu: {'Калории': 450.0, 'Белки': 10.0, 'Жиры': 22.0, 'Углеводы': 55.0}, category: 'Торты'),
  Product(name: 'Торт "Наполеон"', price: 5.00, imagePath: 'assets/tort_napoleon.png', weight: '130 гр', calories: 380.0, description: 'Многослойный торт с нежным заварным кремом.', kbsu: {'Калории': 380.0, 'Белки': 7.0, 'Жиры': 18.0, 'Углеводы': 48.0}, category: 'Торты'),
  Product(name: 'Торт "Красный Бархат"', price: 7.00, imagePath: 'assets/product_2.png', weight: '140 гр', calories: 410.0, description: 'Ярко-красный бисквит с сырным кремом.', kbsu: {'Калории': 410.0, 'Белки': 8.5, 'Жиры': 20.0, 'Углеводы': 50.0}, category: 'Торты'),
  Product(name: 'Торт "Тирамису"', price: 6.00, imagePath: 'assets/tort_tiramisu.png', weight: '135 гр', calories: 360.0, description: 'Итальянский многослойный десерт с кофе и маскарпоне.', kbsu: {'Калории': 360.0, 'Белки': 9.0, 'Жиры': 16.0, 'Углеводы': 44.0}, category: 'Торты'),
  Product(name: 'Торт "Три Шоколада"', price: 7.50, imagePath: 'assets/tort_trishokolada.png', weight: '160 гр', calories: 500.0, description: 'Муссовый торт с тремя видами бельгийского шоколада.', kbsu: {'Калории': 500.0, 'Белки': 12.0, 'Жиры': 28.0, 'Углеводы': 58.0}, category: 'Торты'),
  Product(name: 'Торт "Морковный"', price: 6.20, imagePath: 'assets/tort_morkovnyy.png', weight: '130 гр', calories: 390.0, description: 'Пряный бисквит с морковью, орехами и сливочным кремом.', kbsu: {'Калории': 390.0, 'Белки': 6.5, 'Жиры': 17.0, 'Углеводы': 52.0}, category: 'Торты'),
  Product(name: 'Торт "Птичье Молоко"', price: 5.80, imagePath: 'assets/tort_ptichyemoloko.png', weight: '110 гр', calories: 330.0, description: 'Нежное суфле на тонком бисквите, покрытое шоколадной глазурью.', kbsu: {'Калории': 330.0, 'Белки': 5.0, 'Жиры': 14.0, 'Углеводы': 48.0}, category: 'Торты'),
  Product(name: 'Торт "Фруктовый Рай"', price: 6.90, imagePath: 'assets/tort_fruktovyy.png', weight: '150 гр', calories: 310.0, description: 'Легкий йогуртовый мусс с обилием свежих фруктов и ягод.', kbsu: {'Калории': 310.0, 'Белки': 7.0, 'Жиры': 12.0, 'Углеводы': 42.0}, category: 'Торты'),
  Product(name: 'Торт "Прага"', price: 5.70, imagePath: 'assets/tort_praga.png', weight: '125 гр', calories: 420.0, description: 'Шоколадный бисквит с масляным кремом и абрикосовым джемом.', kbsu: {'Калории': 420.0, 'Белки': 8.0, 'Жиры': 21.0, 'Углеводы': 50.0}, category: 'Торты'),

  Product(name: 'Пирожное "Красный бархат"', price: 3.00, imagePath: 'assets/pirojnoe_redvelvet.png', weight: '80 гр', calories: 280.0, description: 'Сочное пирожное "Красный бархат" с воздушным сливочно-сырным кремом.', kbsu: {'Калории': 280.0, 'Белки': 6.5, 'Жиры': 12.5, 'Углеводы': 35.0}, category: 'Пирожные'),
  Product(name: 'Пирожное "Картошка"', price: 1.50, imagePath: 'assets/pirojnoe_kartoshka.png', weight: '60 гр', calories: 220.0, description: 'Классическое пирожное из бисквитной крошки с кремом.', kbsu: {'Калории': 220.0, 'Белки': 4.0, 'Жиры': 10.0, 'Углеводы': 28.0}, category: 'Пирожные'),
  Product(name: 'Эклер ванильный', price: 2.50, imagePath: 'assets/pirojnoe_ekler.png', weight: '70 гр', calories: 240.0, description: 'Заварное тесто с нежным ванильным кремом.', kbsu: {'Калории': 240.0, 'Белки': 5.5, 'Жиры': 11.0, 'Углеводы': 30.0}, category: 'Пирожные'),
  Product(name: 'Пирожное "Павлова"', price: 4.00, imagePath: 'assets/pirojnoe_pavlova.png', weight: '75 гр', calories: 200.0, description: 'Воздушное безе со сливочным кремом и свежими ягодами.', kbsu: {'Калории': 200.0, 'Белки': 3.0, 'Жиры': 8.0, 'Углеводы': 32.0}, category: 'Пирожные'),
  Product(name: 'Капкейк шоколадный', price: 2.20, imagePath: 'assets/pirojnoe_kapkeyk.png', weight: '90 гр', calories: 300.0, description: 'Небольшой шоколадный кекс с кремовой шапочкой.', kbsu: {'Калории': 300.0, 'Белки': 6.0, 'Жиры': 14.0, 'Углеводы': 38.0}, category: 'Пирожные'),
  Product(name: 'Пирожное "Три Шоколада"', price: 3.50, imagePath: 'assets/pirojnoe_trishokolada.png', weight: '85 гр', calories: 330.0, description: 'Муссовое пирожное с тремя слоями шоколада.', kbsu: {'Калории': 330.0, 'Белки': 7.0, 'Жиры': 16.0, 'Углеводы': 40.0}, category: 'Пирожные'),
  Product(name: 'Пирожное "Банановый рай"', price: 2.80, imagePath: 'assets/pirojnoe_banan.png', weight: '90 гр', calories: 270.0, description: 'Слои бисквита, бананов и карамели.', kbsu: {'Калории': 270.0, 'Белки': 5.0, 'Жиры': 12.0, 'Углеводы': 34.0}, category: 'Пирожные'),
  Product(name: 'Маффин с черникой', price: 1.90, imagePath: 'assets/pirojnoe_maffin_chernika.png', weight: '85 гр', calories: 260.0, description: 'Мягкий маффин с черникой и хрустящей крошкой.', kbsu: {'Калории': 260.0, 'Белки': 5.0, 'Жиры': 12.0, 'Углеводы': 33.0}, category: 'Пирожные'),
  Product(name: 'Пирожное "Муравейник"', price: 1.70, imagePath: 'assets/pirojnoe_muraveynik.png', weight: '70 гр', calories: 250.0, description: 'Крошка песочного теста, смешанная с вареной сгущенкой.', kbsu: {'Калории': 250.0, 'Белки': 4.5, 'Жиры': 11.0, 'Углеводы': 31.0}, category: 'Пирожные'),
  Product(name: 'Трубочка с заварным кремом', price: 2.00, imagePath: 'assets/pirojnoe_trubochka.png', weight: '75 гр', calories: 230.0, description: 'Хрустящая вафельная трубочка с заварным кремом.', kbsu: {'Калории': 230.0, 'Белки': 5.0, 'Жиры': 10.0, 'Углеводы': 29.0}, category: 'Пирожные'),

  Product(name: 'Макаронсы (6 шт) - Ассорти', price: 7.50, imagePath: 'assets/product_3.png', weight: '150 гр', calories: 400.0, description: 'Набор из шести макаронсов с разными вкусами.', kbsu: {'Калории': 400.0, 'Белки': 10.0, 'Жиры': 20.0, 'Углеводы': 45.0}, category: 'Макаронсы'),
  Product(name: 'Макаронс "Фисташка"', price: 1.30, imagePath: 'assets/macarons_fistashka.png', weight: '25 гр', calories: 70.0, description: 'Нежный миндальный десерт со вкусом фисташки.', kbsu: {'Калории': 70.0, 'Белки': 2.0, 'Жиры': 3.5, 'Углеводы': 8.0}, category: 'Макаронсы'),
  Product(name: 'Макаронс "Малина"', price: 1.30, imagePath: 'assets/macarons_malina.png', weight: '25 гр', calories: 65.0, description: 'С малиновым джемом и кремом.', kbsu: {'Калории': 65.0, 'Белки': 1.8, 'Жиры': 3.0, 'Углеводы': 7.5}, category: 'Макаронсы'),
  Product(name: 'Макаронс "Шоколад"', price: 1.30, imagePath: 'assets/macarons_shokolad.png', weight: '25 гр', calories: 75.0, description: 'Насыщенный вкус темного шоколада.', kbsu: {'Калории': 75.0, 'Белки': 2.2, 'Жиры': 4.0, 'Углеводы': 8.5}, category: 'Макаронсы'),
  Product(name: 'Макаронс "Лаванда"', price: 1.40, imagePath: 'assets/macarons_lavanda.png', weight: '25 гр', calories: 68.0, description: 'Необычный вкус лаванды с ноткой цитруса.', kbsu: {'Калории': 68.0, 'Белки': 2.0, 'Жиры': 3.2, 'Углеводы': 7.8}, category: 'Макаронсы'),
  Product(name: 'Макаронс "Манго-Маракуйя"', price: 1.40, imagePath: 'assets/macarons_mango.png', weight: '25 гр', calories: 72.0, description: 'Тропический вкус с кислинкой.', kbsu: {'Калории': 72.0, 'Белки': 1.9, 'Жиры': 3.3, 'Углеводы': 8.2}, category: 'Макаронсы'),
  Product(name: 'Макаронс "Карамель"', price: 1.30, imagePath: 'assets/macarons_karamel.png', weight: '25 гр', calories: 70.0, description: 'Сливочная соленая карамель.', kbsu: {'Калории': 70.0, 'Белки': 2.0, 'Жиры': 3.5, 'Углеводы': 8.0}, category: 'Макаронсы'),
  Product(name: 'Макаронс "Кофе"', price: 1.30, imagePath: 'assets/macarons_kofe.png', weight: '25 гр', calories: 67.0, description: 'Натуральный кофе в начинке.', kbsu: {'Калории': 67.0, 'Белки': 1.7, 'Жиры': 3.1, 'Углеводы': 7.9}, category: 'Макаронсы'),
  Product(name: 'Макаронс "Лимон"', price: 1.30, imagePath: 'assets/macarons_limon.png', weight: '25 гр', calories: 65.0, description: 'Освежающий лимонный крем.', kbsu: {'Калории': 65.0, 'Белки': 1.8, 'Жиры': 3.0, 'Углеводы': 7.5}, category: 'Макаронсы'),
  Product(name: 'Макаронсы (12 шт) - Премиум', price: 14.00, imagePath: 'assets/macarons_premium.png', weight: '300 гр', calories: 800.0, description: 'Большой набор из 12 макаронсов с разными вкусами.', kbsu: {'Калории': 800.0, 'Белки': 20.0, 'Жиры': 40.0, 'Углеводы': 90.0}, category: 'Макаронсы'),

  Product(name: 'Чизкейк "Нью-Йорк"', price: 4.50, imagePath: 'assets/product_4.png', weight: '130 гр', calories: 380.0, description: 'Классический сливочный чизкейк на песочной основе.', kbsu: {'Калории': 380.0, 'Белки': 9.0, 'Жиры': 22.0, 'Углеводы': 35.0}, category: 'Чизкейки'),
  Product(name: 'Чизкейк "Ягодный"', price: 5.00, imagePath: 'assets/chizkeyik_yagodnyy.png', weight: '140 гр', calories: 350.0, description: 'Нежный чизкейк с топпингом из свежих лесных ягод.', kbsu: {'Калории': 350.0, 'Белки': 8.5, 'Жиры': 20.0, 'Углеводы': 32.0}, category: 'Чизкейки'),
  Product(name: 'Чизкейк "Шоколадный"', price: 4.80, imagePath: 'assets/chizkeyik_shokoladnyy.png', weight: '135 гр', calories: 400.0, description: 'Насыщенный шоколадный вкус.', kbsu: {'Калории': 400.0, 'Белки': 9.5, 'Жиры': 24.0, 'Углеводы': 38.0}, category: 'Чизкейки'),
  Product(name: 'Чизкейк "Орео"', price: 5.20, imagePath: 'assets/chizkeyik_oreo.png', weight: '145 гр', calories: 420.0, description: 'С кусочками печенья Oreo.', kbsu: {'Калории': 420.0, 'Белки': 10.0, 'Жиры': 25.0, 'Углеводы': 40.0}, category: 'Чизкейки'),
  Product(name: 'Чизкейк "Манго"', price: 5.10, imagePath: 'assets/chizkeyik_mango.png', weight: '140 гр', calories: 340.0, description: 'Тропический чизкейк с пюре манго.', kbsu: {'Калории': 340.0, 'Белки': 8.0, 'Жиры': 19.0, 'Углеводы': 30.0}, category: 'Чизкейки'),
  Product(name: 'Чизкейк "Соленая Карамель"', price: 5.30, imagePath: 'assets/chizkeyik_karamel.png', weight: '150 гр', calories: 410.0, description: 'С карамельным соусом и морской солью.', kbsu: {'Калории': 410.0, 'Белки': 9.0, 'Жиры': 23.0, 'Углеводы': 39.0}, category: 'Чизкейки'),
  Product(name: 'Чизкейк "Лимонный"', price: 4.60, imagePath: 'assets/chizkeyik_limonnyy.png', weight: '130 гр', calories: 360.0, description: 'С легкой лимонной кислинкой.', kbsu: {'Калории': 360.0, 'Белки': 8.5, 'Жиры': 21.0, 'Углеводы': 33.0}, category: 'Чизкейки'),
  Product(name: 'Чизкейк "Клубничный"', price: 5.00, imagePath: 'assets/chizkeyik_klubnichnyy.png', weight: '140 гр', calories: 370.0, description: 'С прослойкой клубничного конфитюра.', kbsu: {'Калории': 370.0, 'Белки': 9.0, 'Жиры': 21.5, 'Углеводы': 34.0}, category: 'Чизкейки'),
  Product(name: 'Чизкейк "Тыквенный"', price: 4.70, imagePath: 'assets/chizkeyik_tykvennyy.png', weight: '135 гр', calories: 390.0, description: 'Осенний пряный вкус с тыквой.', kbsu: {'Калории': 390.0, 'Белки': 8.8, 'Жиры': 22.5, 'Углеводы': 36.0}, category: 'Чизкейки'),
  Product(name: 'Чизкейк "Баскский"', price: 5.40, imagePath: 'assets/chizkeyik_basskiy.png', weight: '145 гр', calories: 430.0, description: 'Карамелизированный сверху, нежный внутри.', kbsu: {'Калории': 430.0, 'Белки': 10.5, 'Жиры': 26.0, 'Углеводы': 41.0}, category: 'Чизкейки'),

  Product(name: 'Бенто "С Днем Рождения"', price: 15.00, imagePath: 'assets/bento_dr.png', weight: '400 гр', calories: 1200.0, description: 'Маленький торт для одного или двоих с поздравительной надписью.', kbsu: {'Калории': 1200.0, 'Белки': 25.0, 'Жиры': 60.0, 'Углеводы': 150.0}, category: 'Бенто торты'),
  Product(name: 'Бенто "Любовь"', price: 16.00, imagePath: 'assets/bento_love.png', weight: '400 гр', calories: 1250.0, description: 'Сердцевидный торт с романтическим декором.', kbsu: {'Калории': 1250.0, 'Белки': 26.0, 'Жиры': 62.0, 'Углеводы': 155.0}, category: 'Бенто торты'),
  Product(name: 'Бенто "Морковный"', price: 14.50, imagePath: 'assets/bento_morkovnyy.png', weight: '400 гр', calories: 1150.0, description: 'Пряный морковный бисквит с сырным кремом.', kbsu: {'Калории': 1150.0, 'Белки': 24.0, 'Жиры': 58.0, 'Углеводы': 145.0}, category: 'Бенто торты'),
  Product(name: 'Бенто "Шоколад"', price: 15.50, imagePath: 'assets/bento_shokolad.png', weight: '400 гр', calories: 1300.0, description: 'Насыщенный шоколадный вкус.', kbsu: {'Калории': 1300.0, 'Белки': 28.0, 'Жиры': 65.0, 'Углеводы': 160.0}, category: 'Бенто торты'),
  Product(name: 'Бенто "Ваниль-Ягода"', price: 15.20, imagePath: 'assets/bento_vanil.png', weight: '400 гр', calories: 1220.0, description: 'Ванильный бисквит с ягодным конфитюром.', kbsu: {'Калории': 1220.0, 'Белки': 25.5, 'Жиры': 61.0, 'Углеводы': 152.0}, category: 'Бенто торты'),
  Product(name: 'Бенто "Минимализм"', price: 14.00, imagePath: 'assets/bento_minimalizm.png', weight: '400 гр', calories: 1100.0, description: 'Стильный торт с минимальным декором.', kbsu: {'Калории': 1100.0, 'Белки': 23.0, 'Жиры': 55.0, 'Углеводы': 140.0}, category: 'Бенто торты'),
  Product(name: 'Бенто "Для друга"', price: 14.80, imagePath: 'assets/bento_friend.png', weight: '400 гр', calories: 1180.0, description: 'Торт с прикольной надписью.', kbsu: {'Калории': 1180.0, 'Белки': 24.5, 'Жиры': 59.0, 'Углеводы': 148.0}, category: 'Бенто торты'),
  Product(name: 'Бенто "Сюрприз"', price: 16.50, imagePath: 'assets/bento_surprise.png', weight: '400 гр', calories: 1350.0, description: 'Эксклюзивный дизайн, полный сюрприз.', kbsu: {'Калории': 1350.0, 'Белки': 29.0, 'Жиры': 68.0, 'Углеводы': 165.0}, category: 'Бенто торты'),
  Product(name: 'Бенто "Красный бархат"', price: 15.80, imagePath: 'assets/bento_redvelvet.png', weight: '400 гр', calories: 1280.0, description: 'Красный бисквит с сырным кремом.', kbsu: {'Калории': 1280.0, 'Белки': 27.0, 'Жиры': 64.0, 'Углеводы': 158.0}, category: 'Бенто торты'),
  Product(name: 'Бенто "Тропики"', price: 15.30, imagePath: 'assets/bento_tropiki.png', weight: '400 гр', calories: 1230.0, description: 'Сочный торт с манго и маракуйей.', kbsu: {'Калории': 1230.0, 'Белки': 25.0, 'Жиры': 60.0, 'Углеводы': 153.0}, category: 'Бенто торты'),

  Product(name: 'Круассан классический', price: 2.00, imagePath: 'assets/vypechka_kruassan.png', weight: '70 гр', calories: 250.0, description: 'Воздушный слоеный круассан с золотистой корочкой.', kbsu: {'Калории': 250.0, 'Белки': 5.0, 'Жиры': 14.0, 'Углеводы': 28.0}, category: 'Выпечка'),
  Product(name: 'Синнабон', price: 3.50, imagePath: 'assets/vypechka_sinnabon.png', weight: '110 гр', calories: 380.0, description: 'Знаменитая булочка с корицей, залитая сливочным кремом.', kbsu: {'Калории': 380.0, 'Белки': 7.5, 'Жиры': 16.0, 'Углеводы': 50.0}, category: 'Выпечка'),
  Product(name: 'Пирог с вишней', price: 2.80, imagePath: 'assets/vypechka_pirog_vishnya.png', weight: '100 гр', calories: 310.0, description: 'Несладкий пирог с сочной вишневой начинкой.', kbsu: {'Калории': 310.0, 'Белки': 6.0, 'Жиры': 13.0, 'Углеводы': 40.0}, category: 'Выпечка'),
  Product(name: 'Штрудель яблочный', price: 3.20, imagePath: 'assets/vypechka_shtrudel.png', weight: '120 гр', calories: 360.0, description: 'Тонкое слоеное тесто с яблоками и корицей.', kbsu: {'Калории': 360.0, 'Белки': 6.5, 'Жиры': 15.0, 'Углеводы': 48.0}, category: 'Выпечка'),
  Product(name: 'Булочка с маком', price: 1.50, imagePath: 'assets/vypechka_mak.png', weight: '80 гр', calories: 230.0, description: 'Мягкая сдобная булочка с обильной маковой начинкой.', kbsu: {'Калории': 230.0, 'Белки': 5.0, 'Жиры': 10.0, 'Углеводы': 30.0}, category: 'Выпечка'),
  Product(name: 'Сочник с творогом', price: 1.80, imagePath: 'assets/vypechka_sochnik.png', weight: '90 гр', calories: 270.0, description: 'Песочное тесто с нежной творожной начинкой.', kbsu: {'Калории': 270.0, 'Белки': 8.0, 'Жиры': 12.0, 'Углеводы': 32.0}, category: 'Выпечка'),
  Product(name: 'Киш с курицей и грибами', price: 4.50, imagePath: 'assets/vypechka_kish.png', weight: '150 гр', calories: 400.0, description: 'Французский открытый пирог с начинкой из курицы и шампиньонов.', kbsu: {'Калории': 400.0, 'Белки': 15.0, 'Жиры': 25.0, 'Углеводы': 30.0}, category: 'Выпечка'),
  Product(name: 'Пончик с глазурью', price: 1.70, imagePath: 'assets/vypechka_ponchik.png', weight: '60 гр', calories: 210.0, description: 'Пышный пончик с разноцветной сахарной глазурью.', kbsu: {'Калории': 210.0, 'Белки': 4.0, 'Жиры': 10.0, 'Углеводы': 27.0}, category: 'Выпечка'),
  Product(name: 'Хлеб чиабатта', price: 3.00, imagePath: 'assets/vypechka_chiabatta.png', weight: '200 гр', calories: 550.0, description: 'Традиционный итальянский хлеб с хрустящей корочкой.', kbsu: {'Калории': 550.0, 'Белки': 15.0, 'Жиры': 5.0, 'Углеводы': 110.0}, category: 'Выпечка'),
  Product(name: 'Сосиска в тесте', price: 2.50, imagePath: 'assets/vypechka_sosiska.png', weight: '120 гр', calories: 350.0, description: 'Сочная сосиска в воздушном дрожжевом тесте.', kbsu: {'Калории': 350.0, 'Белки': 10.0, 'Жиры': 18.0, 'Углеводы': 30.0}, category: 'Выпечка'),

  Product(name: 'Капучино', price: 2.50, imagePath: 'assets/napitki_kapuchino.png', weight: '250 мл', calories: 120.0, description: 'Классический кофе с молоком и пышной пенкой.', kbsu: {'Калории': 120.0, 'Белки': 5.0, 'Жиры': 5.0, 'Углеводы': 14.0}, category: 'Напитки'),
  Product(name: 'Американо', price: 1.80, imagePath: 'assets/napitki_amerikano.png', weight: '300 мл', calories: 5.0, description: 'Черный кофе, классика жанра.', kbsu: {'Калории': 5.0, 'Белки': 0.5, 'Жиры': 0.1, 'Углеводы': 1.0}, category: 'Напитки'),
  Product(name: 'Латте Ванильный', price: 3.00, imagePath: 'assets/napitki_latte_vanil.png', weight: '350 мл', calories: 180.0, description: 'Латте с добавлением ванильного сиропа.', kbsu: {'Калории': 180.0, 'Белки': 6.0, 'Жиры': 7.0, 'Углеводы': 22.0}, category: 'Напитки'),
  Product(name: 'Чай Черный Ассам', price: 1.50, imagePath: 'assets/napitki_chay_assam.png', weight: '400 мл', calories: 5.0, description: 'Классический крепкий черный чай.', kbsu: {'Калории': 5.0, 'Белки': 0.1, 'Жиры': 0.0, 'Углеводы': 1.0}, category: 'Напитки'),
  Product(name: 'Свежевыжатый Апельсиновый Сок', price: 4.00, imagePath: 'assets/napitki_sok_apelsin.png', weight: '200 мл', calories: 90.0, description: 'Натуральный сок без добавок.', kbsu: {'Калории': 90.0, 'Белки': 1.0, 'Жиры': 0.2, 'Углеводы': 20.0}, category: 'Напитки'),
  Product(name: 'Милкшейк "Клубника"', price: 4.50, imagePath: 'assets/napitki_milksheyik.png', weight: '300 мл', calories: 350.0, description: 'Холодный молочный коктейль со вкусом клубники.', kbsu: {'Калории': 350.0, 'Белки': 8.0, 'Жиры': 15.0, 'Углеводы': 45.0}, category: 'Напитки'),
  Product(name: 'Горячий Шоколад', price: 3.50, imagePath: 'assets/napitki_goryachiy_shokolad.png', weight: '200 мл', calories: 250.0, description: 'Густой и насыщенный горячий шоколад.', kbsu: {'Калории': 250.0, 'Белки': 7.0, 'Жиры': 10.0, 'Углеводы': 35.0}, category: 'Напитки'),
  Product(name: 'Мохито (безалкогольный)', price: 3.80, imagePath: 'assets/napitki_mohito.png', weight: '350 мл', calories: 150.0, description: 'Освежающий напиток с лаймом и мятой.', kbsu: {'Калории': 150.0, 'Белки': 0.5, 'Жиры': 0.1, 'Углеводы': 35.0}, category: 'Напитки'),
  Product(name: 'Айс Латте', price: 3.20, imagePath: 'assets/napitki_ayslatte.png', weight: '300 мл', calories: 100.0, description: 'Холодный латте со льдом.', kbsu: {'Калории': 100.0, 'Белки': 4.0, 'Жиры': 4.0, 'Углеводы': 12.0}, category: 'Напитки'),
  Product(name: 'Сок "Вишня"', price: 2.20, imagePath: 'assets/napitki_sok_vishnya.png', weight: '300 мл', calories: 140.0, description: 'Натуральный вишневый сок.', kbsu: {'Калории': 140.0, 'Белки': 1.0, 'Жиры': 0.1, 'Углеводы': 32.0}, category: 'Напитки'),
];