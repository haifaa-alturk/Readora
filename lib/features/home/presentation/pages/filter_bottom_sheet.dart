
// import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:library_app1/core/language/app_localizations.dart';
// import 'package:library_app1/features/settings/presentation/bloc/settings_bloc.dart';
// import 'package:library_app1/features/settings/presentation/bloc/settings_state.dart';

// class FilterBottomSheet extends StatefulWidget {
//   const FilterBottomSheet({super.key});

//   @override
//   State<FilterBottomSheet> createState() => _FilterBottomSheetState();
// }

// class _FilterBottomSheetState extends State<FilterBottomSheet> {
//   String? _selectedLanguage;
//   final TextEditingController _authorCtrl = TextEditingController();
//   final TextEditingController _pagesFromCtrl = TextEditingController();
//   final TextEditingController _pagesToCtrl = TextEditingController();

//   // 🔘 تحديد نوع السعر: true للبيع (شراء)، false للإيجار (استعارة)
//   bool _isSellingPrice = true;

//   // 💰 نطاقات الأسعار المنفصلة
//   RangeValues _sellingPriceRange = const RangeValues(0, 100000);
//   RangeValues _rentalPriceRange = const RangeValues(0, 50000);

//   final List<String> _languages = ['arabic', 'english', 'french'];

//   @override
//   void dispose() {
//     _authorCtrl.dispose();
//     _pagesFromCtrl.dispose();
//     _pagesToCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // 💡 الحصول على لغة التطبيق الحالية
//     final settingsState = context.watch<SettingsBloc>().state;
//     final lang = settingsState is SettingsLoaded ? settingsState.language : 'en';

//     // تحديد قيم النطاق الحالي بناءً على التبويب المختار
//     RangeValues currentRange = _isSellingPrice ? _sellingPriceRange : _rentalPriceRange;


//     return Container(
//       padding: EdgeInsets.only(
//         top: 24,
//         left: 20,
//         right: 20,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 24,
//       ),
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // مؤشر السحب العلوي
//             Center(
//               child: Container(
//                 width: 50,
//                 height: 5,
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(93, 165, 0, 146),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             Center(
//               child: Text(
//                 context.tr("search", lang),
//                 style: const TextStyle(
//                   color: Color.fromARGB(255, 216, 14, 203),
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),

//             // ✍️ فلتر اسم المؤلف
//             Text(
//               context.tr("search_by_author", lang),
//               style: const TextStyle(
//                 color: Color.fromARGB(255, 154, 2, 143),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _authorCtrl,
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: context.tr("author", lang),
//                 hintStyle: const TextStyle(color: Colors.white54),
//                 filled: true,
//                 fillColor: const Color.fromARGB(255, 254, 163, 236),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//                 prefixIcon: const Icon(Icons.person_search, color: Colors.white70),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // 🌍 فلتر اللغة
//             Text(
//               context.tr("book_language", lang),
//               style: const TextStyle(
//                 color: Color.fromARGB(255, 154, 2, 143),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             DropdownButton<String>(
//               value: _selectedLanguage,
//               isExpanded: true,
//               dropdownColor: const Color.fromARGB(255, 240, 255, 180),
//               style: const TextStyle(color: Color.fromARGB(255, 119, 14, 126)),
//               hint: Text(
//                 context.tr("book_language", lang),
//                 style: const TextStyle(color: Colors.white70),
//               ),
//               items: _languages.map((l) {
//                 return DropdownMenuItem(
//                   value: l,
//                   child: Text(l.toUpperCase()),
//                 );
//               }).toList(),
//               onChanged: (val) => setState(() => _selectedLanguage = val),
//             ),
//             const SizedBox(height: 20),

//             // 📄 فلتر عدد الصفحات
//             Text(
//               context.tr("pages_count", lang),
//               style: const TextStyle(
//                 color: Color.fromARGB(255, 154, 2, 143),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _pagesFromCtrl,
//                     keyboardType: TextInputType.number,
//                     style: const TextStyle(color: Color.fromARGB(255, 84, 4, 134)),
//                     decoration: const InputDecoration(
//                       hintText: "from",
//                       hintStyle: TextStyle(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 Expanded(
//                   child: TextField(
//                     controller: _pagesToCtrl,
//                     keyboardType: TextInputType.number,
//                     style: const TextStyle(color: Color.fromARGB(255, 84, 4, 134)),
//                     decoration: const InputDecoration(
//                       hintText: "to",
//                       hintStyle: TextStyle(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 25),

