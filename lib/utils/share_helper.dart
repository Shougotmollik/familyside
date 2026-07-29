import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  ShareHelper._();

  static Future<void> shareItem({
    required String name,
    String? description,
    String? category,
    String? location,
    String? price,
    String? extraInfo,
    String? shareUrl,
  }) async {
    final buffer = StringBuffer();

    final title = (extraInfo != null && extraInfo.isNotEmpty)
        ? '$name [${extraInfo.toUpperCase()}]'
        : name;
    buffer.writeln(title);
    buffer.writeln();

    // Details block
    if (category != null && category.isNotEmpty) {
      buffer.writeln('Category: ${_capitalize(category)}');
    }
    if (location != null && location.isNotEmpty) {
      buffer.writeln('Location: $location');
    }
    if (price != null && price.isNotEmpty && price != '\$0') {
      buffer.writeln('Price: $price');
    }

    // Description as its own paragraph
    if (description != null && description.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(description);
    }

    buffer.writeln();

    // Link at the bottom, clearly labeled
    if (shareUrl != null && shareUrl.isNotEmpty) {
      final shortUrl = await _shortenUrl(shareUrl);
      buffer.writeln('View details: $shortUrl');
    } else {
      buffer.writeln('Shared via Familyside');
    }

    await Share.share(buffer.toString().trim());
  }

  static String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static Future<String> _shortenUrl(String url) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://tinyurl.com/api-create.php?url=${Uri.encodeComponent(url)}',
        ),
      );
      if (response.statusCode == 200 && response.body.startsWith('http')) {
        return response.body.trim();
      }
    } catch (_) {
      // fall back below
    }
    return _cleanUrl(url);
  }

  static String _cleanUrl(String url) {
    final uri = Uri.parse(url);
    final host = uri.host.replaceFirst(RegExp(r'^api\.'), '');
    final path = uri.path.replaceFirst(RegExp(r'^/api/v[0-9]+/'), '');
    return '$host/$path';
  }
}
