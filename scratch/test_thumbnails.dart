import 'dart:io';

Future<void> main() async {
  final client = HttpClient();
  client.userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36';

  final urls = [
    // Tiramisu thumbnail
    'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Tiramisu_dessert.jpg/800px-Tiramisu_dessert.jpg',
    // Fajitas
    'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Fajitas.jpg/800px-Fajitas.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/Chicken_fajitas.jpg/800px-Chicken_fajitas.jpg',
    // Guacamole
    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/Guacamole_IMGP1289.jpg/800px-Guacamole_IMGP1289.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Guacamole_y_nachos.jpg/800px-Guacamole_y_nachos.jpg',
    // Unsplash candidates for steak / fajita
    'https://images.unsplash.com/photo-1544025162-d76694265947?w=800&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1558030006-450675393462?w=800&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?w=800&auto=format&fit=crop&q=80', // Steak
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&auto=format&fit=crop&q=80', // Food
    // Unsplash candidate for guacamole
    'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=800&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1594998893017-36147cbcae05?w=800&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1592417817098-8f3d69109853?w=800&auto=format&fit=crop&q=80',
  ];

  for (final url in urls) {
    try {
      final req = await client.getUrl(Uri.parse(url));
      final res = await req.close();
      print('[' + res.statusCode.toString() + '] ' + url);
      // Read body to prevent socket hang
      await res.drain();
    } catch (e) {
      print('[ERR: $e] $url');
    }
  }

  client.close();
}
