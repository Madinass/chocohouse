import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchTelegramChat(BuildContext context) async {
  
  const yourUsername = 'zhuka00z'; 
  final tgUrl = 'tg://resolve?domain=$yourUsername'; 
  final tgUri = Uri.parse(tgUrl);

  try {
    if (await launchUrl(tgUri, mode: LaunchMode.externalApplication)) {
    } else {
      if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Telegram қосымшасын ашу мүмкін болмады. Қосымшаның орнатылғанын тексеріңіз.')),
          );
      }
    }
  } catch (e) {
     if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Қате: Telegram сілтемесін ашу сәтсіз аяқталды.')),
          );
      }
  }
}