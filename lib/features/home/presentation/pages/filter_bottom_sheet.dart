// import 'package:flutter/material.dart';

// class FilterBottomSheet extends StatefulWidget {
//   const FilterBottomSheet({super.key});

//   @override
//   State<FilterBottomSheet> createState() => _FilterBottomSheetState();
// }

// class _FilterBottomSheetState extends State<FilterBottomSheet> {
//   String? _selectedLanguage;
//   final TextEditingController _pagesFromCtrl = TextEditingController();
//   final TextEditingController _pagesToCtrl = TextEditingController();

//   // 💰 متغيرات شريط السعر الذكي (القيم الافتراضية للبحث)
//   RangeValues _currentPriceRange = const RangeValues(0, 500); 

//   final List<String> _languages = ['arabic', 'english', 'french'];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//         top: 20, left: 20, right: 20,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//       ),
//       decoration: const BoxDecoration(
//         color: Color.fromARGB(255, 48, 68, 118),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Center(
//               child: Text(
//                 "تصفية مخصصة للكتب",
//                 style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 20),
            
//             // 🌍 فلتر اللغة
//             const Text("اللغة", style: TextStyle(color: Colors.white70)),
//             DropdownButton<String>(
//               value: _selectedLanguage,
//               isExpanded: true,
//               dropdownColor: const Color.fromARGB(255, 38, 54, 94),
//               style: const TextStyle(color: Colors.white),
//               hint: const Text("اختر لغة الكتاب", style: TextStyle(color: Colors.white38)),
//               items: _languages.map((lang) {
//                 return DropdownMenuItem(value: lang, child: Text(lang.toUpperCase()));
//               }).toList(),
//               onChanged: (val) => setState(() => _selectedLanguage = val),
//             ),
//             const SizedBox(height: 15),

