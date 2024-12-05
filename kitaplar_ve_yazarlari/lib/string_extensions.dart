extension StringExtensions on String {
  String str(String lang) {
    return translations[lang]?[this] ?? "no_translation";
  }
}

const Map<String, Map<String, String>> translations = {
  'tr': {
    'lugat1': 'Kütüphane',
    'lugat2': 'Kantin',
    'lab': 'Laboratuvar',
    'classroom': 'Sınıf',
    "bedroom": "Yatak Odası",
    "kitchen": "Mutfak",
    "living_room": "Oturma Odası",
    "children_room": "Çocuk Odası"
  },
  'ar': {
    'lugat1': 'مكتبة',
    'lugat2': 'مقصف',
    'lab': 'مختبر',
    'classroom': 'صف',
    "bedroom": "غرفة النوم",
    "kitchen": "مطبخ",
    "living_room": "غرفة الجلوس",
    "children_room": "غرفة الأطفال"
  }
};