//             // 🔄 زر الاختيار بين نوع السعر (بيع أو إيجار)
//             Text(
//               context.tr("language", lang), // أو المفتاح المناسب لنوع العقد
//               style: const TextStyle(
//                 color: Color.fromARGB(255, 154, 2, 143),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 // 1️⃣ خيار شراء / بيع
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => setState(() => _isSellingPrice = true),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 250),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       decoration: BoxDecoration(
//                         color: _isSellingPrice
//                             ? const Color.fromARGB(255, 240, 255, 180)
//                             : const Color.fromARGB(255, 198, 129, 235),
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: _isSellingPrice
//                             ? [
//                                 BoxShadow(
//                                   color: const Color.fromARGB(255, 240, 255, 180)
//                                       .withOpacity(0.8),
//                                   blurRadius: 12,
//                                   spreadRadius: 2,
//                                 ),
//                               ]
//                             : [],
//                       ),
//                       child: Center(
//                         child: Text(
//                           context.tr("buy_book", lang),
//                           style: const TextStyle(
//                             color: Color.fromARGB(255, 69, 0, 55),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),

//                 // 2️⃣ خيار استعارة / إيجار
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => setState(() => _isSellingPrice = false),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 250),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       decoration: BoxDecoration(
//                         color: !_isSellingPrice
//                             ? const Color.fromARGB(255, 240, 255, 180)
//                             : const Color.fromARGB(255, 198, 129, 235),
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: !_isSellingPrice
//                             ? [
//                                 BoxShadow(
//                                   color: const Color.fromARGB(255, 240, 255, 180)
//                                       .withOpacity(0.8),
//                                   blurRadius: 12,
//                                   spreadRadius: 2,
//                                 ),
//                               ]
//                             : [],
//                       ),
//                       child: Center(
//                         child: Text(
//                           context.tr("borrow_book", lang),
//                           style: const TextStyle(
//                             color: Color.fromARGB(255, 69, 0, 55),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // 💰 شريط السعر المتغير ديناميكياً
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   _isSellingPrice
//                       ? context.tr("buy_price", lang)
//                       : context.tr("rent_price", lang),
//                   style: const TextStyle(
//                     color: Color.fromARGB(255, 255, 252, 252),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   "${currentRange.start.round()} - ${currentRange.end.round()} ${context.tr('syp', lang)}",
//                   style: const TextStyle(
//                     color: Color.fromARGB(255, 233, 0, 221),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             RangeSlider(
//               values: currentRange,
//               min: 0,
//               max: 100000,
//               divisions: 100,
//               activeColor: const Color.fromARGB(255, 128, 118, 174),
//               inactiveColor: const Color.fromARGB(139, 243, 0, 211),
//               onChanged: (RangeValues values) {
//                 setState(() {
//                   if (_isSellingPrice) {
//                     _sellingPriceRange = values;
//                   } else {
//                     _rentalPriceRange = values;
//                   }
//                 });
//               },
//             ),
//             const SizedBox(height: 30),

//             // زر تطبيق الفلترة
//             SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 128, 118, 174),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//                 onPressed: () {
     
//                   Navigator.pop(context, {
//                     'author_name': _authorCtrl.text.isEmpty ? null : _authorCtrl.text,
//                     'language': _selectedLanguage,
//                     'pages_from': int.tryParse(_pagesFromCtrl.text),
//                     'pages_to': int.tryParse(_pagesToCtrl.text),
     
//                     'selling_price_from': _isSellingPrice ? _sellingPriceRange.start : null,
//                     'selling_price_to': _isSellingPrice ? _sellingPriceRange.end : null,
//                     'rental_price_from': !_isSellingPrice ? _rentalPriceRange.start : null,
//                     'rental_price_to': !_isSellingPrice ? _rentalPriceRange.end : null,
//                   });
//                 },
//                 child: Text(
//                   context.tr("search", lang),
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/core/language/app_localizations.dart';
import 'package:library_app1/features/home/presentation/bloc/Search_Bloc/search_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Search_Bloc/search_event.dart';
import 'package:library_app1/features/home/presentation/bloc/Search_Bloc/search_statet.dart';
import 'package:library_app1/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:library_app1/features/settings/presentation/bloc/settings_state.dart';

class FilterBottomSheet extends StatefulWidget {
  final String? initialAuthorName;
  final String? initialLanguage;
  final int? initialPagesFrom;
  final int? initialPagesTo;

  const FilterBottomSheet({
    super.key,
    this.initialAuthorName,
    this.initialLanguage,
    this.initialPagesFrom,
    this.initialPagesTo,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedLanguage;
  int? _selectedAuthorId;

  late TextEditingController _authorCtrl;
  late TextEditingController _pagesFromCtrl;
  late TextEditingController _pagesToCtrl;

 
  bool _isSellingPrice = true;

 
  RangeValues _sellingPriceRange = const RangeValues(0, 100000);
  RangeValues _rentalPriceRange = const RangeValues(0, 50000);

  final List<String> _languages = ['arabic', 'english', 'french'];

  @override
  void initState() {
    super.initState();
    _authorCtrl = TextEditingController(text: widget.initialAuthorName ?? '');
    _pagesFromCtrl = TextEditingController(text: widget.initialPagesFrom?.toString() ?? '');
    _pagesToCtrl = TextEditingController(text: widget.initialPagesTo?.toString() ?? '');
    _selectedLanguage = widget.initialLanguage;
  }

  @override
  void dispose() {
    _authorCtrl.dispose();
    _pagesFromCtrl.dispose();
    _pagesToCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
 
    final settingsState = context.watch<SettingsBloc>().state;
    final lang = settingsState is SettingsLoaded ? settingsState.language : 'en';


    RangeValues currentRange = _isSellingPrice ? _sellingPriceRange : _rentalPriceRange;


    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
  
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(93, 165, 0, 146),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Text(
                context.tr("search", lang),
                style: const TextStyle(
                  color: Color.fromARGB(255, 216, 14, 203),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 25),

  
            Text(
              context.tr("search_by_author", lang),
              style: const TextStyle(
                color: Color.fromARGB(255, 154, 2, 143),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _authorCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: context.tr("author", lang),
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 254, 163, 236),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.person_search, color: Colors.white70),
                    suffixIcon: _authorCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white70),
                            onPressed: () {
                              setState(() {
                                _authorCtrl.clear();
                                _selectedAuthorId = null;
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (val) {
                    setState(() {
                      _selectedAuthorId = null;
                    });
                    if (val.trim().length >= 2) {
                      context.read<SearchBloc>().add(FetchAuthorSuggestions(val));
                    }
                  },
                ),

                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is AuthorSuggestionsSuccess &&
                        state.authors.isNotEmpty &&
                        _authorCtrl.text.isNotEmpty &&
                        _selectedAuthorId == null) {
                      return Container(
                        height: 180,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 120, 30, 115),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.authors.length,
                          itemBuilder: (context, index) {
                            final author = state.authors[index];
                            return ListTile(
                              dense: true,
                              title: Text(
                                author.authorName,
                                style: const TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                setState(() {
                                  _authorCtrl.text = author.authorName;
                                  _selectedAuthorId = author.id;
                                });
                              },
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

  
            Text(
              context.tr("book_language", lang),
              style: const TextStyle(
                color: Color.fromARGB(255, 154, 2, 143),
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: _selectedLanguage,
              isExpanded: true,
              dropdownColor: const Color.fromARGB(255, 240, 255, 180),
              style: const TextStyle(color: Color.fromARGB(255, 119, 14, 126)),
              hint: Text(
                context.tr("book_language", lang),
                style: const TextStyle(color: Colors.white70),
              ),
              items: _languages.map((l) {
                return DropdownMenuItem(
                  value: l,
                  child: Text(l.toUpperCase()),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedLanguage = val),
            ),
            const SizedBox(height: 20),

   
            Text(
              context.tr("pages_count", lang),
              style: const TextStyle(
                color: Color.fromARGB(255, 154, 2, 143),
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pagesFromCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Color.fromARGB(255, 84, 4, 134)),
                    decoration: const InputDecoration(
                      hintText: "from",
                      hintStyle: TextStyle(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: _pagesToCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Color.fromARGB(255, 84, 4, 134)),
                    decoration: const InputDecoration(
                      hintText: "to",
                      hintStyle: TextStyle(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

   
            Row(
              children: [
    
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isSellingPrice = true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isSellingPrice
                            ? const Color.fromARGB(255, 240, 255, 180)
                            : const Color.fromARGB(255, 198, 129, 235),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: _isSellingPrice
                            ? [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 240, 255, 180)
                                      .withOpacity(0.8),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          context.tr("buy_book", lang),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 69, 0, 55),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
   
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isSellingPrice = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isSellingPrice
                            ? const Color.fromARGB(255, 240, 255, 180)
                            : const Color.fromARGB(255, 198, 129, 235),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: !_isSellingPrice
                            ? [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 240, 255, 180)
                                      .withOpacity(0.8),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          context.tr("borrow_book", lang),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 69, 0, 55),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

  
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isSellingPrice
                      ? context.tr("buy_price", lang)
                      : context.tr("rent_price", lang),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 252, 252),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${currentRange.start.round()} - ${currentRange.end.round()} ${context.tr('syp', lang)}",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 233, 0, 221),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            RangeSlider(
              values: currentRange,
              min: 0,
              max: 100000,
              divisions: 100,
              activeColor: const Color.fromARGB(255, 128, 118, 174),
              inactiveColor: const Color.fromARGB(139, 243, 0, 211),
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

    
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 128, 118, 174),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  final String? finalAuthorName = _authorCtrl.text.trim().isNotEmpty
                      ? _authorCtrl.text.trim()
                      : null;

                  Navigator.pop(context, {
                    'author_id': _selectedAuthorId,
                    'author_name': finalAuthorName, // ✅ إصلاح إرجاع اسم المؤلف
                    'language': _selectedLanguage,
                    'pages_from': int.tryParse(_pagesFromCtrl.text),
                    'pages_to': int.tryParse(_pagesToCtrl.text),
                    'selling_price_from':
                        _isSellingPrice ? _sellingPriceRange.start : null,
                    'selling_price_to':
                        _isSellingPrice ? _sellingPriceRange.end : null,
                    'rental_price_from':
                        !_isSellingPrice ? _rentalPriceRange.start : null,
                    'rental_price_to':
                        !_isSellingPrice ? _rentalPriceRange.end : null,
                  });
                },
                child: Text(
                  context.tr("search", lang),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}