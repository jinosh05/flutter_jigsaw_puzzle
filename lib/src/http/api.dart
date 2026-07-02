import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  static String url = 'https://api.pexels.com/v1';
  static String image = url + '/curated';
  static Map<String, String> header = {
    "Authorization": dotenv.env['PEXELS_API_KEY'] ?? '',
  };
}
