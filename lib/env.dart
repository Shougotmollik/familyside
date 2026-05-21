import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvHandler {
  EnvHandler._();

  static String get googleMapApiKey =>
      dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
}
