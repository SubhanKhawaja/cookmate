import 'dart:io';

Future<void> main() async {
  final client = HttpClient();

  // Test guacamole & tiramisu URLs
  final urls = {
    // Guacamole & chips
    'guac_tortilla_1': 'https://images.unsplash.com/photo-1541592106381-b31e9677c0e5?w=600&fit=crop&q=80',
    'guac_tortilla_2': 'https://images.unsplash.com/photo-1570461226513-aab3eb38959e?w=600&fit=crop&q=80',
    'guac_tortilla_3': 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=600&fit=crop&q=80',
    'guac_tortilla_4': 'https://images.unsplash.com/photo-1534353436294-0dbd4bdac845?w=600&fit=crop&q=80',
    'guac_tortilla_5': 'https://images.unsplash.com/photo-1582169296194-e4d644c48063?w=600&fit=crop&q=80',
    // Tiramisu (centered, horizontal)
    'tiramisu_h1': 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=800&fit=crop&q=80',
    'tiramisu_h2': 'https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?w=600&fit=crop&q=80',
    'tiramisu_h3': 'https://images.unsplash.com/photo-1508737027454-e6454ef45afd?w=600&fit=crop&q=80',
    'tiramisu_h4': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&fit=crop&q=80',
    'tiramisu_h5': 'https://images.unsplash.com/photo-1541783245831-57d6fb0926d3?w=600&fit=crop&q=80',
  };

  final outDir = Directory('d:/flutter/Flutter_Projects/cookmate/scratch/imgs');
  for (final entry in urls.entries) {
    try {
      final req = await client.getUrl(Uri.parse(entry.value));
      final res = await req.close();
      if (res.statusCode == 200) {
        final file = File('${outDir.path}/${entry.key}.jpg');
        await res.pipe(file.openWrite());
        print('Saved ${entry.key}: ${file.lengthSync()} bytes');
      } else {
        print('HTTP ${res.statusCode} for ${entry.key}');
      }
    } catch (e) {
      print('ERR ${entry.key}: $e');
    }
  }
  client.close();
}