//             // 📄 فلتر عدد الصفحات
//             const Text("عدد الصفحات", style: TextStyle(color: Colors.white70)),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _pagesFromCtrl,
//                     keyboardType: TextInputType.number,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: const InputDecoration(hintText: "من", hintStyle: TextStyle(color: Colors.white38)),
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 Expanded(
//                   child: TextField(
//                     controller: _pagesToCtrl,
//                     keyboardType: TextInputType.number,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: const InputDecoration(hintText: "إلى", hintStyle: TextStyle(color: Colors.white38)),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 25),

//             // 💰 شريط اختيار السعر الذكي (من - إلى)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("نطاق السعر", style: TextStyle(color: Colors.white70)),
//                 Text(
//                   "من \$${_currentPriceRange.start.round()} إلى \$${_currentPriceRange.end.round()}",
//                   style: const TextStyle(color: Color.fromARGB(255, 180, 208, 219), fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 5),
//             RangeSlider(
//               values: _currentPriceRange,
//               min: 0,
//               max: 90000, // يمكنكِ تعديل الحد الأقصى للسعر بناءً على بيانات الباك إند
//               divisions: 100,
//               activeColor: const Color.fromARGB(255, 128, 118, 174),
//               inactiveColor: Colors.white24,
//               labels: RangeLabels(
//                 '\$${_currentPriceRange.start.round()}',
//                 '\$${_currentPriceRange.end.round()}',
//               ),
//               onChanged: (RangeValues values) {
//                 setState(() {
//                   _currentPriceRange = values;
//                 });
//               },
//             ),
//             const SizedBox(height: 30),

//             // زر تطبيق الفلترة
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 236, 196, 237),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context, {
//                     'language': _selectedLanguage,
//                     'pages_from': int.tryParse(_pagesFromCtrl.text),
//                     'pages_to': int.tryParse(_pagesToCtrl.text),
//                     // تمرير قيم شريط التمرير بدقة متناهية للباك إند
//                     'price_from': _currentPriceRange.start,
//                     'price_to': _currentPriceRange.end,
//                   });
//                 },
//                 child: const Text("تطبيق الفلترة", style: TextStyle(color: Colors.white, fontSize: 16)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedLanguage;
  final TextEditingController _authorCtrl = TextEditingController();
  final TextEditingController _pagesFromCtrl = TextEditingController();
  final TextEditingController _pagesToCtrl = TextEditingController();
  
  // 🔘 تحديد نوع السعر: true للبيع (شراء)، false للإيجار (استعارة)
  bool _isSellingPrice = true; 

  // 💰 نطاقات الأسعار المنفصلة
  RangeValues _sellingPriceRange = const RangeValues(0, 1000); 
  RangeValues _rentalPriceRange = const RangeValues(0, 500); 

  final List<String> _languages = ['arabic', 'english', 'french'];

  @override
  Widget build(BuildContext context) {
    // تحديد قيم النطاق الحالي بناءً على التبويب المختار
    RangeValues currentRange = _isSellingPrice ? _sellingPriceRange : _rentalPriceRange;
    double maxPrice = _isSellingPrice ? 1000 : 500;

    return Container(
      padding: EdgeInsets.only(
        top: 24, left: 20, right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 48, 68, 118),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // مؤشر السحب العلوي
            Center(
              child: Container(
                width: 50, height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24, 
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Center(
              child: Text(
                "تصفية متقدمة",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 25),

            // ✍️ فلتر اسم المؤلف
            const Text("اسم المؤلف", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _authorCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "ابحث باسم كاتب معين...",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color.fromARGB(255, 38, 54, 94),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.person_search, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 20),
            
            // 🌍 فلتر اللغة
            const Text("اللغة", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedLanguage,
              isExpanded: true,
              dropdownColor: const Color.fromARGB(255, 38, 54, 94),
              style: const TextStyle(color: Colors.white),
              hint: const Text("اختر لغة الكتاب", style: TextStyle(color: Colors.white38)),
              items: _languages.map((lang) {
                return DropdownMenuItem(value: lang, child: Text(lang.toUpperCase()));
              }).toList(),
              onChanged: (val) => setState(() => _selectedLanguage = val),
            ),
            const SizedBox(height: 20),

            // 📄 فلتر عدد الصفحات
            const Text("عدد الصفحات", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pagesFromCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(hintText: "من", hintStyle: TextStyle(color: Colors.white38)),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: _pagesToCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(hintText: "إلى", hintStyle: TextStyle(color: Colors.white38)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // 🔄 تحسين التصميم: زر الاختيار بين نوع السعر (بيع أو إيجار)
            const Text("نوع المعاملة المادية", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text("شراء / بيع")),
                    selected: _isSellingPrice,
                    selectedColor: const Color.fromARGB(255, 128, 118, 174),
                    backgroundColor: const Color.fromARGB(255, 38, 54, 94),
                    labelStyle: TextStyle(color: _isSellingPrice ? Colors.white : Colors.white60, fontWeight: FontWeight.bold),
                    onSelected: (val) => setState(() => _isSellingPrice = true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text("استعارة / إيجار")),
                    selected: !_isSellingPrice,
                    selectedColor: const Color.fromARGB(255, 128, 118, 174),
                    backgroundColor: const Color.fromARGB(255, 38, 54, 94),
                    labelStyle: TextStyle(color: !_isSellingPrice ? Colors.white : Colors.white60, fontWeight: FontWeight.bold),
                    onSelected: (val) => setState(() => _isSellingPrice = false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 💰 شريط السعر المتغير ديناميكياً
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isSellingPrice ? "نطاق سعر البيع" : "نطاق سعر الإيجار", 
                  style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                Text(
                  "من SYP${currentRange.start.round()} إلى SYP${currentRange.end.round()}",
                  style: const TextStyle(color: Color.fromARGB(255, 180, 208, 219), fontWeight: FontWeight.bold),
                ),
              ],
            ),
            RangeSlider(
              values: currentRange,
              min: 0, 
              max: 100000,
              divisions: 100,
              activeColor: const Color.fromARGB(255, 128, 118, 174),
              inactiveColor: Colors.white24,
              onChanged: (RangeValues values) {
                setState(() {
                  if (_isSellingPrice) {
                    _sellingPriceRange = values;
                  } else {
                    _rentalPriceRange = values;
                  }
                });
              },
            ),
            const SizedBox(height: 30),

            // زر تطبيق الفلترة
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 128, 118, 174),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  // نمرر البيانات للـ SearchScreen مع إرسال القيم الفارغة (null) للنوع الآخر غير المحدد
                  Navigator.pop(context, {
                    'author_name': _authorCtrl.text.isEmpty ? null : _authorCtrl.text,
                    'language': _selectedLanguage,
                    'pages_from': int.tryParse(_pagesFromCtrl.text),
                    'pages_to': int.tryParse(_pagesToCtrl.text),
                    
                    // إذا اختار بيع نرسل قيم البيع ونلغي الإيجار، والعكس صحيح ليتوافق مع الـ Request في Laravel
                    'selling_price_from': _isSellingPrice ? _sellingPriceRange.start : null,
                    'selling_price_to': _isSellingPrice ? _sellingPriceRange.end : null,
                    'rental_price_from': !_isSellingPrice ? _rentalPriceRange.start : null,
                    'rental_price_to': !_isSellingPrice ? _rentalPriceRange.end : null,
                  });
                },
                child: const Text("تطبيق الفلترة والبحث", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}