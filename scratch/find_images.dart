import 'dart:io';

Future<void> main() async {
  final client = HttpClient();

  // Test tiramisu and Mexican food URLs
  final urls = [
    // Tiramisu
    'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9',
    'https://images.unsplash.com/photo-1542826438-bd32f43d626f', // tiramisu / dessert
    'https://images.unsplash.com/photo-1587314168485-3236d6710814', // dessert tiramisu
    'https://images.unsplash.com/photo-1551024709-8f23befc6f87', // dessert
    'https://images.unsplash.com/photo-1534432182912-63863115e106', // tiramisu
    'https://images.unsplash.com/photo-1606890737304-57a1ca8a5b62', // tiramisu
    // Fajitas (skillet, peppers, onions, sizzling meat)
    'https://images.unsplash.com/photo-1565299585323-38d6b0865b47',
    'https://images.unsplash.com/photo-1504544750208-dc0358e63f7f',
    'https://images.unsplash.com/photo-1599974579688-8dbdd335c77f',
    // Enchiladas Verdes (baked rolled tortillas with green tomatillo sauce and cheese)
    'https://images.unsplash.com/photo-1584536286788-78ae83c2c54d',
    'https://images.unsplash.com/photo-1565299507177-b0ac66763828',
    'https://images.unsplash.com/photo-1541544741938-0af808871cc0',
    // Guacamole
    'https://images.unsplash.com/photo-1604467715878-83e57e8bc129',
    'https://images.unsplash.com/photo-1528735602780-2552fd46c7af',
  ];

  for (final url in urls) {
    try {
      final req = await client.headUrl(Uri.parse(url + '?w=800&auto=format&fit=crop&q=80'));
      final res = await req.close();
      print('[' + res.statusCode.toString() + '] ' + url);
    } catch (e) {
      print('[ERR] ' + url);
    }
  }

  client.close();
}
