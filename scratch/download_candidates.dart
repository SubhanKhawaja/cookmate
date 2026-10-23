import 'dart:io';

Future<void> main() async {
  final client = HttpClient();
  final list = {
    'tiramisu_1': 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=600&fit=crop&q=80',
    'tiramisu_3': 'https://images.unsplash.com/photo-1542826438-bd32f43d626f?w=600&fit=crop&q=80',
    'bolognese_1': 'https://images.unsplash.com/photo-1622973536968-3ead9e780960?w=600&fit=crop&q=80',
    'fajitas_1': 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600&fit=crop&q=80',
    'fajitas_2': 'https://images.unsplash.com/photo-1504544750208-dc0358e63f7f?w=600&fit=crop&q=80',
    'enchiladas_1': 'https://images.unsplash.com/photo-1534352956036-cd81e27dd615?w=600&fit=crop&q=80',
    'enchiladas_2': 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=600&fit=crop&q=80',
    'guacamole_1': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=600&fit=crop&q=80',
  };

  final outDir = Directory('d:/flutter/Flutter_Projects/cookmate/scratch/imgs');
  if (!outDir.existsSync()) outDir.createSync(recursive: true);

  for (final entry in list.entries) {
    try {
      final req = await client.getUrl(Uri.parse(entry.value));
      final res = await req.close();
      final file = File('${outDir.path}/${entry.key}.jpg');
      await res.pipe(file.openWrite());
      print('Saved ${entry.key}: ${file.lengthSync()} bytes');
    } catch (e) {
      print('Failed ${entry.key}: $e');
    }
  }
  client.close();
}
