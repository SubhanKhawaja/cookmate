import 'dart:io';

Future<void> main() async {
  final client = HttpClient();
  client.userAgent = 'Mozilla/5.0 CookMate/1.0';

  final list = {
    'wiki_tiramisu_1': 'https://upload.wikimedia.org/wikipedia/commons/0/0d/Tiramisu_dessert.jpg',
    'wiki_tiramisu_2': 'https://upload.wikimedia.org/wikipedia/commons/3/3b/Tiramisu_-_Raffaele_Diomede.jpg',
    'wiki_fajitas_1': 'https://upload.wikimedia.org/wikipedia/commons/8/8a/Fajitas.jpg',
    'wiki_fajitas_2': 'https://upload.wikimedia.org/wikipedia/commons/4/4d/Fajita.JPG',
    'wiki_guac_1': 'https://upload.wikimedia.org/wikipedia/commons/9/9a/Guacamole_y_nachos.jpg',
    'wiki_guac_2': 'https://upload.wikimedia.org/wikipedia/commons/c/c0/Guacamole_IMGP1289.jpg',
    'bolognese_verified': 'https://images.unsplash.com/photo-1622973536968-3ead9e780960?w=800&auto=format&fit=crop&q=80',
    'enchiladas_verified': 'https://images.unsplash.com/photo-1534352956036-cd81e27dd615?w=800&auto=format&fit=crop&q=80',
  };

  final outDir = Directory('d:/flutter/Flutter_Projects/cookmate/scratch/imgs');
  for (final entry in list.entries) {
    try {
      final req = await client.getUrl(Uri.parse(entry.value));
      final res = await req.close();
      if (res.statusCode == 200) {
        final file = File('${outDir.path}/${entry.key}.jpg');
        await res.pipe(file.openWrite());
        print('Downloaded ${entry.key}: ${file.lengthSync()} bytes');
      } else {
        print('Status ${res.statusCode} for ${entry.key}');
      }
    } catch (e) {
      print('Error ${entry.key}: $e');
    }
  }
  client.close();
}
