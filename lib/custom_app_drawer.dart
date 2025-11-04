import 'package:flutter/material.dart';

const Color _darkDrawerColor = Color(0xFF1E1E1E); 
const Color _whiteColor = Colors.white;
const Color _accentColor = Color(0xFFE9B086); 

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: _darkDrawerColor, 
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          
          DrawerHeader(
            decoration: const BoxDecoration(
              color: _darkDrawerColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.flutter_dash, 
                  color: _accentColor,
                  size: 50,
                ),
                const SizedBox(height: 10),
                const Text('Choco House',
                    style: TextStyle(
                        color: _whiteColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                Text('coffee & more',
                    style: TextStyle(color: _whiteColor.withOpacity(0.7))),
              ],
            ),
          ),
          
          
          _buildDrawerItem(
              icon: Icons.restaurant_menu, title: 'Меню', onTap: () {}),
          _buildDrawerItem(
              icon: Icons.shopping_cart, title: 'Корзина', onTap: () {}),
          _buildDrawerItem(
              icon: Icons.location_on, title: 'Зоны доставки', onTap: () {}),
          _buildDrawerItem(
              icon: Icons.history, title: 'История заказов', onTap: () {}),
          _buildDrawerItem(
              icon: Icons.message, title: 'Сообщения', onTap: () {}),
          _buildDrawerItem(
              icon: Icons.edit_note, title: 'Написать отзыв', onTap: () {}),
          _buildDrawerItem(
              icon: Icons.local_offer, title: 'Акции', onTap: () {}),

          const Divider(color: Colors.grey),
          _buildDrawerItem(
              icon: Icons.people, title: 'Мы Вконтакте', onTap: () {}),
          _buildDrawerItem(
              icon: Icons.telegram, title: 'Мы в Telegram', onTap: () {}),

          const Divider(color: Colors.grey),
          _buildDrawerItem(
              icon: Icons.info_outline, title: 'О нас', onTap: () {}),

          _buildDrawerItem(
              icon: Icons.lock_open,
              title: 'Войти',
              onTap: () {
                Navigator.pop(context); 
                Navigator.pushNamed(context, '/login'); 
              }),

          const Padding(
            padding: EdgeInsets.only(left: 15.0, top: 10),
            child: Text('Публичный договор оферты',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15.0, top: 5),
            child: Text('Политика конфиденциальности',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.only(left: 15.0, bottom: 20),
            child: Text(
              'Авторы приложения\nТайлақ Мадина, Нұртас Жанерке\n© 2025 Choco House',
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: _whiteColor),
      title: Text(title, style: const TextStyle(color: _whiteColor, fontSize: 16)),
      onTap: onTap,
    );
  }
}