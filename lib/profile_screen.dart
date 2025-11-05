import 'package:flutter/material.dart';
import 'models.dart';

class UserData {
  final String name;
  final String email;
  final int bonusPoints;
  final String profileImagePath;

  UserData({
    required this.name,
    required this.email,
    this.bonusPoints = 150, 
    this.profileImagePath = 'assets/user_avatar.png', 
  });
}

final UserData currentUser = UserData(
  name: 'Профиль', 
  email: ' ',
);


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('Мой Профиль', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Вы вышли из аккаунта.')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfoCard(context),
            const SizedBox(height: 25),
            _buildBonusSection(context), 
            const SizedBox(height: 25),
            const Text('Основные разделы', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 10),
            _buildProfileMenuItem(context, 'Сменить Пароль', Icons.lock_open_outlined, Colors.blue),
            _buildProfileMenuItem(context, 'Язык Интерфейса', Icons.language_outlined, Colors.brown),
            _buildProfileMenuItem(context, 'Настройки Уведомлений', Icons.notifications_none, kPrimaryColor),

            const SizedBox(height: 15),
            _buildProfileMenuItem(context, 'Помощь и Поддержка', Icons.help_outline, Colors.orange, isImportant: true),
            _buildProfileMenuItem(context, 'Заказ через Telegram', Icons.telegram, Colors.blueAccent, isImportant: true),

            const SizedBox(height: 30),
            
            Center(
              child: Text(
                'Версия приложения 1.0.0', 
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: kPrimaryColor.withOpacity(0.1),
            child: Image.asset(
              currentUser.profileImagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 40, color: kPrimaryColor),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentUser.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  currentUser.email,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.edit, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildBonusSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Переход на страницу бонусов')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [BoxShadow(color: kPrimaryColor.withOpacity(0.3), spreadRadius: 2, blurRadius: 8)],
        ),
        child: Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ваши Бонусы', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white70)),
                  Text(
                    '${currentUser.bonusPoints} БАЛЛОВ',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(BuildContext context, String title, IconData icon, Color color, {bool isImportant = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Card(
        elevation: isImportant ? 2 : 0, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          title: Text(title, style: TextStyle(fontSize: 16, fontWeight: isImportant ? FontWeight.bold : FontWeight.normal)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: () {
            if (title == 'Заказ через Telegram') {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Открытие Telegram Bot...')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Переход на страницу "$title"')),
              );
            }
          },
        ),
      ),
    );
  }
}