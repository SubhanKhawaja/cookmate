import 'dart:io';

Future<void> main() async {
  final client = HttpClient();

  final list = {
    // Tiramisu
    'tiramisu_a': 'https://images.unsplash.com/photo-1534432182912-63863115e106?w=600&fit=crop&q=80',
    'tiramisu_b': 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=600&fit=crop&q=80',
    'tiramisu_c': 'https://images.unsplash.com/photo-1606890737304-57a1ca8a5b62?w=600&fit=crop&q=80',
    'tiramisu_d': 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=600&fit=crop&q=80',
    // Fajitas
    'fajita_a': 'https://images.unsplash.com/photo-1543339308-43e59d6b73a6?w=600&fit=crop&q=80',
    'fajita_b': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&fit=crop&q=80',
    'fajita_c': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&fit=crop&q=80',
    'fajita_d': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=600&fit=crop&q=80',
    // Guacamole
    'guac_a': 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=600&fit=crop&q=80',
    'guac_b': 'https://images.unsplash.com/photo-1604467715878-83e57e8bc129?w=600&fit=crop&q=80',
    'guac_c': 'https://images.unsplash.com/photo-1615870216519-2f9fa575fa5c?w=600&fit=crop&q=80',
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
