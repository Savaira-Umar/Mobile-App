import 'app_icons.dart';

/// Offline keyword-based icon detector for task titles.
/// Covers 60+ keywords across English, Urdu and Roman Urdu.
class AutoIcons {
  AutoIcons._();

  static const String defaultIconKey = 'pencil';

  // Keyword to AppIconItem key mapping
  static final Map<String, String> _keywordMap = {
    // Reading & Study
    'read': 'book',
    'reading': 'book',
    'book': 'book',
    'books': 'book',
    'kitab': 'book',
    'kitaab': 'book',
    'parhai': 'book',
    'parhna': 'book',
    'padhai': 'book',
    'study': 'book',
    'studying': 'book',
    'homework': 'book',
    'assignment': 'book',
    'exam': 'book',
    'test': 'book',
    'revision': 'book',
    'sabak': 'book',
    'سبق': 'book',
    'کتاب': 'book',
    'پڑھائی': 'book',

    // Programming & Tech
    'programming': 'laptop',
    'code': 'laptop',
    'coding': 'laptop',
    'developer': 'laptop',
    'software': 'laptop',
    'flutter': 'laptop',
    'dart': 'laptop',
    'python': 'laptop',
    'laptop': 'laptop',
    'computer': 'laptop',
    'bug': 'laptop',
    'github': 'laptop',
    'debugging': 'laptop',

    // Exercise & Fitness
    'exercise': 'dumbbell',
    'gym': 'dumbbell',
    'workout': 'dumbbell',
    'dumbbell': 'dumbbell',
    'fitness': 'dumbbell',
    'training': 'dumbbell',
    'kasrat': 'dumbbell',
    'ورزش': 'dumbbell',
    'walk': 'run',
    'walking': 'run',
    'run': 'run',
    'running': 'run',
    'jog': 'run',
    'jogging': 'run',
    'sair': 'run',
    'سیر': 'run',

    // Plants & Nature
    'plant': 'plant',
    'plants': 'plant',
    'flower': 'plant',
    'flowers': 'plant',
    'garden': 'plant',
    'gardening': 'plant',
    'paudhe': 'plant',
    'pauda': 'plant',
    'پودے': 'plant',
    'water plants': 'plant',

    // Food, Drinks & Tea
    'cup': 'cup',
    'tea': 'cup',
    'chai': 'cup',
    'coffee': 'cup',
    'drink': 'cup',
    'water': 'cup',
    'pani': 'cup',
    'پانی': 'cup',
    'چائے': 'cup',
    'breakfast': 'food',
    'lunch': 'food',
    'dinner': 'food',
    'cook': 'food',
    'cooking': 'food',
    'khana': 'food',
    'khana pakana': 'food',
    'کھانا': 'food',

    // Cleaning & House
    'clean': 'broom',
    'cleaning': 'broom',
    'safai': 'broom',
    'broom': 'broom',
    'dusting': 'broom',
    'laundry': 'broom',
    'wash': 'broom',
    'dhona': 'broom',
    'صفائی': 'broom',

    // Prayer, Namaz & Spiritual
    'prayer': 'mosque',
    'namaz': 'mosque',
    'namaz e fajr': 'mosque',
    'salah': 'mosque',
    'dua': 'mosque',
    'quran': 'mosque',
    'tilawat': 'mosque',
    'tasbeeh': 'mosque',
    'zikr': 'mosque',
    'نماز': 'mosque',
    'دعا': 'mosque',
    'قرآن': 'mosque',

    // Writing & Notes
    'pencil': 'pencil',
    'pen': 'pencil',
    'write': 'pencil',
    'writing': 'pencil',
    'likhna': 'pencil',
    'notes': 'pencil',
    'diary': 'pencil',
    'journal': 'pencil',
    'لکھنا': 'pencil',

    // Shopping & Market
    'shopping': 'shopping',
    'market': 'shopping',
    'bazaar': 'shopping',
    'grocery': 'shopping',
    'sauda': 'shopping',
    'kharidari': 'shopping',
    'بازار': 'shopping',
    'خریداری': 'shopping',

    // Sleep & Night
    'sleep': 'moon',
    'sleeping': 'moon',
    'nap': 'moon',
    'rest': 'moon',
    'sona': 'moon',
    'aram': 'moon',
    'bed': 'moon',
    'night': 'moon',
    'سونا': 'moon',
    'آرام': 'moon',

    // Music & Audio
    'music': 'music',
    'song': 'music',
    'listen': 'music',
    'gana': 'music',
    'nasheed': 'music',
    'podcast': 'music',

    // Call & Communication
    'call': 'phone',
    'phone': 'phone',
    'contact': 'phone',
    'rabta': 'phone',
    'رابطہ': 'phone',
  };

  /// Match task title to an icon key. Case-insensitive and trimmed.
  static String matchTitle(String title) {
    if (title.trim().isEmpty) return defaultIconKey;

    final lower = title.toLowerCase().trim();
    final words = lower.split(RegExp(r'\s+'));

    // 1. Direct multi-word matches
    for (final entry in _keywordMap.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }

    // 2. Individual word matches
    for (final word in words) {
      final cleaned = word.replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), '');
      if (_keywordMap.containsKey(cleaned)) {
        return _keywordMap[cleaned]!;
      }
    }

    return defaultIconKey;
  }

  /// Get AppIconItem directly from task title
  static AppIconItem getIconForTitle(String title) {
    final key = matchTitle(title);
    return AppIcons.getByKey(key);
  }
}
