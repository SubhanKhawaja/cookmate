import 'dart:io';

Future<void> main() async {
  final client = HttpClient();
  final list = {
    'img_steak_ribs': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&fit=crop&q=80',
    'img_steak_strips': 'https://images.unsplash.com/photo-1558030006-450675393462?w=600&fit=crop&q=80',
    'img_bbq_steak': 'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?w=600&fit=crop&q=80',
    'img_food_spread': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&fit=crop&q=80',
    'img_guac_avocado': 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=600&fit=crop&q=80',
    'img_guac_bowl': 'https://images.unsplash.com/photo-1594998893017-36147cbcae05?w=600&fit=crop&q=80',
  };

  final outDir = Directory('d:/flutter/Flutter_Projects/cookmate/scratch/imgs');
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
