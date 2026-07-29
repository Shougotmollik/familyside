class AppCredentials {
  AppCredentials._();

  static const String domain = "https://api.familyside.it";
  // static const String domain = "http://10.10.29.59:8015";

  static String fixurl(String? path) {
    if (path == null || path.isEmpty) return '';
    // avoid double slashes
    if (path.startsWith('http')) return path;
    if (path.startsWith('/')) return '$domain$path';
    return '$domain/$path';
  }
}
